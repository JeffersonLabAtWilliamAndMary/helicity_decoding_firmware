----- TITLE "leading edge pulse generator  -  1/11/2010, 10/03/2011   EJ"

----- generates a single clock period pulse 'pulse_out' in response 
-----    to the leading edge of input 'signal_in'
----- 'signal_in' is assumed to be synchronous to input 'clk'
----- 'signal_in' must return to its de-asserted state before 'pulse_out'
-----    can be generated again

library ieee;
use ieee.std_logic_1164.all;

entity pulse_leading_edge is
	port( signal_in: in std_logic;
				clk: in std_logic;
			  reset: in std_logic;
		  pulse_out: out std_logic);
end pulse_leading_edge;

architecture a1 of pulse_leading_edge is
	
	type state_type is (s0,s1,s2);
	signal ps,ns: state_type;
	
begin

p1: process (reset,clk)
	begin
		if reset = '1' then
			ps <= s0;
		elsif rising_edge(clk) then
			ps <= ns;
		end if;
	end process p1;
	
p2: process (ps,signal_in)
	begin
		case ps is
			when s0 =>
				pulse_out <= '0';
				if signal_in = '1' then
					ns <= s1;
				else
					ns <= s0;
				end if;
				
			when s1 =>
				pulse_out <= '1';
				if signal_in = '0' then
					ns <= s0;
				else
					ns <= s2;
				end if;
				
			when s2 =>
				pulse_out <= '0';
				if signal_in = '0' then
					ns <= s0;
				else
					ns <= s2;
				end if;
				
			when others =>
				pulse_out <= '0';
				ns <= s0;
		end case;
	end process p2;

end a1;

