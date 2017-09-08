-- Helicity cycle generator -  6/27/17, 7/11/17    EJ

-- Generates waveform sequences of the Helicity Control board

-- enable: '1' - allows sequence generation; '0' - all signals held not asserted ('0')
 
-- mode (helicity sequence type): 0 = pair, 1 = quartet, 2 = octet, 3 = toggle

-- settle_ct: duration of 't_settle' signal assertion (50 ns/count)
-- stable_ct: duration of 't_stable' signal assertion (50 ns/count)
--            (helicity period = (settle_ct + stable_ct) * 50 ns)

-- delay: number of helicity periods that helicity is delayed in output
-- reset_delay: single 'clk' period pulse to clear delay circuit after setting delay

-- data_load: 32-bit seed loaded into shift register (only lower 30 bits used)
-- load: single 'clk' period pulse to parallel load 'data_load' into shift register

-- clk: 20 MHz
-- reset: resets all state machines and counters

-- data out: current value of shift register bits (30)

-- Output signals: 't_settle', 't_stable', 'pair_sync', 'pattern_sync', 'helicity_state'

library ieee;
use ieee.std_logic_1164.all;

entity helicity_cycle is
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
end helicity_cycle;
    
architecture a1 of helicity_cycle is
																														    
  component shift_reg_left is
	 generic( bitlength : integer );
	   port( data_load: in std_logic_vector((bitlength - 1) downto 0);     -- parallel data loaded
	         bit_in   : in std_logic;                                      -- data bit shifted in  
	         clk      : in std_logic;
	         reset    : in std_logic;                                      -- asynchronous reset
		       load     : in std_logic;
           shift    : in std_logic;                                      -- shift left
		       bit_out  : out std_logic;                                     -- data bit shifted out
		       data_out : out std_logic_vector((bitlength - 1) downto 0) );  -- parallel data out
  end component;

  component helicity_pair is
	  port (	enable         : in std_logic;
				   pair_sync      : in std_logic;
				   helicity_first : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic );	
  end component;
    
  component helicity_quartet is
	  port (	enable         : in std_logic;
				   pair_sync      : in std_logic;
				   helicity_first : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic );	
  end component;
    
  component helicity_octet is
	  port (	enable         : in std_logic;
				   pair_sync      : in std_logic;
				   helicity_first : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic );	
  end component;
    
  component helicity_toggle is
	  port (	enable         : in std_logic;
				   pair_sync      : in std_logic;
				   helicity_first : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic );	
  end component;
    
  component mux4 is
	  port( d0_in: in std_logic;
		      d1_in: in std_logic;
		      d2_in: in std_logic;
		      d3_in: in std_logic;
			    sel  : in std_logic_vector(1 downto 0);
		      d_out: out std_logic );
  end component;

	component counter_udsl is
		generic( bitlength: integer );
			port( updown		   : in std_logic;
					  count_ena	 : in std_logic;
					  sload			   : in std_logic;
				    data			    : in std_logic_vector((bitlength - 1) downto 0);
				    clk			     : in std_logic;
					  reset			   : in std_logic;
					  zero_count : out std_logic;
					  max_count	 : out std_logic;
					  counter		  : out std_logic_vector((bitlength - 1) downto 0));
	end component;
														
  component pulse_leading_edge is
	  port( signal_in : in std_logic;
				  clk       : in std_logic;
			    reset     : in std_logic;
		      pulse_out : out std_logic);
  end component;

  component delay_signal is
	  generic( DEPTH: integer );
	     port( input 	     : IN std_logic;
	           delay_value : IN std_logic_vector(11 downto 0);
	           clk_ena     : IN std_logic;
	           clk         : IN std_logic;
	           reset       : IN std_logic;
	           output	     : OUT std_logic );
  end component;

  component delay_module is
	  generic( DELAY_VALUE : integer );
	     port( input : IN std_logic;
	           clk   : IN std_logic;
	           output: OUT std_logic );
  end component;

	type state_type1 is ( s0, s1, s2 );																														
	signal ps1,ns1: state_type1;
	
	type state_type2 is ( t0, t1, t2, t3, t4 );																														
	signal ps2,ns2: state_type2;
	
	signal load1, load2: std_logic;
	signal count1_zero, count2_zero: std_logic;

	signal t_settle_int, t_stable_int, pair_sync_int, pattern_sync_int: std_logic;
	
	signal enable_pair, enable_quartet, enable_octet, enable_toggle: std_logic;
	signal pattern_sync_pair, pattern_sync_quartet, pattern_sync_octet, pattern_sync_toggle: std_logic;
	signal helicity_state_pair, helicity_state_quartet, helicity_state_octet, helicity_state_toggle: std_logic;

  signal xor1, xor2, xor3: std_logic;
  signal bit_in, shift, bit_out: std_logic;
  signal helicity_first: std_logic;
	signal data_out_int: std_logic_vector(29 downto 0);
	signal helicity_state_int: std_logic;
	
	signal delay_value: std_logic_vector(11 downto 0);
	signal delay_clear, delay_clk_ena: std_logic;
	signal helicity_delayed: std_logic;

