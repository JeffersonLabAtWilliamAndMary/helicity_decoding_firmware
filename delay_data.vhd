--Austin Milby 10/2/2017
-- design made with fifo_delay_state module and fifo_delay

library ieee;
use ieee.std_logic_1164.all;

entity delay_data is
    port( load                : in std_logic;                                            -- load FIFO delay
          latency           : in std_logic_vector(10 downto 0);     -- delay value in 'clock' periods
          data_in          : in std_logic_vector(7 downto 0);        -- data in
          clk              : in std_logic;
          reset              : in std_logic;
          data_out       : out std_logic_vector(7 downto 0);        -- data out
          configured    : out std_logic );                                       -- delay element operational
end delay_data;

architecture Behavioral of delay_data is


	component fifo_delay
		PORT( aclr		: IN STD_LOGIC ;
			   clock		: IN STD_LOGIC ;
			   data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				rdreq		: IN STD_LOGIC ;
				wrreq		: IN STD_LOGIC ;
				empty		: OUT STD_LOGIC ;
				full		: OUT STD_LOGIC ;
				q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
				usedw		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
			);
	end component;
	
	component fifo_delay_state is 
		port ( load: in std_logic;
				 latency: in std_logic_vector(10 downto 0);
				 num_words: in std_logic_vector(10 downto 0);
				 empty_flag: in std_logic;
				 clk: in std_logic;
				 reset: in std_logic;
				 configured: out std_logic;
				 wrt_ena: out std_logic;
				 rd_ena: out std_logic);
	end component;

signal wrt_ena,rd_ena,empty_flag: std_logic;
signal num_words: std_logic_vector(10 downto 0);

	
begin

	fifo_delay_inst : fifo_delay PORT MAP (
		aclr	 => reset,
		clock	 => clk,
		data	 => data_in,
		rdreq	 => rd_ena,
		wrreq	 => wrt_ena,
		empty	 => empty_flag,
		full	 => open,        -- open means wont use
		q	 => data_out,
		usedw	 => num_words
	);

	state: fifo_delay_state port map ( load => load,
												  latency => latency,
												  num_words => num_words,
												  empty_flag => empty_flag,
												  clk => clk,
												  reset => reset,
												  configured => configured,
												  wrt_ena => wrt_ena,
												  rd_ena => rd_ena);
					
end Behavioral;