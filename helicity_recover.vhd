-- Helicity recover -  6/30/17    EJ

library ieee;
use ieee.std_logic_1164.all;

entity helicity_recover is
	  port (	enable           : in std_logic;
				   pattern_sync     : in std_logic;	
				   helicity_in      : in std_logic;	
				   clk				          : in std_logic;
				   reset			  	      : in std_logic;
				   helicity_compute : out std_logic;
				   shift_in         : out std_logic;
				   data_out         : out std_logic_vector(29 downto 0) );
end helicity_recover;
    
architecture a1 of helicity_recover is
																														    
  component shift_reg_left is
	 generic( bitlength : integer );
	   port( data_load: in std_logic_vector((bitlength - 1) downto 0);     -- parallel data loaded
	         bit_in   : in std_logic;                                      -- data bit shifted in  
	         clk      : in std_logic;
	         reset    : in std_logic;                                      -- asynchronous reset
		       load     : in std_logic;
           shift    : in std_logic;                                      -- shift left
		       bit_out  : out std_logic;                                     -- data bit shifted out
		       data_out : out std_logic_vector((bitlength - 1) downto 0) );  -- parallel data out
  end component;
														
  component delay_module is
	  generic( DELAY_VALUE : integer );
	     port( input : IN std_logic;
	           clk   : IN std_logic;
	           output: OUT std_logic );
  end component;

  component pulse_leading_edge is
	  port( signal_in : in std_logic;
				  clk       : in std_logic;
			    reset     : in std_logic;
		      pulse_out : out std_logic);
  end component;

  component dffe_1 is
	  port( d      : in std_logic;
			    clk    : in std_logic;
		      reset_n: in std_logic;
		      set_n  : in std_logic;
		      clk_ena: in std_logic;
			    q      : out std_logic);
  end component;

  signal xor1, xor2, xor3: std_logic;
  signal bit_in, shift, bit_out: std_logic;
  signal pattern_sync_del: std_logic;
	signal data_out_int: std_logic_vector(29 downto 0);
	signal data_load: std_logic_vector(31 downto 0);
	signal shift_in_int: std_logic;
	signal reset_n: std_logic;

begin

  reset_n <= not reset;
  
  shift_in <= shift_in_int;
  data_out <= data_out_int;
  
  data_load <= X"00000000";

-- delay 'pattern_sync' input
delay1: delay_module generic map ( DELAY_VALUE => 2 )
	                      port map ( input  => pattern_sync,
	                                 clk    => clk,
	                                 output => pattern_sync_del );
	                                 
-- 'shift' is single clock width pulse from the leading edge of 'pattern_sync_del'
pulse1:	pulse_leading_edge port map ( signal_in => pattern_sync_del,
				                              clk       => clk,
			                                reset     => reset,
		                                  pulse_out => shift );
		                                  
  shift_in_int <= enable and shift;   

-- shift in 'helicity_in'                   
shift1: shift_reg_left generic map( bitlength => 30 )
                          port map( data_load => data_load(29 downto 0),
	                                  bit_in    => helicity_in,  
	                                  clk       => clk,
	                                  reset     => reset,
		                                load      => '0',   -- no load - use reset value
                                    shift     => shift_in_int,
		                                bit_out   => bit_out,
		                                data_out  => data_out_int );
		                             
-- generate 'bit_in' from XORs of current 'data_out' value
    xor1 <= data_out_int(29) xor data_out_int(28);
    xor2 <= xor1 xor data_out_int(27);
    xor3 <= xor2 xor data_out_int(6);

-- latch helicity value before 'shift' generates new value
ff1: dffe_1 port map ( d       => xor3,
			                 clk     => clk,
		                   reset_n => reset_n,
		                   set_n   => '1',
		                   clk_ena => shift_in_int,
			                 q       => helicity_compute );


end a1;
	