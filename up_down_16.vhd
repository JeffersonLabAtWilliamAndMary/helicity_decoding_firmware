-- Austin Milby 11/22/2017
-- Up/Down counter with 16 bit wide output
-- count_up and count_down act as clock enable 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity up_down_16 is 
	port ( count_up: in std_logic;    --assume signal is 1 clock period wide 
			 count_down: in std_logic;  --assume signal is 1 clock period wide
			 reset: in std_logic;
			 clk: in std_logic;
			 zero: out std_logic;       -- is on when count is zero (high when count=0)
			 count: out std_logic_vector(15 downto 0));
end up_down_16;

architecture Behavioral of up_down_16 is
	
signal sel: std_logic_vector(1 downto 0);
signal temp: std_logic_vector(15 downto 0);
signal zero_int: std_logic;  -- can't use output internally (inside architecture)

	begin
	
	sel <= count_down & count_up;    -- defines sel to be two bit value based on values of count_up,count_down (takes place of these two signals)
	zero_int <= '1' when (temp = x"0000") else  -- conditional statement: makes the value of zero '1' when count is 0
			  '0';
	
a1: process (clk,sel,zero_int,reset)
			begin
				if reset='1' then          --if reset=1, temp value is 0
					temp <= x"0000";
				elsif (rising_edge(clk)) then     
					case sel is 
						when "00" => temp <= temp;       -- holds count (count doesn't change)
						
						when "01" => 
							if temp = x"ffff" then
								temp <= temp;
							else temp <= temp + '1'; -- when sel 01, then temp is assigned to be temp + 1 (count up)
						   end if;
							
						when "10" => 
							if zero_int = '0' then
								temp <= temp - '1'; -- count down (only count down if count is non-zero ~ test for zero)
							else temp <= temp;
							end if;
							
						when "11" => temp <= temp;       -- hold count value
					end case;				
				end if;
	 end process a1;
	 
	count <= temp;
	zero <= zero_int;
   
end Behavioral;