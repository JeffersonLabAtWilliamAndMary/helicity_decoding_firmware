-- This file will be the code for a 32 bit wide register made from 
-- 32 d flipflops to be used in recording the history of the signals
-- of interest. The design also includes an enable.

library ieee;
use ieee.std_logic_1164.all;

entity dffe_32 is 
	port( d: in std_logic_vector(31 downto 0);
			clk: in std_logic;
			reset: in std_logic;
			clk_enable: in std_logic;
			set: in std_logic;
			q: out std_logic_vector(31 downto 0));
end dffe_32;

architecture Behavioral of dffe_32 is
	begin
		process (clk,reset,clk_enable)  -- when an item in process sensitivity list changes, all statements in process are re-evaluated
			begin 
				if reset = '1' then 
					q <= x"00000000";					--using hexadecimal ease of use
				elsif set = '1' then 
						q <= x"ffffffff";
				elsif rising_edge(clk) then
					if clk_enable = '1' then
						q <= d;
					end if;	
				end if;
		end process;
end Behavioral;

					