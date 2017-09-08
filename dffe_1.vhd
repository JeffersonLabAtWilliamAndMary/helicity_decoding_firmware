library ieee;
use ieee.std_logic_1164.all;

entity dffe_1 is
	port( 	  d: in std_logic;
			clk: in std_logic;
		reset_n: in std_logic;
		  set_n: in std_logic;
		clk_ena: in std_logic;
			  q: out std_logic);
end dffe_1;

architecture a1 of dffe_1 is
begin
p1: process (reset_n,set_n,clk)
	begin
		if reset_n = '0' then q <= '0';
		elsif set_n = '0' then q <= '1';
		elsif rising_edge(clk) then
			if clk_ena = '1' then q <= d;
			end if;
		end if;
	end process p1;
end a1;


		