begin
  
  t_settle     <= t_settle_int;
  t_stable     <= t_stable_int;
  data_out     <= data_out_int;

shift1: shift_reg_left generic map( bitlength => 30 )
                          port map( data_load => data_load(29 downto 0),
	                                  bit_in    => bit_in,  
	                                  clk       => clk,
	                                  reset     => reset,
		                                load      => load,
                                    shift     => shift,
		                                bit_out   => bit_out,
		                                data_out  => data_out_int );
		                             
-- generate 'bit_in' from XORs of current 'data_out' value
    xor1 <= data_out_int(29) xor data_out_int(28);
    xor2 <= xor1 xor data_out_int(27);
    xor3 <= xor2 xor data_out_int(6);

    bit_in <= xor3;
    helicity_first <= bit_in;
    
-- 'shift' is single clock width pulse from the leading edge of 'pattern_sync'
pulse1:	pulse_leading_edge port map ( signal_in => pattern_sync_int,
				                              clk       => clk,
			                                reset     => reset,
		                                  pulse_out => shift );

---------------------------------------------------------------------------

count1: counter_udsl generic map ( bitlength  => 16 )
								        port map (	updown		   => '0',  -- count down
												           count_ena	 => '1',
												           sload	   	 => load1,
												           data			    => settle_ct,     
												           clk			     => clk,
												           reset	     => reset,
												           zero_count	=> count1_zero,
												           max_count	 => open,
												           counter		  => open );

count2: counter_udsl generic map ( bitlength  => 28 )
								        port map (	updown		   => '0',  -- count down
												           count_ena	 => '1',
												           sload	   	 => load2,
												           data			    => stable_ct,     
												           clk			     => clk,
												           reset	   	 => reset,
												           zero_count	=> count2_zero,
												           max_count	 => open,
												           counter		  => open );

------------------------------------------------------
-- state machines produce base helicity timing signals 
------------------------------------------------------
p1:	process (reset,clk)
	begin
		if reset = '1' then 
			ps1 <= s0;
		elsif rising_edge(clk) then 
			ps1 <= ns1;
		end if;
	end process p1;
	
p2:	process ( ps1, enable, count1_zero, count2_zero ) 
	begin
	
	CASE  ps1  IS

		WHEN  s0  =>
			t_settle_int <= '0';
			t_stable_int <= '0';
			load1 <= '1';
			load2 <= '1';
			IF ( enable = '1' ) THEN
				ns1 <= s1 ;
			ELSE 
				ns1 <= s0 ;
			END IF;

		WHEN  s1  =>
			t_settle_int <= '1';
			t_stable_int <= '0';
			load1 <= '0';
			load2 <= '1';
			IF ( count1_zero = '1' ) THEN
				ns1 <= s2 ;
			ELSE 
				ns1 <= s1 ;
			END IF;

		WHEN  s2  =>
			t_settle_int <= '0';
			t_stable_int <= '1';
			load1 <= '1';
			load2 <= '0';
			IF ( (count2_zero = '1') and (enable = '0') ) THEN
				ns1 <= s0 ;
			ELSIF ( (count2_zero = '1') and (enable = '1') ) THEN
				ns1 <= s1 ;
			ELSE 
				ns1 <= s2 ;
			END IF;

		when others =>
			t_settle_int <= '0';
			t_stable_int <= '0';
			load1 <= '1';
			load2 <= '1';
				ns1 <= s0;
				
		end case;
		
	end process p2;
------------------------------------------------------
									
------------------------------------------------------
p3:	process (reset,clk)
	begin
		if reset = '1' then 
			ps2 <= t0;
		elsif rising_edge(clk) then 
			ps2 <= ns2;
		end if;
	end process p3;
	
