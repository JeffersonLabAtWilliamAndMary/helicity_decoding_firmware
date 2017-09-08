----- generic width synchronous shift register with load
----- asynchronous reset takes precedence over load, shift
----- load takes precedence over shift
----- left shift (MSB) data out, data in

library ieee;
use ieee.std_logic_1164.all;

entity shift_reg_left is
	generic( bitlength : integer );
	 port( data_load: in std_logic_vector((bitlength - 1) downto 0);     -- parallel data loaded
	       bit_in   : in std_logic;                                      -- data bit shifted in  
	       clk      : in std_logic;
	       reset    : in std_logic;                                      -- asynchronous reset
		     load     : in std_logic;
         shift    : in std_logic;                                      -- shift left
		     bit_out  : out std_logic;                                     -- data bit shifted out
		     data_out : out std_logic_vector((bitlength - 1) downto 0) );  -- parallel data out
end shift_reg_left;

architecture a1 of shift_reg_left is

signal reg_int: std_logic_vector((bitlength - 1) downto 0); 

begin
p1: process (clk, reset, load, shift)
	begin
		if reset = '1' then reg_int <= (others => '0');
		elsif rising_edge(clk) then
			if load = '1' then reg_int <= data_load;
			elsif shift = '1' then reg_int <= reg_int((bitlength - 2) downto 0) & bit_in;
			else reg_int <= reg_int;
			end if;
		end if;
		bit_out <= reg_int((bitlength - 1));
		data_out <= reg_int;
	end process p1;

end a1;

