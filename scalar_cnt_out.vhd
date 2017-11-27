-- Austin Milby 11/7/2017
-- modified scaler with direct count out

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity scalar_cnt_out is 
	port ( a: in std_logic;  
	       clk: in std_logic;
			 reset: in std_logic;
			 capture: in std_logic;     -- tells when to latch or capture count value
			 cnt_out: out std_logic_vector(31 downto 0);  -- direct count out
			 b: out std_logic_vector(31 downto 0));
end scalar_cnt_out;

architecture Behavioral of scalar_cnt_out is

component counter_LF is
	port ( clk: in std_logic;
			 reset: in std_logic;
			 data: in std_logic;
			 mode: in std_logic;
			 output: out std_logic_vector(31 downto 0));
end component;

component dffe_32 is            -- register blind until capture goes high
	port( d: in std_logic_vector(31 downto 0);
			clk: in std_logic;
			reset: in std_logic;
			clk_enable: in std_logic;
			set: in std_logic;
			q: out std_logic_vector(31 downto 0));
end component;

signal count: std_logic_vector(31 downto 0);
signal set: std_logic;
	begin 
	
	obj1: counter_LF port map ( clk => clk,
										 reset => reset,
										 data => a,
										 mode => '0',   -- change mode here
										 output => count); 
	
	obj2: dffe_32 port map ( d => count,
									 clk => clk,
									 reset => reset,
									 clk_enable => capture,
									 set => set,
									 q => b );

cnt_out <= count;									 
									 
end Behavioral;