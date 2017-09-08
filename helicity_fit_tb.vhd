----- helicity_fit test bench

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity helicity_fit_tb is
  
end;

architecture a1 of helicity_fit_tb is

component helicity_top is
	  port (	enable_gen     : in std_logic;
					 enable_recover : in std_logic;
				   delay          : in std_logic_vector(7 downto 0);
				   reset_delay    : in std_logic;
					 mode           : in std_logic_vector(1 downto 0);
				   load           : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   data_out_gen   : out std_logic_vector(29 downto 0);
				   t_settle       : out std_logic;	
				   t_stable       : out std_logic;	
				   pair_sync      : out std_logic;	
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic ;	
				   helicity_compute : out std_logic;
				   shift_in         : out std_logic;
				   data_out_recover : out std_logic_vector(29 downto 0) );
end component;
      
  component dffe_1 is
	  port( d      : in std_logic;
			    clk    : in std_logic;
		      reset_n: in std_logic;
		      set_n  : in std_logic;
		      clk_ena: in std_logic;
			    q      : out std_logic);
  end component;

CONSTANT CLK_PERIOD: TIME := 50 ns;        -- clock period
CONSTANT SIM_LENGTH: TIME := 500000 us;    -- simulation duration in  ns

signal clk: std_logic;
signal reset: std_logic;

signal enable_gen, t_settle, t_stable, pair_sync, pattern_sync: std_logic;
signal helicity_state: std_logic;
signal mode: std_logic_vector(1 downto 0);
signal data_out_gen: std_logic_vector(29 downto 0);
signal load: std_logic;

signal enable_recover, helicity_compute: std_logic;
signal data_out_recover: std_logic_vector(29 downto 0);

signal shift_in, shift_in_del: std_logic;
signal differ, helicity_error: std_logic;
signal reset_n: std_logic;


begin
  
  reset_n <= not reset;
  
dut: helicity_top  port map (	 enable_gen     => enable_gen,
					                     enable_recover => enable_recover,
					                     mode           => mode,
				                       delay          => X"00",        -- zero helicity delay
				                       reset_delay    => '0',
				                       load           => load,
				                       clk				        => clk,
				                       reset			  	    => reset,
				                       data_out_gen   => data_out_gen,
				                       t_settle       => t_settle,	
				                       t_stable       => t_stable,	
				                       pair_sync      => pair_sync,	
				                       pattern_sync   => pattern_sync,	
				                       helicity_state => helicity_state,	
				                       helicity_compute => helicity_compute,
				                       shift_in         => shift_in,
				                       data_out_recover => data_out_recover );
				                       
-- compare 'helicity_state' and 'helicity_compute' 			                       
  differ <= '1' when (helicity_state /= helicity_compute) else
            '0';
            
-- delay 'shift_in'
ff0: dffe_1 port map ( d  => shift_in, clk => clk, reset_n => reset_n, set_n => '1', clk_ena => '1',
			                 q  => shift_in_del );
			                 
-- use 'shift_in_del' to compare			                 
ff1: dffe_1 port map ( d  => differ, clk => clk, reset_n => reset_n, set_n => '1', clk_ena => shift_in_del,
			                 q  => helicity_error );
			                 
-------------------------------------------------------------------------------------------  
-------------------------------------------------------------------------------------------  
  main: process                   
  
    begin
      enable_gen  <= '0';
      enable_recover <= '0';
--      mode <= "00";                     ----- pair mode  
--      mode <= "01";                     ----- quartet mode  
--      mode <= "10";                     ----- octet mode  
      mode <= "11";                     ----- toggle mode  
      load <= '0';

      wait for 1000 ns;
      
      wait until (rising_edge(clk));      -- load parallel data in source
      wait for 5 ns;
      load <= '1';
      wait until (rising_edge(clk));
      wait for 5 ns;
      load <= '0';
      wait for 90 ns;
      
      wait until rising_edge(clk);
      enable_gen <= '1';
      
      wait for 10000 us;
      
      wait until falling_edge(pattern_sync);  -- make sure 'pattern_sync' not asserted at start
      wait for 200 ns;
      wait until rising_edge(clk);      
      enable_recover <= '1';
      	                                            
      wait for 500000 us;
      
      wait until rising_edge(clk);      
      enable_gen  <= '0';
      enable_recover <= '0';
      	                                            
      wait;
      
    end process main;

-------------------------------------------------------------------------------------------		      
-------------------------------------------------------------------------------------------      
				       
  reset_pulse: process                -- generate initial asynchronous reset pulse
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
				       
-------------------------------------------------------------------------------------------		      
-------------------------------------------------------------------------------------------      

				       
end a1;






		

		  
		  