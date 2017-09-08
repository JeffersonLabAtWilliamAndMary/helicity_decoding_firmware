library ieee;
use ieee.std_logic_1164.all;

-- delay in clock periods

entity delay_module is
	generic( DELAY_VALUE : integer );
	   port( input : IN std_logic;
	         clk   : IN std_logic;
	         output: OUT std_logic );
end delay_module;

architecture a1 of delay_module is

  component dffe_1 is
	   port( d       : in std_logic;
			     clk     : in std_logic;
		       reset_n : in std_logic;
		       set_n   : in std_logic;
		       clk_ena : in std_logic;
			     q       : out std_logic);
  end component;

	signal a_sig: std_logic_vector(0 to DELAY_VALUE); 

begin
  
  a_sig(0) <= input;
  output <= a_sig(DELAY_VALUE);
  
gen_delay:  
  for I in 1 to DELAY_VALUE generate
    ff: dffe_1 port map (	d => a_sig(I-1), clk => clk, reset_n => '1', set_n => '1', clk_ena => '1', q => a_sig(I));
  end generate gen_delay;

end a1;

