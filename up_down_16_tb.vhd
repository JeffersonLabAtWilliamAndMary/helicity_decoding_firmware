-- Austin Milby 11/27/2017
-- This is a testbench file for the up_down_16 counter module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity up_down_16_tb is

end up_down_16_tb;

architecture a1 of up_down_16_tb is 

	component up_down_16 is
		port ( count_up: in std_logic;
		       count_down: in std_logic;
		       reset: in std_logic;
		       clk: in std_logic;
		       zero: out std_logic;
		       count: out std_logic_vector(15 downto 0));
	end component;

Constant CLK_PERIOD: TIME := 50 ns;
Constant SIM_LENGTH: TIME := 500000 ns;

signal count_up: std_logic;
signal count_down: std_logic;
signal reset: std_logic;
signal clk: std_logic;
signal zero: std_logic;
signal count: std_logic_vector(15 downto 0);


begin 
dut1: up_down_16 port map ( count_up => count_up,
			    count_down => count_down,
			    reset => reset,
			    clk => clk,
			    zero => zero,
			    count => count);

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
main: process
		begin 
		count_up <= '0';
		count_down <= '0';
		
		wait until (rising_edge(clk));  -- generates pulse aligned with clk
		count_up <= '1';
		wait until (rising_edge(clk));
		count_up <= '0';
		
		wait until (rising_edge(clk));
		count_down <= '1';
		wait until (rising_edge(clk));
		count_down <= '0';

		wait until (rising_edge(clk));
		count_up <= '1';
		count_down <= '1';
		wait until (rising_edge(clk));
		count_up <= '1';
		count_down <= '0';
		wait until (rising_edge(clk));
		count_up <= '0';
		count_down <= '0';
		wait until (rising_edge(clk));
		count_up <= '0';
		count_down <= '1';
		wait for 200 ns;
		wait;
	end process main;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

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