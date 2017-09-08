-- Module 'delay_signal' - delays a signal that changes on a period 
-- by a programmable number of periods

-- E.J. - 7/17

-- useful to delay signal sequences by an integer number of their fundamental period
-- (e.g. helicity delayed by a number of helicity windows) 
  
-- 'output' is 'input' delayed by a programmed number of 'clk_ena' periods

-- 'clk_ena' period must be greater than or equal to 'clk' period

-- 'clk_ena' is required to be synchronous to 'clk' and have a width of one 'clk' period
  
-- if 'clk_ena' = '1' always, the signal is delayed by 'delay_value - 1' periods of 'clk'

-- maximum delay is smaller of 'DEPTH' and 'delay_value' ('delay_value' < 4096)
-- (in SIMULATION, programming 'delay_value' > 'DEPTH' results in a delay of 'DEPTH' - 
--  this may NOT be true in synthesis)

-- 'DEPTH' represents physical storage and must be FIXED at compile time
-- 'delay_value' may be programed after compile 

-- after setting 'delay_value' the delay chain may be promptly CLEARED by issuing a 'reset' that
-- is synchronized to the clock.  If this is not done, the output sequence is not guaranteed until
-- 'DEPTH' periods of 'clk_ena' (or 'clk', if clk_ena = '1') occur

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_signal is
	generic( DEPTH: integer );
	   port( input 	     : IN std_logic;
	         delay_value : IN std_logic_vector(11 downto 0);
	         clk_ena     : IN std_logic;
	         clk         : IN std_logic;
	         reset       : IN std_logic;
	         output	     : OUT std_logic );
end delay_signal;

architecture a1 of delay_signal is

  component dffe_1 is
	   port( d       : in std_logic;
			     clk     : in std_logic;
		       reset_n : in std_logic;
		       set_n   : in std_logic;
		       clk_ena : in std_logic;
			     q       : out std_logic);
  end component;

  component mux2 is
	port( d0_in: in std_logic;
		  d1_in: in std_logic;
			sel: in std_logic;
		  d_out: out std_logic );
  end component;

  signal reset_n: std_logic;
    
	signal a_sig: std_logic_vector(0 to DEPTH); 
	signal m_sig: std_logic_vector(0 to DEPTH); 
	signal enable: std_logic_vector(0 to DEPTH);
	
	signal temp1: unsigned(0 to DEPTH);
	signal temp2: unsigned(0 to DEPTH);
	
	signal n_bits: integer range 0 to 4095;
	 
begin
  
  reset_n <= not reset;
  
  a_sig(0) <= '0';      -- unused
  
  m_sig(0) <= input;
  output <= m_sig(DEPTH);
  
  n_bits <= to_integer(unsigned(delay_value));  -- integer delay value
  temp1 <= to_unsigned(1,(DEPTH + 1));          -- value 1 represented by DEPTH + 1 bits
  
  temp2 <= shift_left(temp1,n_bits);            -- shift value 1 to left by n_bits
  enable <= std_logic_vector(temp2);            -- convert to std_logic_vector
  
gen_delay:  
  for I in 1 to DEPTH generate
    ff: dffe_1 port map (	d => m_sig(I-1), clk => clk, reset_n => reset_n, set_n => '1', clk_ena => clk_ena, q => a_sig(I));
    mx: mux2 port map ( d0_in => a_sig(I), d1_in => input, sel => enable(I), d_out => m_sig(I) );
  end generate gen_delay;

end a1;

