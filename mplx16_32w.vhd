-- Austin Milby 9/18/2017
-- Design for 16 down to 1, 32 bit wide multiplexer 

library ieee;
use ieee.std_logic_1164.all;

entity mplx16_32w is 
	port ( d0_in: in std_logic_vector(31 downto 0);
			 d1_in: in std_logic_vector(31 downto 0);
			 d2_in: in std_logic_vector(31 downto 0);
			 d3_in: in std_logic_vector(31 downto 0);
			 d4_in: in std_logic_vector(31 downto 0);
			 d5_in: in std_logic_vector(31 downto 0);
			 d6_in: in std_logic_vector(31 downto 0);
			 d7_in: in std_logic_vector(31 downto 0);
			 d8_in: in std_logic_vector(31 downto 0);
			 d9_in: in std_logic_vector(31 downto 0);
			 d10_in: in std_logic_vector(31 downto 0);
			 d11_in: in std_logic_vector(31 downto 0);
			 d12_in: in std_logic_vector(31 downto 0);
			 d13_in: in std_logic_vector(31 downto 0);
			 d14_in: in std_logic_vector(31 downto 0);
			 d15_in: in std_logic_vector(31 downto 0);
			 sel: in std_logic_vector(3 downto 0);     
			 d_out: out std_logic_vector(31 downto 0));
end mplx16_32w;

architecture Behavioral of mplx16_32w is
	begin
	
a1:	process (sel,d0_in,d1_in,d2_in,d3_in,d4_in,d5_in,d6_in,d7_in,d8_in,
					d9_in,d10_in,d11_in,d12_in,d13_in,d14_in,d15_in)
				begin 
					if sel = "0000" then
						d_out <= d0_in;
					end if;
					
					if sel = "0001" then
						d_out <= d1_in;
					end if;
						
					if sel = "0010" then
					d_out <= d2_in;
					end if;
				
					if sel = "0011" then
					d_out <= d3_in;
					end if;
				
					if sel = "0100" then
					d_out <= d4_in;
					end if;
				
					if sel = "0101" then
					d_out <= d5_in;
					end if;
				
					if sel = "0110" then
					d_out <= d6_in;
					end if;
				
					if sel = "0111" then
					d_out <= d7_in;
					end if;
				
					if sel = "1000" then
					d_out <= d8_in;
					end if;
				
					if sel = "1001" then
					d_out <= d9_in;
					end if;
				
					if sel = "1010" then
					d_out <= d10_in;
					end if;
				
					if sel = "1011" then
					d_out <= d11_in;
					end if;
				
					if sel = "1100" then
					d_out <= d12_in;
					end if;
				
					if sel = "1101" then
					d_out <= d13_in;
					end if;
				
					if sel = "1110" then
					d_out <= d14_in;
					end if;
				
					if sel = "1111" then
					d_out <= d15_in;
					end if;
			end process a1;
end Behavioral; 