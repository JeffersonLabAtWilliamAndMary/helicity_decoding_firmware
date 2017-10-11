--Counter with leading edge detector
--includes pulse generator that creates pulse used to trigger counter to count
--counter is still clocked using 20MHz clock, therefore is synchronous
--has asynchronous reset
--currently counts 4 bits; can be edited for more 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Counter_leading_edge is 
	port (                               --port list:lists inputs and outputs	--takes form signal_name: mode type;
		clk: in std_logic;
		reset: in std_logic;
		data: in std_logic;
		output: out std_logic_vector(31 downto 0));
end Counter_leading_edge;

--architecture body specifies how circuit operates and how it's implemented
architecture Behavioral of Counter_leading_edge is
	signal temp: std_logic_vector(31 downto 0);
	signal pulse,q: std_logic;
	
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
	pulse <= data and (not q);
	
end Behavioral;
		