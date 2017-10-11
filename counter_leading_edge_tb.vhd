--testbench for counter with leading edge detector
--pulse generator is included that is used to trigger counter to count
--counter is still clocked by 20MHz clk

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity counter_leading_edge_tb is

end counter_leading_edge_tb;

architecture a1 of counter_leading_edge_tb is 

	component counter_leading_edge is
		port ( clk    : in std_logic;
		       reset  : in std_logic;
		       data   : in std_logic;
		       output : out std_logic_vector (3 downto 0)
		      );
	end component;

Constant CLK_PERIOD: TIME := 50 ns;
Constant SIM_LENGTH: TIME := 500000 ns;

signal clk: std_logic;
signal reset: std_logic;
signal data: std_logic;
signal output: std_logic_vector (3 downto 0);



	begin 
	cnt: counter_leading_edge port map (data => data,  --instantiates counter_L_E
					    clk => clk,
					    reset => reset,
				 	    output => output);

	
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
	main: process 
              	begin
                	data <= '0';
			wait for 200 ns;
			data <= '1';
			wait for 100 ns;
			data <= '0';
			wait for 500 ns;
			data <= '1';
			wait for 200 ns;
			data <= '0';
			wait for 200 ns;    
			data <= '1';   
			wait for 50 ns;    -- 1 clock cycle 
			data <= '0';
			wait for 200 ns;
			data <= '1';     
                        wait for 200 ns;
			data <= '0';
                        wait for 200 ns;
			data <= '1';     
                        wait for 200 ns;
			data <= '0';
			wait for 200 ns;
			wait;
		end process main;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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


			
		        


