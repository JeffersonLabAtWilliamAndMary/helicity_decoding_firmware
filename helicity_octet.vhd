-- Helicity octet state machine -  6/26/17    EJ

library ieee;
use ieee.std_logic_1164.all;

entity helicity_octet is
	  port (	enable         : in std_logic;
				   pair_sync      : in std_logic;
				   helicity_first : in std_logic;
				   clk				        : in std_logic;
				   reset			  	    : in std_logic;
				   pattern_sync   : out std_logic;	
				   helicity_state : out std_logic );	
end helicity_octet;
    
architecture a1 of helicity_octet is
																														    														
	type state_type is ( s0, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, 
	                     s12, s13, s14, s15, s16, s17 );																														
	signal ps,ns: state_type;
	

begin
  
p1:	process (reset,clk)
	begin
		if reset = '1' then 
			ps <= s0;
		elsif rising_edge(clk) then 
			ps <= ns;
		end if;
	end process p1;
	
p2:	process ( ps, enable, pair_sync, helicity_first ) 
	begin
	
	CASE  ps  IS

		WHEN  s0  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( (enable = '1') and (pair_sync = '1') and (helicity_first = '0') ) THEN
				ns <= s2 ;
			ELSIF ( (enable = '1') and (pair_sync = '1') and (helicity_first = '1') ) THEN
				ns <= s10 ;
			ELSE 
				ns <= s0 ;
			END IF;

		WHEN  s2  =>                          -- (0, 1, 1, 0, 1, 0, 0, 1)
			pattern_sync <= '1';
			helicity_state <= '0';
			IF ( pair_sync = '0' ) THEN
				ns <= s3 ;
			ELSE 
				ns <= s2 ;
			END IF;

		WHEN  s3  =>
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( pair_sync = '1' ) THEN
				ns <= s4 ;
			ELSE 
				ns <= s3 ;
			END IF;

		WHEN  s4  =>
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( pair_sync = '0' ) THEN
				ns <= s5 ;
			ELSE 
				ns <= s4 ;
			END IF;

		WHEN  s5  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( pair_sync = '1' ) THEN
				ns <= s6 ;
			ELSE 
				ns <= s5 ;
			END IF;

		WHEN  s6  =>                 
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( pair_sync = '0' ) THEN
				ns <= s7 ;
			ELSE 
				ns <= s6 ;
			END IF;

		WHEN  s7  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( pair_sync = '1' ) THEN
				ns <= s8 ;
			ELSE 
				ns <= s7 ;
			END IF;

		WHEN  s8  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( pair_sync = '0' ) THEN
				ns <= s9 ;
			ELSE 
				ns <= s8 ;
			END IF;

		WHEN  s9  =>
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( (pair_sync = '1') and (helicity_first = '0') ) THEN
				ns <= s2 ;
			ELSIF ( (pair_sync = '1') and (helicity_first = '1') ) THEN
				ns <= s10 ;
			ELSE 
				ns <= s9 ;
			END IF;

----

		WHEN  s10  =>                            -- (1, 0, 0, 1, 0, 1, 1, 0)
			pattern_sync <= '1';
			helicity_state <= '1';
			IF ( pair_sync = '0' ) THEN
				ns <= s11 ;
			ELSE 
				ns <= s10 ;
			END IF;

		WHEN  s11  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( pair_sync = '1' ) THEN
				ns <= s12 ;
			ELSE 
				ns <= s11 ;
			END IF;

		WHEN  s12  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( pair_sync = '0' ) THEN
				ns <= s13 ;
			ELSE 
				ns <= s12 ;
			END IF;

		WHEN  s13  =>
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( pair_sync = '1' ) THEN
				ns <= s14 ;
			ELSE 
				ns <= s13 ;
			END IF;

		WHEN  s14  =>                     
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( pair_sync = '0' ) THEN
				ns <= s15 ;
			ELSE 
				ns <= s14 ;
			END IF;

		WHEN  s15  =>
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( pair_sync = '1' ) THEN
				ns <= s16 ;
			ELSE 
				ns <= s15 ;
			END IF;

		WHEN  s16  =>
			pattern_sync <= '0';
			helicity_state <= '1';
			IF ( pair_sync = '0' ) THEN
				ns <= s17 ;
			ELSE 
				ns <= s16 ;
			END IF;

		WHEN  s17  =>
			pattern_sync <= '0';
			helicity_state <= '0';
			IF ( enable = '0' ) THEN
				ns <= s0 ;
			ELSIF ( (pair_sync = '1') and (helicity_first = '0') ) THEN
				ns <= s2 ;
			ELSIF ( (pair_sync = '1') and (helicity_first = '1') ) THEN
				ns <= s10 ;
			ELSE 
				ns <= s17 ;
			END IF;

		when others =>
			pattern_sync <= '0';
			helicity_state <= '0';
				ns <= s0;
				
		end case;
		
	end process p2;
									
end a1;
	