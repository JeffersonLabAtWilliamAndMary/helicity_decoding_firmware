-- Austin Milby 10/2/2017
-- Test bench for delay_data module (combine fifo_delay_state and fifo_delay)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity delay_data_tb is

end delay_data_tb;

architecture a1 of delay_data_tb is

	component delay_data is 
		port (  load                : in std_logic;                       -- load FIFO delay
          		latency           : in std_logic_vector(10 downto 0);     -- delay value in 'clock' periods
          		data_in          : in std_logic_vector(7 downto 0);        -- data in
          		clk              : in std_logic;
          		reset              : in std_logic;
          		data_out       : out std_logic_vector(7 downto 0);        -- data out
          		configured    : out std_logic ); 
	end component;

Constant CLK_PERIOD: TIME := 50 ns;
Constant SIM_LENGTH: TIME :=500000 ns;

signal load,clk,reset: std_logic;
signal latency: std_logic_vector(10 downto 0);
signal data_in: std_logic_vector(7 downto 0);
signal data_out: std_logic_vector(7 downto 0);
signal configured: std_logic;
signal count: std_logic_vector(7 downto 0);
signal data_ena: std_logic;

begin
	data_in <= count;

dut:	delay_data port map ( load => load,
			      latency => latency,
			      data_in => data_in,
			      clk => clk,
			      reset => reset,
			      data_out => data_out,
			      configured => configured);

		
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
main: process 
		begin
		load <= '0';
		latency <= "00000001000";
		data_ena <= '0';
--		data_in <= "00000000";
		--num_words <= "00000000000";
		wait for 100 ns;
		data_ena <= '1';
		wait for 1000 ns;
		load <= '1';
		wait for 100 ns;
		load <= '0';
		wait for 1000 ns;
		--num_words <= "00000001000";
		--wait for 4000 ns;
		latency <= "00000010000";
		wait for 100 ns;
		load <= '1';
		wait for 100 ns;
		load <= '0';
		wait for 4000 ns;
		--num_words <= "00000010000";
		--wait for 1000 ns;
--		data_in <= "00000001";
		wait for 500 ns;
--		data_in <= "00000010";
		wait for 500 ns;
--		data_in <= "00000100";
		wait for 500 ns;
--		data_in <= "00001000";
		wait for 500 ns;
--		data_in <= "00010000";
		wait for 500 ns;
--		data_in <= "00100000";
		wait for 500 ns;
--		data_in <= "01000000";
		wait for 500 ns;
--		data_in <= "10000000";
		wait for 1000 ns;
		wait;
	end process main;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
data: process (clk,reset,data_ena)                   -- data_in change continuously 
    begin
      if data_ena = '1' then
	if reset = '1' then
       	 count <= x"00";
	elsif rising_edge(clk) then 
	count <= count + '1';
	end if;
	end if;
    end process data;	

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
			                        
