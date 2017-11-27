-- Austin Milby 11/3/2017
-- 32 bit wide, 32 down to 1 multiplexer

library ieee;
use ieee.std_logic_1164.all;

entity mux_32 is
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
			 d16_in: in std_logic_vector(31 downto 0);
			 d17_in: in std_logic_vector(31 downto 0);
			 d18_in: in std_logic_vector(31 downto 0);
			 d19_in: in std_logic_vector(31 downto 0);
			 d20_in: in std_logic_vector(31 downto 0);
			 d21_in: in std_logic_vector(31 downto 0);
			 d22_in: in std_logic_vector(31 downto 0);
			 d23_in: in std_logic_vector(31 downto 0);
			 d24_in: in std_logic_vector(31 downto 0);
			 d25_in: in std_logic_vector(31 downto 0);
			 d26_in: in std_logic_vector(31 downto 0);
			 d27_in: in std_logic_vector(31 downto 0);
			 d28_in: in std_logic_vector(31 downto 0);
			 d29_in: in std_logic_vector(31 downto 0);
			 d30_in: in std_logic_vector(31 downto 0);
			 d31_in: in std_logic_vector(31 downto 0);
			 sel: in std_logic_vector(4 downto 0);
			 d_out: out std_logic_vector(31 downto 0));
end mux_32;

architecture Behavioral of mux_32 is
	begin
	
a1:	process (sel,d0_in,d1_in,d2_in,d3_in,d4_in,d5_in,d6_in,d7_in,d8_in,
					d9_in,d10_in,d11_in,d12_in,d13_in,d14_in,d15_in,d16_in,
					d17_in,d18_in,d19_in,d20_in,d21_in,d22_in,d23_in,d24_in,
					d25_in,d26_in,d27_in,d28_in,d29_in,d30_in,d31_in)
				begin 
					if sel = "00000" then
						d_out <= d0_in;
					end if;
					
					if sel = "00001" then
						d_out <= d1_in;
					end if;
						
					if sel = "00010" then
					d_out <= d2_in;
					end if;
				
					if sel = "00011" then
					d_out <= d3_in;
					end if;
				
					if sel = "00100" then
					d_out <= d4_in;
					end if;
				
					if sel = "00101" then
					d_out <= d5_in;
					end if;
				
					if sel = "00110" then
					d_out <= d6_in;
					end if;
				
					if sel = "00111" then
					d_out <= d7_in;
					end if;
				
					if sel = "01000" then
					d_out <= d8_in;
					end if;
				
					if sel = "01001" then
					d_out <= d9_in;
					end if;
				
					if sel = "01010" then
					d_out <= d10_in;
					end if;
				
					if sel = "01011" then
					d_out <= d11_in;
					end if;
				
					if sel = "01100" then
					d_out <= d12_in;
					end if;
				
					if sel = "01101" then
					d_out <= d13_in;
					end if;
				
					if sel = "01110" then
					d_out <= d14_in;
					end if;
				
					if sel = "01111" then
					d_out <= d15_in;
					end if;
					
					if sel = "10000" then
					d_out <= d16_in;
					end if;
					
					if sel = "10001" then
					d_out <= d17_in;
					end if;
					
					if sel = "10010" then
					d_out <= d18_in;
					end if;
					
					if sel = "10011" then
					d_out <= d19_in;
					end if;
					
					if sel = "10100" then
					d_out <= d20_in;
					end if;
					
					if sel = "10101" then
					d_out <= d21_in;
					end if;
					
					if sel = "10110" then
					d_out <= d22_in;
					end if;
					
					if sel = "10111" then
					d_out <= d23_in;
					end if;
					
					if sel = "11000" then 
					d_out <= d24_in;
					end if;
					
					if sel = "11001" then
					d_out <= d25_in;
					end if;
					
					if sel = "11010" then
					d_out <= d26_in;
					end if;
					
					if sel = "11011" then
					d_out <= d27_in;
					end if;
					
					if sel = "11100" then
					d_out <= d28_in;
					end if;
					
					if sel = "11101" then
					d_out <= d29_in;
					end if;
					
					if sel = "11110" then
					d_out <= d30_in;
					end if;
					
					if sel = "11111" then
					d_out <= d31_in;
					end if;
			end process a1;
end Behavioral;