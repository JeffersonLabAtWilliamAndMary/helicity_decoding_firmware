----- helicity top

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity helicity_top is
	  port (	enable_gen     : in std_logic;
					 enable_recover : in std_logic;
					 mode           : in std_logic_vector(1 downto 0);
				   delay          : in std_logic_vector(7 downto 0);
				   reset_delay    : in std_logic;
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
  
end;

architecture a1 of helicity_top is

component helicity_cycle is
	  port (	enable         : in std_logic;
					 mode           : in std_logic_vector(1 downto 0);
				   settle_ct      : in std_logic_vector(15 downto 0);
				   stable_ct      : in std_logic_vector(27 downto 0);
				   delay          : in std_logic_vector(7 downto 0);
				   reset_delay    : in std_logic;
				   data_load      : in std_logic_vector(31 downto 0);
				   load           : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   data_out       : out std_logic_vector(29 downto 0);
				   t_settle       : out std_logic;	
				   t_stable       : out std_logic;	
				   pair_sync      : out std_logic;	
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic );	
end component;

component helicity_recover is
	  port (	enable           : in std_logic;
				   pattern_sync     : in std_logic;	
				   helicity_in      : in std_logic;	
				   clk				          : in std_logic;
				   reset			  	      : in std_logic;
				   helicity_compute : out std_logic;
				   shift_in         : out std_logic;
				   data_out         : out std_logic_vector(29 downto 0) );
end component;
    
signal pattern_sync_int, helicity_state_int: std_logic;


begin

	pattern_sync <= pattern_sync_int;
	helicity_state <= helicity_state_int;
  
dut1: helicity_cycle port map (enable         => enable_gen,
											         mode           => mode,
				                       settle_ct      => X"0040",
				                       stable_ct      => X"0000200",
				                       delay          => delay,
				                       reset_delay    => reset_delay,
				                       data_load      => X"01234567",
				                       load           => load,
				                       clk				        => clk,
				                       reset			       => reset,
				                       data_out       => data_out_gen,
				                       t_settle       => t_settle,	
				                       t_stable       => t_stable,	
				                       pair_sync      => pair_sync,	
				                       pattern_sync   => pattern_sync_int,	
				                       helicity_state => helicity_state_int );	

dut2: helicity_recover port map (	enable           => enable_recover,
				                          pattern_sync     => pattern_sync_int,	
				                          helicity_in      => helicity_state_int,	
				                          clk				          => clk,
				                          reset			  	      => reset,
				                          helicity_compute => helicity_compute,
				                          shift_in         => shift_in,
				                          data_out         => data_out_recover );

			       
end a1;






		

		  
		  