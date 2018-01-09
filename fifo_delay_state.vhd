-- Austin Milby 9/21/2017
-- design for FIFO (first in first out) delay using state machine

library ieee;
use ieee.std_logic_1164.all;

entity fifo_delay_state is 
	port ( load: in std_logic;
			 latency: in std_logic_vector(10 downto 0);
			 num_words: in std_logic_vector(10 downto 0);
			 empty_flag: in std_logic;
			 clk: in std_logic;
			 reset: in std_logic;
			 configured: out std_logic;
			 wrt_ena: out std_logic;
			 rd_ena: out std_logic);
end fifo_delay_state;

architecture Behavioral of fifo_delay_state is 
	
	type state_type is (s0,s1,s2,s3);    -- user created type for the states
	signal ps,ns: state_type;            -- assigns the signals ps and ns to be of type "state_type"
	
begin

p1: process (clk,reset)         -- this process will be included verbaitum
		begin
			if reset = '1' then
				ps <= s0;
			elsif rising_edge(clk) then
				ps <= ns;
			end if;
		end process p1;
		
p2: process (ps,load,num_words,latency,empty_flag)
		begin
			case ps is
				when s0 =>
					configured <= '0';
					wrt_ena <= '0';
					rd_ena <= '0';
					if load = '1' then
						ns <= s1;
					else
						ns <= s0;
					end if;
				
				when s1 => 
					configured <= '0';
					wrt_ena <= '1';
					rd_ena <= '0';
					if num_words = latency then 
						ns <= s2;
					else ns <= s1;
					end if;
					
				when s2 => 
					configured <= '1';
					wrt_ena <= '1';
					rd_ena <= '1';
					if load = '1' then
						ns <= s3;
					else ns <= s2;
					end if;
					
				when s3 => 
					configured <= '0';
					wrt_ena <= '0';
					rd_ena <= '1';
					if empty_flag = '1' then
						ns <= s1;
					else ns <= s3;
				end if;
			end case;
	end process p2;
end Behavioral;
	
		

			 