-- Austin Milby 9/29/2017
-- Test bench for FIFO state machine

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity fifo_delay_state_tb is

end fifo_delay_state_tb;

architecture a1 of fifo_delay_state_tb is

	component fifo_delay_state is
		port (   load: in std_logic;
			 latency: in std_logic_vector(10 downto 0);
			 num_words: in std_logic_vector(10 downto 0);
			 empty_flag: in std_logic;
			 clk: in std_logic;
			 reset: in std_logic;
			 configured: out std_logic;
			 wrt_ena: out std_logic;
			 rd_ena: out std_logic);
	end component;

Constant CLK_PERIOD: TIME := 50 ns;
Constant SIM_LENGTH: TIME := 500000 ns;

signal load: std_logic;
signal latency: std_logic_vector(10 downto 0);
signal num_words: std_logic_vector(10 downto 0);
signal empty_flag: std_logic;
signal clk: std_logic;
signal reset: std_logic;
signal configured: std_logic;
signal wrt_ena: std_logic;
signal rd_ena: std_logic;

begin 

dut: fifo_delay_state port map ( load => load,
				 latency => latency,
				 num_words => num_words,
				 empty_flag => empty_flag,
				 clk => clk,
				 reset => reset,
				 configured => configured,
				 wrt_ena => wrt_ena,
				 rd_ena => rd_ena);

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

main: process 
		begin 
		load <= '0';
		latency <= "00000001000";
		num_words <= "00000000000";
		wait for 1000 ns;
		load <= '1';
		wait for 100 ns;
		load <= '0';
		wait for 1000 ns;
		num_words <= "00000001000";
		wait for 4000 ns;
		latency <= "00000010000";
		wait for 100 ns;
		load <= '1';
		wait for 100 ns;
		load <= '0';
		wait for 4000 ns;
		num_words <= "00000010000";
		wait for 1000 ns;
		wait;
	end process main;
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

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
