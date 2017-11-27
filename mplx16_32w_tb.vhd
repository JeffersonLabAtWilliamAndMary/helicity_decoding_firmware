-- Austin Milby 9/18/2017
-- Test bench for 16 down to 1 multiplexer with 32 bit inputs

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity mplx16_32w_tb is 

end mplx16_32w_tb;

architecture a1 of mplx16_32w_tb is

	component mplx16_32w is
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
	end component;

signal d0_in: std_logic_vector(31 downto 0);
signal d1_in: std_logic_vector(31 downto 0);
signal d2_in: std_logic_vector(31 downto 0);
signal d3_in: std_logic_vector(31 downto 0);
signal d4_in: std_logic_vector(31 downto 0);
signal d5_in: std_logic_vector(31 downto 0);
signal d6_in: std_logic_vector(31 downto 0);
signal d7_in: std_logic_vector(31 downto 0);
signal d8_in: std_logic_vector(31 downto 0);
signal d9_in: std_logic_vector(31 downto 0);
signal d10_in: std_logic_vector(31 downto 0);
signal d11_in: std_logic_vector(31 downto 0);
signal d12_in: std_logic_vector(31 downto 0);
signal d13_in: std_logic_vector(31 downto 0);
signal d14_in: std_logic_vector(31 downto 0);
signal d15_in: std_logic_vector(31 downto 0);
signal sel: std_logic_vector(3 downto 0);
signal d_out: std_logic_vector(31 downto 0);

	begin
        dut1: 	  mplx16_32w port map ( d0_in => d0_in,
					 d1_in => d1_in,
                                         d2_in => d2_in,
					 d3_in => d3_in,
					 d4_in => d4_in,
					 d5_in => d5_in,
					 d6_in => d6_in,
					 d7_in => d7_in,
					 d8_in => d8_in,
					 d9_in => d9_in,
					 d10_in => d10_in,
				 	 d11_in => d11_in,
					 d12_in => d12_in,
					 d13_in => d13_in,
					 d14_in => d14_in,
					 d15_in => d15_in,
					 sel => sel,
					 d_out => d_out);

--------------------------------------------------------------------------
--------------------------------------------------------------------------
main: process 
            begin
	        d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0000";
		wait for 200 ns;
		d0_in <= x"ffffffff";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0000";
		wait for 200 ns;
		d0_in <= x"ffffffff";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0001";
		wait for 200 ns;
		d0_in <= x"ffffffff";
		d1_in <= x"ffffffff";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0001";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"ffffffff";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0001";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"ffffffff";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0010";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"ffffffff";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0011";
		wait for 200 ns;
		d0_in <= x"ffffffff";
		d1_in <= x"00000000";
                d2_in <= x"ffffffff";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0011";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"ffffffff";
		d5_in <= x"00000000";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0100";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"ffffffff";
		d6_in <= x"00000000";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0101";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"ffffffff";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0110";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"ffffffff";
		d7_in <= x"00000000";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "0111";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"ffffffff";
		d4_in <= x"00000000";
		d5_in <= x"00000000";
		d6_in <= x"ffffffff";
		d7_in <= x"00000000";
		d8_in <= x"ffffffff";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "1000";
		wait for 200 ns;
		d0_in <= x"00000000";
		d1_in <= x"00000000";
                d2_in <= x"00000000";
                d3_in <= x"00000000";
		d4_in <= x"00000000";
		d5_in <= x"ffffffff";
		d6_in <= x"ffffffff";
		d7_in <= x"ffffffff";
		d8_in <= x"00000000";
		d9_in <= x"00000000";
		d10_in <= x"00000000";
		d11_in <= x"00000000";
		d12_in <= x"00000000";
		d13_in <= x"00000000";
		d14_in <= x"00000000";
		d15_in <= x"00000000";
		sel <= "1001";
		wait for 200 ns;
		wait;
	end process main;
			

end a1;


