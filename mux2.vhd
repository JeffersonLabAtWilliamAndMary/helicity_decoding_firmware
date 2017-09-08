----- 2 to 1 multiplexor (1 bit wide)

-- sel = '0', d0_in -> d_out
-- sel = '1', d1_in -> d_out 

library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
	port( d0_in: in std_logic;
		  d1_in: in std_logic;
			sel: in std_logic;
		  d_out: out std_logic );
end mux2;

architecture a1 of mux2 is
begin
p1: process (sel, d0_in, d1_in)
	begin
		if sel = '0' then
			d_out <= d0_in;
		elsif sel = '1' then
			d_out <= d1_in;
		else
			d_out <= d0_in;
		end if;
	end process p1;
end a1;

