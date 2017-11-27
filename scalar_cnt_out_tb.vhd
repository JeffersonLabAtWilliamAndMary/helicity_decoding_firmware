-- Austin Milby 11/8/2017
-- testbench file for scaler with direct count-out output


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity scalar_cnt_out_tb is

end scalar_cnt_out_tb;

architecture a1 of scalar_cnt_out_tb is

	component scalar_cnt_out is 
		port ( a : in std_logic;
		       clk : in std_logic;
		       reset : in std_logic;
		       capture : in std_logic;
		       cnt_out : out std_logic_vector(31 downto 0);
		       b : out std_logic_vector (31 downto 0));
	end component;

Constant CLK_PERIOD: TIME := 50 ns;
Constant SIM_LENGTH: TIME := 500000 ns;

--should have internal signal for all ports included in design 
signal clk: std_logic;
signal a: std_logic;
signal reset: std_logic;
signal capture: std_logic;
signal cnt_out: std_logic_vector(31 downto 0);
signal b: std_logic_vector (31 downto 0);

-- below is the instantiation of scalar_cnt_out
	begin 
	dut1: scalar_cnt_out port map ( a => a,
				   clk => clk,
				   reset => reset,
				   capture => capture,
				   cnt_out => cnt_out,
				   b => b);

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
	main: process 
		  begin 
		        a <= '0';
			wait for 200 ns;
			a <= '1';
			wait for 100 ns;
			a <= '0';
			capture <= '1';
			wait for 500 ns;
			a <= '1';
			wait for 200 ns;
			a <= '0';
			wait for 200 ns;    
			a <= '1'; 
			capture <= '0';  
			wait for 50 ns;    -- 1 clock cycle 
			a <= '0';
			wait for 200 ns;
			a <= '1';     
                        wait for 200 ns;
			a <= '0';
                        wait for 200 ns;
			a <= '1';
			capture <= '1';     
                        wait for 200 ns;
			a <= '0';
			wait for 200 ns;
			a <= '1';
			wait for 200 ns;
			a <= '0';
			wait for 200 ns;
			a <= '1';
			wait for 200 ns;
			a <= '0';
			wait for 200 ns;
			wait;
		end process main;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

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