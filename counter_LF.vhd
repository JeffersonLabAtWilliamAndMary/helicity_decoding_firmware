-- Austin Milby 11/6/2017
-- Counter with mode to switch between Leading and Falling edge detection

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter_LF is
	port ( clk: in std_logic;
		    reset: in std_logic;
		    data: in std_logic;
		    mode: in std_logic;      -- new input to select leading/falling
		    output: out std_logic_vector(31 downto 0));
end counter_LF;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------			 
architecture Behavioral of counter_LF is
	signal temp: std_logic_vector(31 downto 0);
	signal pulse,q,pulse_1,pulse_2: std_logic;
	
	begin
a1:  process(clk,reset)
			begin 
				if reset='1' then          --if reset=1, temp value is 0
					temp <= x"00000000";
				elsif (rising_edge(clk)) then     
					if pulse='1' then         -- kind of acts like count enable
					temp <= temp + 1;
					end if;
				end if;
	end process a1;
	
	output <= temp;

	
a2: process (clk,reset)
			begin
				if reset = '1' then
					q <= '0';
				elsif rising_edge(clk) then 
					q <= data;
				end if;
	 end process a2;
		
-- This will generate the pulse needed that makes counter count and 
-- keeps counter synchronous  	
--	pulse <= data and (not q);

	
a3: process (mode,data,q,pulse_1,pulse_2)
			begin
				if mode = '0' then
					pulse <= pulse_1;
				elsif mode = '1' then
					pulse <= pulse_2;
				end if;
	 end process a3;
					
pulse_1 <= data and (not q);  -- leading edge pulse

pulse_2 <= (not data) and q;  -- falling edge pulse
	
end Behavioral;