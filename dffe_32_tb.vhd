-- Test bench file for 32 bit register 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity dffe_32_tb is

end dffe_32_tb;

architecture a1 of dffe_32_tb is

component dffe_32 is
	port ( d: in std_logic_vector(31 downto 0);
	       clk: in std_logic;
	       reset: in std_logic;
	       clk_enable: in std_logic;
	       set: in std_logic;
	       q: out std_logic_vector(31 downto 0));
end component;

constant CLK_PERIOD: TIME := 50 ns;
constant SIM_LENGTH: TIME := 500000 ns;

signal d: std_logic_vector(31 downto 0);
signal clk: std_logic;
signal reset: std_logic;
signal set: std_logic;
signal clk_enable: std_logic;
signal q: std_logic_vector(31 downto 0);

	begin
	flipflop: dffe_32 port map ( d => d,
				     clk => clk,
				     reset => reset,
				     set => set,
				     clk_enable => clk_enable,
				     q => q);

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
	main: process
		begin
		    d <= x"00000000";
		wait for 200 ns;
		d <= x"00000001";
		clk_enable <= '1';
		wait for 100 ns;
		d <= x"00000000";
		--wait for 200 ns;
		--d <= x"00000002";
		wait for 500 ns;    -- used to test reset: everything before should be cleared
		d <= x"00000002";	
		wait for 200 ns;
		d <= x"00000004";
		wait for 200 ns;    
	        d <= x"0000000E"; 
		wait for 200 ns;
		d <= x"00000003";
		wait for 200 ns;    
		d <= x"00000001";   
		wait for 200 ns;
		wait;
	end process main;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
reset_pulse: process               -- generate initial asynchronous reset pulse
    begin
      reset <= '0';
      wait for 100 ns;
      reset <= '1';
      wait for 500 ns;
      reset <= '0';
      wait;
    end process reset_pulse;
      
  clk_gen: process                    -- generate 20 MHZ clock
    variable num_periods: integer;
    begin
      num_periods := SIM_LENGTH/CLK_PERIOD;
      for i in 1 to num_periods loop
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
      end loop;
      wait; 
    end process clk_gen;	
				
end a1;			
  			     