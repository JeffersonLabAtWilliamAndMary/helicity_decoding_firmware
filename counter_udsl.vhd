----- up/down counter with synchronous load - 6/12/09 - EJ

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter_udsl is
	generic( bitlength: integer );
	port(   updown: in std_logic;
		 count_ena: in std_logic;
			 sload: in std_logic;
		      data: in std_logic_vector((bitlength - 1) downto 0);
			   clk: in std_logic;
		     reset: in std_logic;
		zero_count: out std_logic;
		 max_count: out std_logic;
		   counter: out std_logic_vector((bitlength - 1) downto 0));
end counter_udsl;
		
architecture a1 of counter_udsl is
														
	signal count_int: std_logic_vector((bitlength - 1) downto 0);
							
begin
	
p1:	process (clk, reset, updown, sload, count_ena)
	begin
		if ( reset = '1' ) then
			count_int <= (others => '0');
		elsif ( rising_edge(clk) ) then
			if ( sload = '1' ) then
				count_int <= data;
			elsif ( count_ena = '1' ) then
				if ( updown = '1' ) then
					count_int <= count_int + 1;
				else
					count_int <= count_int - 1;
				end if;	
			end if;
		end if;
	end process p1;
		
	zero_count <= '1' when (count_int = conv_std_logic_vector(0, bitlength) ) else
				  '0';

	max_count  <= '1' when (count_int = conv_std_logic_vector(2147483647, bitlength) ) else
				  '0';										  -- max 31-bit integer
				 
	counter <= count_int;
	
end a1;

