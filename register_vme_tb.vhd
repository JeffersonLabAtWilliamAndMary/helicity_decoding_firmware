-- Austin Milby 9/21/2017
-- Test bench for 32 bit wide, VME compatible register with byte selection 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity register_vme_tb is

end register_vme_tb;

architecture a1 of register_vme_tb is

component register_vme is
	port ( d: in std_logic_vector(31 downto 0);
	       clk: in std_logic;
	       reset: in std_logic;
	       ce_0: in std_logic;
	       ce_1: in std_logic;
	       ce_2: in std_logic;
	       ce_3: in std_logic;
	       q: out std_logic_vector(31 downto 0));
end component;

constant CLK_PERIOD: TIME := 50 ns;
constant SIM_LENGTH: TIME := 500000 ns;

signal d: std_logic_vector(31 downto 0);
signal clk: std_logic;
signal reset: std_logic;
signal ce_0: std_logic;
signal ce_1: std_logic;
signal ce_2: std_logic;
signal ce_3: std_logic;
signal q: std_logic_vector(31 downto 0);

	begin
	flipflop: register_vme port map ( d => d,
				     	  clk => clk,
				     	  reset => reset,
				     	  ce_0 => ce_0,
					  ce_1 => ce_1,
					  ce_2 => ce_2,
					  ce_3 => ce_3,
				     	  q => q);

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
	main: process
		begin
		d <= x"00000000";
		wait for 200 ns;
		d <= x"00000001";
		wait for 200 ns;
		d <= x"00000001";
		ce_0 <= '1';
		ce_1 <= '0';
		ce_2 <= '0';
		ce_3 <= '0';
		wait for 100 ns;
		d <= x"00000000";
		wait for 500 ns;    -- used to test reset: everything before should be cleared
		d <= x"00000001";	
		wait for 200 ns;
		d <= x"00000002";	
		wait for 200 ns;
		d <= x"00000004";
		wait for 200 ns;    
	        d <= x"0000000E"; 
		wait for 200 ns;
		d <= x"00000000";
		ce_0 <= '0';
		ce_1 <= '1';
		ce_2 <= '0';
		ce_3 <= '0';
		wait for 200 ns;    
		d <= x"00000001";	
		wait for 200 ns;
		d <= x"00000012";	
		wait for 200 ns;
		d <= x"00000134";
		wait for 200 ns;    
	        d <= x"0000131E"; 
		wait for 200 ns;
		d <= x"00000000";
		ce_0 <= '0';
		ce_1 <= '0';
		ce_2 <= '1';
		ce_3 <= '0';
		wait for 200 ns;    
		d <= x"00000001";	
		wait for 200 ns;
		d <= x"00000112";	
		wait for 200 ns;
		d <= x"00210004";
		wait for 200 ns;    
	        d <= x"0100031E"; 
		wait for 200 ns;
		d <= x"00000000";
		ce_0 <= '0';
		ce_1 <= '0';
		ce_2 <= '0';
		ce_3 <= '1';
		wait for 200 ns;    
		d <= x"11111111";	
		wait for 200 ns;
		d <= x"00000002";	
		wait for 200 ns;
		d <= x"00320004";
		wait for 200 ns;    
	        d <= x"1100031E"; 
		wait for 200 ns;
		d <= x"00000000";
		ce_0 <= '1';
		ce_1 <= '1';
		ce_2 <= '0';
		ce_3 <= '0';
		wait for 200 ns;    
		d <= x"00000001";	
		wait for 200 ns;
		d <= x"00000302";	
		wait for 200 ns;
		d <= x"00002004";
		wait for 200 ns;    
	        d <= x"0030031E"; 
		wait for 200 ns;
		d <= x"00000000";
		ce_0 <= '1';
		ce_1 <= '0';
		ce_2 <= '1';
		ce_3 <= '1';
		wait for 200 ns;    
		d <= x"00000011";	
		wait for 200 ns;
		d <= x"00002222";	
		wait for 200 ns;
		d <= x"00333333";
		wait for 200 ns;    
	        d <= x"1100031E"; 
		wait for 200 ns;
		d <= x"00000000";
		ce_0 <= '1';
		ce_1 <= '1';
		ce_2 <= '1';
		ce_3 <= '1';
		wait for 200 ns;    
		d <= x"11111111";	
		wait for 200 ns;
		d <= x"20030002";	
		wait for 200 ns;
		d <= x"44003201";
		wait for 200 ns;    
	        d <= x"0000031E"; 
		wait for 200 ns;   
		d <= x"00000000";   
		wait for 200 ns;
		wait;
	end process main;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
reset_pulse: process               -- generate initial asynchronous reset pulse
    begin
      reset <= '0';
      wait for 100 ns;
      reset <= '1';
      wait for 500 ns;
      reset <= '0';
      wait;
    end process reset_pulse;
      
  clk_gen: process                    -- generate 20 MHZ clock
    variable num_periods: integer;
    begin
      num_periods := SIM_LENGTH/CLK_PERIOD;
      for i in 1 to num_periods loop
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
      end loop;
      wait; 
    end process clk_gen;	
				
end a1;			
  			     