p4:	process ( ps2, enable, t_settle_int ) 
	begin
	
	CASE  ps2  IS

		WHEN  t0  =>
			pair_sync_int <= '0';
			IF ( (enable = '1') and (t_settle_int = '1') ) THEN
				ns2 <= t1 ;
			ELSE 
				ns2 <= t0 ;
			END IF;

		WHEN  t1  =>
			pair_sync_int <= '1';
			IF ( t_settle_int = '0' ) THEN
				ns2 <= t2 ;
			ELSE 
				ns2 <= t1 ;
			END IF;

		WHEN  t2  =>
			pair_sync_int <= '1';
			IF ( enable = '0' ) THEN
			  ns2 <= t0;
			ELSIF ( t_settle_int = '1' ) THEN
				ns2 <= t3 ;
			ELSE 
				ns2 <= t2 ;
			END IF;

		WHEN  t3  =>
			pair_sync_int <= '0';
			IF ( t_settle_int = '0' ) THEN
				ns2 <= t4 ;
			ELSE 
				ns2 <= t3 ;
			END IF;

		WHEN  t4  =>
			pair_sync_int <= '0';
			IF ( enable = '0' ) THEN
			  ns2 <= t0;
			ELSIF ( t_settle_int = '1' ) THEN
				ns2 <= t1 ;
			ELSE 
				ns2 <= t4 ;
			END IF;

		when others =>
			pair_sync_int <= '1';
				ns2 <= t0;
				
		end case;
		
	end process p4;
------------------------------------------------------

  enable_pair    <= '1' when ( (enable = '1') and (mode = "00") ) else '0';
  enable_quartet <= '1' when ( (enable = '1') and (mode = "01") ) else '0';
  enable_octet   <= '1' when ( (enable = '1') and (mode = "10") ) else '0';
  enable_toggle  <= '1' when ( (enable = '1') and (mode = "11") ) else '0';

 pair:     helicity_pair port map (	  enable         => enable_pair,
				                              pair_sync      => pair_sync_int,
				                              helicity_first => helicity_first,
				                              clk				        => clk,
				                              reset			  	    => reset,
				                              pattern_sync   => pattern_sync_pair,	
				                              helicity_state => helicity_state_pair );	
									
quartet:  helicity_quartet port map (	enable         => enable_quartet,
				                              pair_sync      => pair_sync_int,
				                              helicity_first => helicity_first,
				                              clk				        => clk,
				                              reset			  	    => reset,
				                              pattern_sync   => pattern_sync_quartet,	
				                              helicity_state => helicity_state_quartet );	
									
octet:    helicity_octet port map (	  enable         => enable_octet,
				                              pair_sync      => pair_sync_int,
				                              helicity_first => helicity_first,
				                              clk				        => clk,
				                              reset			  	    => reset,
				                              pattern_sync   => pattern_sync_octet,	
				                              helicity_state => helicity_state_octet );	
									
toggle:   helicity_toggle port map (	 enable         => enable_toggle,
				                              pair_sync      => pair_sync_int,
				                              helicity_first => helicity_first,
				                              clk				        => clk,
				                              reset			  	    => reset,
				                              pattern_sync   => pattern_sync_toggle,	
				                              helicity_state => helicity_state_toggle );
				                              
mux1: mux4 port map ( d0_in => pattern_sync_pair,
		                  d1_in => pattern_sync_quartet,
		                  d2_in => pattern_sync_octet,
		                  d3_in => pattern_sync_toggle,
			                sel   => mode,
		                  d_out => pattern_sync_int );
		                  
mux2: mux4 port map ( d0_in => helicity_state_pair,
		                  d1_in => helicity_state_quartet,
		                  d2_in => helicity_state_octet,
		                  d3_in => helicity_state_toggle,
			                sel   => mode,
		                  d_out => helicity_state_int );

-- delay helicity by 'delay' helicity windows - use start of 't_settle' as delay 'clk_ena'
  delay_value <= "0000" & delay;
  delay_clear <= reset or reset_delay;
  
pulse2:	pulse_leading_edge port map ( signal_in => t_settle_int,
				                              clk       => clk,
			                                reset     => reset,
		                                  pulse_out => delay_clk_ena );

h_delay: delay_signal generic map ( DEPTH => 64 )
	                       port map ( input 	     => helicity_state_int,
	                                  delay_value => delay_value,
	                                  clk   	     => clk,
	                                  clk_ena     => delay_clk_ena,
	                                  reset       => delay_clear,
	                                  output	     => helicity_delayed );

-- delay outputs 'pair_sync', 'pattern_sync', 'helicity_state' 1 us from 't_settle'
 
delay1: delay_module generic map ( DELAY_VALUE => 19 )
	                      port map ( input  => pair_sync_int,
	                                 clk    => clk,
	                                 output => pair_sync );
		                  
delay2: delay_module generic map ( DELAY_VALUE => 18 )
	                      port map ( input  => pattern_sync_int,
	                                 clk    => clk,
	                                 output => pattern_sync );
		                  
delay3: delay_module generic map ( DELAY_VALUE => 18 )
	                      port map ( input  => helicity_delayed,
	                                 clk    => clk,
	                                 output => helicity_state );
		                  									
end a1;
	