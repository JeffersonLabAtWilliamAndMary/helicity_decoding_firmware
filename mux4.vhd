----- 4 to 1 multiplexor (1 bit wide)

-- sel = "00", d0_in -> d_out
-- sel = "01", d1_in -> d_out 
-- sel = "10", d2_in -> d_out 
-- sel = "11", d3_in -> d_out 

library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
	port( d0_in: in std_logic;
		  d1_in: in std_logic;
		  d2_in: in std_logic;
		  d3_in: in std_logic;
			sel: in std_logic_vector(1 downto 0);
		  d_out: out std_logic );
end mux4;

architecture a1 of mux4 is
begin
p1: process (sel, d0_in, d1_in, d2_in, d3_in)
	begin
		if sel = "00" then
			d_out <= d0_in;
		elsif sel = "01" then
			d_out <= d1_in;
		elsif sel = "10" then
			d_out <= d2_in;
		elsif sel = "11" then
			d_out <= d3_in;
		else
			d_out <= d0_in;
		end if;
	end process p1;
end a1;

