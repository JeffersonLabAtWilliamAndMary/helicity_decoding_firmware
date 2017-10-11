-- Austin Milby 9/18/2017
-- 32 bit register compatible with VME
-- Include 4 clock enables that allow access to each bite of storage individually
-- The file dffe_32 was used as model for this module (removed set)

library ieee;
use ieee.std_logic_1164.all;

entity register_vme is
	port ( d: in std_logic_vector(31 downto 0);
			 clk: in std_logic;
			 reset: in std_logic;
			 ce_0: in std_logic;
			 ce_1: in std_logic;
			 ce_2: in std_logic;
			 ce_3: in std_logic;
			 q: out std_logic_vector(31 downto 0));
end register_vme;

architecture Behavioral of register_vme is

	begin
		process (reset,clk,ce_0,ce_1,ce_2,ce_3)
			begin 
				if reset = '1' then
					q <= x"00000000";
				elsif rising_edge(clk) then
					
					if ce_0 = '1' then
						q(31 downto 24) <= d(31 downto 24);
					end if;
					
					if ce_1 = '1' then 
						q(23 downto 16) <= d(23 downto 16);
					end if;
					
					if ce_2 = '1' then 
						q(15 downto 8) <= d(15 downto 8);
					end if;
					
					if ce_3 = '1' then
						q(7 downto 0) <= d(7 downto 0);
					end if;
				end if;
		
		end process;

end Behavioral;