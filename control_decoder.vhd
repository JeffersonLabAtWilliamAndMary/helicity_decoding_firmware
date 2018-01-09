-- Austin Milby 11/8/2017, 12/5/2017, 12/10/2017, 12/15/2017, 12/19/2017
-- Control file for the Helicity Decoder Board

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity control_decoder is
	port ( data_in: in std_logic_vector(31 downto 0);			-- data ports to VME
			 data_out: out std_logic_vector(31 downto 0);

			 addr: in std_logic_vector(7 downto 0);			-- signals from VME interface module
			 read_sig: in std_logic; 
		    write_sig: in std_logic; 
			 read_stb: in std_logic;
		    write_stb: in std_logic;
			 byte: in std_logic_vector(3 downto 0);			-- selects bytes of data (0,1,2,3) involved in transfer
		    iack_cycle: in std_logic;								-- special 'interrupt' cycle when iack_cycle = '1'  
		    a24_cycle: in std_logic;								-- a24_cycle = '1' for normal data cycle to registers
		    clk: in std_logic;
			 reset: in std_logic;
			   
			 --------
			 
			 trigger_in			: in std_logic;		-- (TRIGGER 1 SCALER)
			 trigger2_in			: in std_logic;		-- (TRIGGER 2 SCALER)
			 sync_in				: in std_logic;		-- (SYNC_RESET SCALER)		
			 event_out			: in std_logic;		-- (EVENTS ON BOARD)
			 block_in			: in std_logic;		-- (BLOCKS ON BOARD)
			 done_block			: in std_logic;		-- (BLOCKS ON BOARD)
			
			 t_stable_rise_count	: in std_logic_vector(31 downto 0);	-- (HELICITY SCALER 1)
			 t_stable_fall_count	: in std_logic_vector(31 downto 0);	-- (HELICITY SCALER 2)
			
			 pattern_sync_count	: in std_logic_vector(31 downto 0);	-- (HELICITY SCALER 3)
			
			 pair_sync_count		: in std_logic_vector(31 downto 0);	-- (HELICITY SCALER 4)
			
			 helicity_window_count: in std_logic_vector(31 downto 0);-- (HELICITY SCALER 5)
			
			 recovered_seed		: in std_logic_vector(29 downto 0);	-- (RECOVERED SHIFT REGISTER VALUE)
			 generator_seed		: in std_logic_vector(29 downto 0);	-- (GENERATOR SHIFT REGISTER VALUE)
						   
			 locked_pll_sys 		: in std_logic;		-- system clock PLL status (CSR)
			 locked_pll_mod 		: in std_logic;		-- module clock PLL status (CSR)
			
			 event_level_flag 	: in std_logic;		-- block of events accepted (CSR)
			 block_level_flag 	: in std_logic;		-- block of events ready for readout (CSR)
			
			 no_events			: in std_logic;		-- no events on board (CSR)
			 berr_status			: in std_logic;		-- (CSR)
			 busy_status			: in std_logic;		-- (CSR)
			 busy_status_latched	: in std_logic;		-- (CSR)
			
			 empty_buffer_0		: in std_logic;		-- (CSR)
			 empty_buffer_1		: in std_logic;		-- (CSR)
			 helicity_seq_error  : in std_logic;    -- Added myself (CSR)
			 
			 force_block_trailer	: out std_logic;	-- (CSR)
			 block_trailer_success: in std_logic;		-- (CSR)
			 block_trailer_fail	: in std_logic;		-- (CSR)
			
			 sync_soft			: out std_logic;	-- (CSR)
			 trig_soft			: out std_logic;	-- (CSR)
			 reset_soft			: out std_logic;	-- (CSR)
			 reset_hard			: out std_logic;	-- (CSR)
			
			 sysclk_select		: out std_logic_vector(2 downto 0);	-- (CTRL_1[2..0])
			 trig_select			: out std_logic_vector(1 downto 0);	-- (CTRL_1)
			 sync_select			: out std_logic_vector(1 downto 0);	-- (CTRL_1)
			 soft_enable			: out std_logic;					-- (CTRL_1)
			
			 interrupt_enable	: out std_logic;					-- (CTRL_1)
			 berr_enable			: out std_logic;					-- (CTRL_1)
			
			 use_generator		: out std_logic;					-- (CTRL_1)
			
			 decode_enable		: out std_logic;					-- (CTRL_2)
			 trigger_enable		: out std_logic;					-- (CTRL_2)
			
			 generator_enable	: out std_logic;					-- (CTRL_2)
			
			 en_adr32			: out std_logic;					-- (ADR32)
			 adr32				: out std_logic_vector(8 downto 0);	-- (ADR32)
			
			 ga					: in std_logic_vector(4 downto 0);	-- (INTERRUPT) 
			 gap					: in std_logic;						-- (INTERRUPT)
			 interrupt_level		: out std_logic_vector(2 downto 0);	-- (INTERRUPT)
			 interrupt_id		: out std_logic_vector(7 downto 0);	-- (INTERRUPT)
			
			 block_size			: out std_logic_vector(15 downto 0); -- (BLOCK_SIZE)
			
			 latency				: out std_logic_vector(9 downto 0);	-- (TRIGGER LATENCY)
			 latency_ready		: in std_logic;						-- (TRIGGER LATENCY)
			
			 generator_mode		: out std_logic_vector(1 downto 0);	-- (HELICITY CONFIG 1)
			 helicity_delay		: out std_logic_vector(7 downto 0);	-- (HELICITY CONFIG 1)
			 helicity_settle		: out std_logic_vector(15 downto 0); -- (HELICITY CONFIG 1)
				   
			 helicity_stable		: out std_logic_vector(27 downto 0); -- (HELICITY CONFIG 2)
			
			 initial_seed		: out std_logic_vector(29 downto 0) -- (HELICITY CONFIG 3)
				   
			 
		 );
end control_decoder;
		 
architecture a1 of control_decoder is

	signal reg0_ce_b0, reg0_ce_b1, reg0_ce_b2, reg0_ce_b3: std_logic;
	signal reg1_ce_b0, reg1_ce_b1, reg1_ce_b2, reg1_ce_b3: std_logic;
	signal reg2_ce_b0, reg2_ce_b1, reg2_ce_b2, reg2_ce_b3: std_logic;
	signal reg3_ce_b0, reg3_ce_b1, reg3_ce_b2, reg3_ce_b3: std_logic;
	signal reg4_ce_b0, reg4_ce_b1, reg4_ce_b2, reg4_ce_b3: std_logic;
	signal reg5_ce_b0, reg5_ce_b1, reg5_ce_b2, reg5_ce_b3: std_logic;
	signal reg6_ce_b0, reg6_ce_b1, reg6_ce_b2, reg6_ce_b3: std_logic;
	signal reg7_ce_b0, reg7_ce_b1, reg7_ce_b2, reg7_ce_b3: std_logic;
	signal reg8_ce_b0, reg8_ce_b1, reg8_ce_b2, reg8_ce_b3: std_logic;
	signal reg9_ce_b0, reg9_ce_b1, reg9_ce_b2, reg9_ce_b3: std_logic;
	signal reg10_ce_b0, reg10_ce_b1, reg10_ce_b2, reg10_ce_b3: std_logic;
	signal reg11_ce_b0, reg11_ce_b1, reg11_ce_b2, reg11_ce_b3: std_logic;
	signal reg12_ce_b0, reg12_ce_b1, reg12_ce_b2, reg12_ce_b3: std_logic;
	signal reg13_ce_b0, reg13_ce_b1, reg13_ce_b2, reg13_ce_b3: std_logic;
	signal reg14_ce_b0, reg14_ce_b1, reg14_ce_b2, reg14_ce_b3: std_logic;
	signal reg15_ce_b0, reg15_ce_b1, reg15_ce_b2, reg15_ce_b3: std_logic;
	
	signal reg16_ce_b0, reg16_ce_b1, reg16_ce_b2, reg16_ce_b3: std_logic;
	signal reg17_ce_b0, reg17_ce_b1, reg17_ce_b2, reg17_ce_b3: std_logic;
	signal reg18_ce_b0, reg18_ce_b1, reg18_ce_b2, reg18_ce_b3: std_logic;
	signal reg19_ce_b0, reg19_ce_b1, reg19_ce_b2, reg19_ce_b3: std_logic;
	signal reg20_ce_b0, reg20_ce_b1, reg20_ce_b2, reg20_ce_b3: std_logic;
	signal reg21_ce_b0, reg21_ce_b1, reg21_ce_b2, reg21_ce_b3: std_logic;
	signal reg22_ce_b0, reg22_ce_b1, reg22_ce_b2, reg22_ce_b3: std_logic;
	signal reg23_ce_b0, reg23_ce_b1, reg23_ce_b2, reg23_ce_b3: std_logic;
	signal reg24_ce_b0, reg24_ce_b1, reg24_ce_b2, reg24_ce_b3: std_logic;
	signal reg25_ce_b0, reg25_ce_b1, reg25_ce_b2, reg25_ce_b3: std_logic;
	signal reg26_ce_b0, reg26_ce_b1, reg26_ce_b2, reg26_ce_b3: std_logic;
	
	signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,reg8, reg9, 
			 reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18,
			 reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26: std_logic;
			 
	signal reg0_data, reg1_data, reg2_data, reg3_data, reg4_data, reg5_data, 
			 reg6_data, reg7_data, reg8_data, reg9_data, reg10_data, reg11_data, 
			 reg12_data, reg13_data, reg14_data, reg15_data, reg16_data, reg17_data,
			 reg18_data, reg19_data, reg20_data, reg21_data,reg22_data, reg23_data,
			 reg24_data, reg25_data, reg26_data, reg27_data, reg28_data, reg29_data,
			 reg30_data, reg31_data: std_logic_vector(31 downto 0);
	
	signal sel: std_logic_vector(5 downto 2);

	signal reg0_data_int,reg1_data_int,reg2_data_int,reg3_data_int,reg4_data_int,
			 reg5_data_int,reg6_data_int,reg7_data_int,reg8_data_int,reg9_data_int,
			 reg10_data_int,reg11_data_int,reg12_data_int,reg13_data_int,reg14_data_int,
			 reg15_data_int: std_logic_vector(31 downto 0);    -- add signal for each register
	
	signal read_trigger1_scaler,read_trigger2_scaler: std_logic;
	signal trigger_1_count,trigger_2_count: std_logic_vector(31 downto 0); -- Is this correct?
	
	signal read_csr: std_logic;
	signal csr_data: std_logic_vector(31 downto 0);
	
	signal read_sync_scaler: std_logic;
	
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
	
	component mux_32 is 
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
			    d16_in: in std_logic_vector(31 downto 0);
			    d17_in: in std_logic_vector(31 downto 0);
			    d18_in: in std_logic_vector(31 downto 0);
			    d19_in: in std_logic_vector(31 downto 0);
			    d20_in: in std_logic_vector(31 downto 0);
			    d21_in: in std_logic_vector(31 downto 0);
			    d22_in: in std_logic_vector(31 downto 0);
			    d23_in: in std_logic_vector(31 downto 0);
			    d24_in: in std_logic_vector(31 downto 0);
			    d25_in: in std_logic_vector(31 downto 0);
			    d26_in: in std_logic_vector(31 downto 0);
			    d27_in: in std_logic_vector(31 downto 0);
			    d28_in: in std_logic_vector(31 downto 0);
			    d29_in: in std_logic_vector(31 downto 0);
			    d30_in: in std_logic_vector(31 downto 0);
			    d31_in: in std_logic_vector(31 downto 0);
			    sel: in std_logic_vector(4 downto 0);
			    d_out: out std_logic_vector(31 downto 0));
	end component;
	
	component dffe_32 is 
		port ( d: in std_logic_vector(31 downto 0);
				 clk: in std_logic;
				 reset: in std_logic;
				 clk_enable: in std_logic;
			--	 set: in std_logic;
				 q: out std_logic_vector(31 downto 0));
	end component;			 
				 
	component scalar_32 is 
		port ( a: in std_logic;  
				 clk: in std_logic;
			    reset: in std_logic;
			    capture: in std_logic;     
			    b: out std_logic_vector(31 downto 0));
	end component;
				 
	constant MODULE_TYPE: std_logic_vector(15 downto 0) := x"DEC0";
	constant BOARD_REV: std_logic_vector(7 downto 0) := x"01";
	constant FIRM_REV: std_logic_vector(7 downto 0) := x"01";
	-- info will look like DEC0|01|01
				 
begin

------------------------------------------------------------------------------
	reg0  <= '1' when ( addr(7 downto 2) = "000000" ) else '0'; 	-- 0x 00	
	reg1	<= '1' when ( addr(7 downto 2) = "000001" ) else '0'; 	-- 0x 04
	reg2	<= '1' when ( addr(7 downto 2) = "000010" ) else '0'; 	-- 0x 08
	reg3	<= '1' when ( addr(7 downto 2) = "000011" ) else '0'; 	-- 0x 0C
	reg4	<= '1' when ( addr(7 downto 2) = "000100" ) else '0'; 	-- 0x 10
	reg5  <= '1' when ( addr(7 downto 2) = "000101" ) else '0'; 	-- 0x 14
	reg6  <= '1' when ( addr(7 downto 2) = "000110" ) else '0';		-- 0x 18
	reg7  <= '1' when ( addr(7 downto 2) = "000111" ) else '0';		-- 0x 1C
	reg8  <= '1' when ( addr(7 downto 2) = "001000" ) else '0';		-- 0x 20
	reg9  <= '1' when ( addr(7 downto 2) = "001001" ) else '0';		-- 0x 24
	reg10 <= '1' when ( addr(7 downto 2) = "001010" ) else '0';		-- 0x 28
	reg11 <= '1' when ( addr(7 downto 2) = "001011" ) else '0';		-- 0x 2C
	reg12 <= '1' when ( addr(7 downto 2) = "001100" ) else '0';		-- 0x 30
	reg13 <= '1' when ( addr(7 downto 2) = "001101" ) else '0';		-- 0x 34
	reg14 <= '1' when ( addr(7 downto 2) = "001110" ) else '0';		-- 0x 38			
	reg15	<= '1' when ( addr(7 downto 2) = "001111" ) else '0'; 	-- 0x 3C
	
	reg16 <= '1' when ( addr(7 downto 2) = "010000" ) else '0';    -- 0x 40
	reg17 <= '1' when ( addr(7 downto 2) = "010001" ) else '0';    -- 0x 44
	reg18 <= '1' when ( addr(7 downto 2) = "010010" ) else '0';    -- 0x 48
	reg19 <= '1' when ( addr(7 downto 2) = "010011" ) else '0';    -- 0x 4C
	reg20 <= '1' when ( addr(7 downto 2) = "010100" ) else '0';    -- 0x 50
	reg21 <= '1' when ( addr(7 downto 2) = "010101" ) else '0';    -- 0x 54
	reg22 <= '1' when ( addr(7 downto 2) = "010110" ) else '0';    -- 0x 58
	reg23 <= '1' when ( addr(7 downto 2) = "010111" ) else '0';    -- 0x 5C
	reg24 <= '1' when ( addr(7 downto 2) = "011000" ) else '0';    -- 0x 60
	reg25 <= '1' when ( addr(7 downto 2) = "011001" ) else '0';    -- 0x 64
	reg26 <= '1' when ( addr(7 downto 2) = "011010" ) else '0';    -- 0x 68
	
	
------------------------------------------------------------------------------

-------------------------------- register 0/ Version/Board Info -----------------------------------------
	
-- This register contains board info such as firmware version, board version, and board/module type
-- Register is READ ONLY: user can not write to this board	
	
reg0_data <= MODULE_TYPE & BOARD_REV & FIRM_REV;  -- module information 
									
			
--------------------------------------------------------------------------------------
----------------------------------register 1/CSR (control/status)------------------------------------------------
	
-- note: byte order goes 0 1 2 3 (0 being bits 31-24)	
-- CSR will not be normal register
-- For the write only output: assign reg, the normal cycle (a24), associated byte, associated
-- bit of data_in, and the write strobe
	
	reset_hard          <= reg1 and a24_cycle and byte(0) and data_in(31) and write_stb;
	reset_soft          <= reg1 and a24_cycle and byte(0) and data_in(30) and write_stb;
	trig_soft           <= reg1 and a24_cycle and byte(0) and data_in(29) and write_stb;
	sync_soft           <= reg1 and a24_cycle and byte(0) and data_in(28) and write_stb;
	force_block_trailer <= reg1 and a24_cycle and byte(1) and data_in(16) and write_stb;
	
	read_csr <= reg1 and a24_cycle and read_stb; -- creates signal used to capture and hold value 

-- there are zeros where the write only ports would be (31-28 and 16)
	csr_data <= "0000" & "000000000" & block_trailer_fail & block_trailer_success & '0' &
		         "00000" & helicity_seq_error & empty_buffer_1 & empty_buffer_0 & busy_status_latched
					& busy_status & berr_status & no_events & block_level_flag & event_level_flag &
	 				locked_pll_mod & locked_pll_sys;
	
-- Don't need VME compatible register that has functionality to write/read bytes seperately 
-- We will use simple register comprised of 32 flip-flops

reg1_inst: dffe_32 port map ( d => csr_data,
										clk => clk,
										reset => reset,
										clk_enable => read_csr,
										q => reg1_data);        -- goes to MUX 
									
		
-- Essentially what's going on here is that we've formed a data word (csr_data - the word user wants to see) or, rather, taken a snap shot 
--of the status data using read_csr. This is done for Events on Board and Blocks on Board (use up-down counters)
-- because the data they hold is dynamic. Because of this, a register must be placed between the counters and the MUX.		
----------------------------------register 2/CTRL_1------------------------------------------------
	reg2_ce_b0 <= reg2 and a24_cycle and byte(0) and write_stb;
	reg2_ce_b1 <= reg2 and a24_cycle and byte(1) and write_stb;
	reg2_ce_b2 <= reg2 and a24_cycle and byte(2) and write_stb;
	reg2_ce_b3 <= reg2 and a24_cycle and byte(3) and write_stb;

reg2_inst: register_vme port map (  d 	=> data_in,
												ce_0 => reg2_ce_b0,
												ce_1 => reg2_ce_b1,
												ce_2 => reg2_ce_b2,
												ce_3 => reg2_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg2_data );   
--since there are spare bits(not read as 0) and therefore all bits can be read/written, don't nee reg2_data_int
-- bits 31-19 and 15-8 are spares (meaning they can still be written to/read if need be
												
		sysclk_select(0) <= reg2_data(0);  --system clock select (0=P0, 1=internal/Front Panel)
		sysclk_select(1) <= reg2_data(1);  --internal sytem clock enable (0=off,1=on)
		sysclk_select(2) <= reg2_data(2);  --internal/FP sys clock select(only if CTRL_1[0]=1)(0=internal,1=Front Panel)
		trig_select      <= reg2_data(4 downto 3);  -- selects trigger source (0=none,1=FP,2=P0,3=soft)
		sync_select      <= reg2_data(6 downto 5); -- selects SYNC_RESET source (0=none,1=FP,2=P0,3=soft)
		soft_enable      <= reg2_data(7);          -- enables Soft control signals
		interrupt_enable <= reg2_data(16);         -- enables interrupt
		berr_enable      <= reg2_data(17);         -- enables BERR response
		use_generator    <= reg2_data(18);         -- when on, use internal helicity generator
		
									
----------------------------------register 3/CTRL_2------------------------------------------------
	reg3_ce_b0 <= reg3 and a24_cycle and byte(0) and write_stb;    --controls writing to individual bytes on the register(and which register)
	reg3_ce_b1 <= reg3 and a24_cycle and byte(1) and write_stb;    --if reg3=0, then everything is 0 (b/c of and)
	reg3_ce_b2 <= reg3 and a24_cycle and byte(2) and write_stb;
	reg3_ce_b3 <= reg3 and a24_cycle and byte(3) and write_stb;

reg3_inst: register_vme port map (  d 	=> data_in,
												ce_0 => reg3_ce_b0,
												ce_1 => reg3_ce_b1,
												ce_2 => reg3_ce_b2,
												ce_3 => reg3_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg3_data );
												
-- just like reg2, do not require reg2_data_int because all bits are essentially "used"								
-- bits 2-7 and 9-31 are spares		
		decode_enable    <= reg3_data(0);  -- enables on board decoder
		trigger_enable   <= reg3_data(1);  -- enables triggers
		generator_enable <= reg3_data(8);  -- enables internal helicity generator (only if CTRL_1[18]=1)

----------------------------------register 4/ADR32------------------------------------------------
	reg4_ce_b0 <= reg4 and a24_cycle and byte(0) and write_stb;
	reg4_ce_b1 <= reg4 and a24_cycle and byte(1) and write_stb;
	reg4_ce_b2 <= reg4 and a24_cycle and byte(2) and write_stb;
	reg4_ce_b3 <= reg4 and a24_cycle and byte(3) and write_stb;

reg4_inst: register_vme port map (  d 	=> data_in,
												ce_0 => reg4_ce_b0,
												ce_1 => reg4_ce_b1,
												ce_2 => reg4_ce_b2,
												ce_3 => reg4_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg4_data_int );  
-- Only need to use reg4_data_int if you need to choose the bits you want to go to the MUX. If you wish for all of them, reg4_data is just fine.
-- (if you have any bits that are read as zero then must use reg4_data_int)
									
		reg4_data <= x"0000" & reg4_data_int(15 downto 7) & "000000" & reg4_data_int(0);
		en_adr32  <= reg4_data(0);
		adr32     <= reg4_data(15 downto 7);
		
		
----------------------------------register 5------------------------------------------------
	reg5_ce_b0 <= reg5 and a24_cycle and byte(0) and write_stb;
	reg5_ce_b1 <= reg5 and a24_cycle and byte(1) and write_stb;
	reg5_ce_b2 <= reg5 and a24_cycle and byte(2) and write_stb;
	reg5_ce_b3 <= reg5 and a24_cycle and byte(3) and write_stb;

reg5_inst: register_vme port map (  d 	=> data_in,
												ce_0 => reg5_ce_b0,
												ce_1 => reg5_ce_b1,
												ce_2 => reg5_ce_b2,
												ce_3 => reg5_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg5_data );
									
--		reg5_data <= x"00000005";	-- register output for use in controlling module

----------------------------------register 6/BLOCK SIZE------------------------------------------------
	reg6_ce_b0 <= reg6 and a24_cycle and byte(0) and write_stb;
	reg6_ce_b1 <= reg6 and a24_cycle and byte(1) and write_stb;
	reg6_ce_b2 <= reg6 and a24_cycle and byte(2) and write_stb;
	reg6_ce_b3 <= reg6 and a24_cycle and byte(3) and write_stb;

reg6_inst: register_vme port map (  d 	=> data_in,
												ce_0 => reg6_ce_b0,
												ce_1 => reg6_ce_b1,
												ce_2 => reg6_ce_b2,
												ce_3 => reg6_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg6_data_int );
									
		reg6_data  <= x"0000" & reg6_data_int(15 downto 0);
		block_size <= reg6_data(15 downto 0);

----------------------------------register 7/Latency------------------------------------------------
	reg7_ce_b0 <= reg7 and a24_cycle and byte(0) and write_stb;
	reg7_ce_b1 <= reg7 and a24_cycle and byte(1) and write_stb;
	reg7_ce_b2 <= reg7 and a24_cycle and byte(2) and write_stb;
	reg7_ce_b3 <= reg7 and a24_cycle and byte(3) and write_stb;

reg7_inst: register_vme port map (  d 	=> data_in,
												ce_0 => reg7_ce_b0,
												ce_1 => reg7_ce_b1,
												ce_2 => reg7_ce_b2,
												ce_3 => reg7_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg7_data_int );
												
		reg7_data <= "0000000000000000000000" & reg7_data_int(9 downto 0);
		
		latency <= reg7_data(9 downto 0);	

----------------------------------register 8/Helicity Config 1------------------------------------------------
	reg8_ce_b0 <= reg8 and a24_cycle and byte(0) and write_stb;
	reg8_ce_b1 <= reg8 and a24_cycle and byte(1) and write_stb;
	reg8_ce_b2 <= reg8 and a24_cycle and byte(2) and write_stb;
	reg8_ce_b3 <= reg8 and a24_cycle and byte(3) and write_stb;

reg8_inst: register_vme port map (  d => data_in,
												ce_0 => reg8_ce_b0,
												ce_1 => reg8_ce_b1,
												ce_2 => reg8_ce_b2,
												ce_3 => reg8_ce_b3,
												clk 	=> clk,
												reset => reset,
												q 	=> reg8_data_int );
									
		reg8_data <= reg8_data_int(31 downto 16) & reg8_data_int(15 downto 8) & "000000" & reg8_data_int(1 downto 0);
		
		generator_mode  <= reg8_data(1 downto 0);   -- pattern mode: 0=pair 1=quartet 2=octet 3=toggle
		helicity_delay  <= reg8_data(15 downto 8);  -- helicity delay in windows
		helicity_settle <= reg8_data(31 downto 16); -- helicity settle time (1 count = 40ns)
		
----------------------------------register 9/Helicity Config 2------------------------------------------------
	reg9_ce_b0 <= reg9 and a24_cycle and byte(0) and write_stb;
	reg9_ce_b1 <= reg9 and a24_cycle and byte(1) and write_stb;
	reg9_ce_b2 <= reg9 and a24_cycle and byte(2) and write_stb;
	reg9_ce_b3 <= reg9 and a24_cycle and byte(3) and write_stb;
	
reg9_inst: register_vme port map (  d => data_in,
												ce_0 => reg9_ce_b0,
												ce_1 => reg9_ce_b1,
												ce_2 => reg9_ce_b2,
												ce_3 => reg9_ce_b3,
												clk	=> clk,
												reset => reset,
												q => reg9_data_int );
												
		reg9_data       <= "0000" & reg9_data_int(27 downto 0);  
		helicity_stable <= reg9_data(27 downto 0);  -- helicity stable time (1 count=40ns)
		

----------------------------------register 10/Helicity Config 3------------------------------------------------
	reg10_ce_b0 <= reg10 and a24_cycle and byte(0) and write_stb;
	reg10_ce_b1 <= reg10 and a24_cycle and byte(1) and write_stb;
	reg10_ce_b2 <= reg10 and a24_cycle and byte(2) and write_stb;
	reg10_ce_b3 <= reg10 and a24_cycle and byte(3) and write_stb;
	
reg10_inst: register_vme port map (  d => data_in,
												ce_0 => reg10_ce_b0,
												ce_1 => reg10_ce_b1,
												ce_2 => reg10_ce_b2,
												ce_3 => reg10_ce_b3,
												clk	=> clk,
												reset => reset,
												q => reg10_data_int );
												
		reg10_data   <= "00" & reg10_data_int(29 downto 0);
		initial_seed <= reg10_data(29 downto 0);  -- initial pseudo-random sequence seed
		
----------------------------------register 11/Spare------------------------------------------------
	reg11_ce_b0 <= reg11 and a24_cycle and byte(0) and write_stb;
	reg11_ce_b1 <= reg11 and a24_cycle and byte(1) and write_stb;
	reg11_ce_b2 <= reg11 and a24_cycle and byte(2) and write_stb;
	reg11_ce_b3 <= reg11 and a24_cycle and byte(3) and write_stb;
	
reg11_inst: register_vme port map (  d => data_in,
												ce_0 => reg11_ce_b0,
												ce_1 => reg11_ce_b1,
												ce_2 => reg11_ce_b2,
												ce_3 => reg11_ce_b3,
												clk	=> clk,
												reset => reset,
												q => reg11_data );
												
		
		
----------------------------------register 12/Trigger 1 Scaler------------------------------------------------
-- main trigger coming in	
	
	read_trigger1_scaler <= reg12 and a24_cycle and read_stb;
	
--add scaler here instead of simple register
	reg12_inst: scalar_32 port map ( a => trigger_in,  -- trigger_in; will increment count
										      clk => clk,
										      reset => reset,
										      capture => read_trigger1_scaler,  -- take snapshot of count value when read of register trigger_1_scaler is requested
										      b => reg12_data );                   -- data to MUX for read out (b is value captured from counter and then stored in reg)
												
		
		
----------------------------------register 13/Trigger 2 Scaler------------------------------------------------
-- auxillary trigger; not really used, but we'll still count	
	
	read_trigger2_scaler <= reg13 and a24_cycle and read_stb;
	
reg13_inst: scalar_32 port map ( a => trigger_in,
										   clk => clk,
										   reset => reset,
										   capture => read_trigger2_scaler,
										   b => reg13_data );
												

		
----------------------------------register 14/SYNC RESET SCALER------------------------------------------------
	
	read_sync_scaler <= reg14 and a24_cycle and read_stb;
	
reg14_inst: scalar_32 port map ( a => sync_in,
											clk => clk,
											reset => reset,
											capture => read_sync_scaler,
											b => reg14_data );
												
		

------------------------------------------------------------------------------------------------

-- Registers 15-26 and register 5 will be made READ ONLY

-- The data read back for these registers will temporarily be assigned their register number (these values will go to the MUX)

----------------------------------register 15/EVENTS ON BOARD------------------------------------------------
	
	
--reg15_inst: register_vme port map (  d => data_in,
--												ce_0 => reg15_ce_b0,
--												ce_1 => reg15_ce_b1,
--												ce_2 => reg15_ce_b2,
--												ce_3 => reg15_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg15_data );
												
		reg15_data <= x"00000015";		

----------------------------------register 16------------------------------------------------
	
	
--reg16_inst: register_vme port map (  d => data_in,
--												ce_0 => reg16_ce_b0,
--												ce_1 => reg16_ce_b1,
--												ce_2 => reg16_ce_b2,
--												ce_3 => reg16_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg16_data );
												
		reg16_data <= x"00000016";
		
----------------------------------register 17------------------------------------------------
	
	
--reg17_inst: register_vme port map (  d => data_in,
--												ce_0 => reg17_ce_b0,
--												ce_1 => reg17_ce_b1,
--												ce_2 => reg17_ce_b2,
--												ce_3 => reg17_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg17_data );
												
		reg17_data <= x"00000017";

----------------------------------register 18------------------------------------------------
	
	
--reg18_inst: register_vme port map (  d => data_in,
--												ce_0 => reg18_ce_b0,
--												ce_1 => reg18_ce_b1,
--												ce_2 => reg18_ce_b2,
--												ce_3 => reg18_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg18_data );
												
		reg18_data <= x"00000018";		

----------------------------------register 19------------------------------------------------
	
	
--reg19_inst: register_vme port map (  d => data_in,
--												ce_0 => reg19_ce_b0,
--												ce_1 => reg19_ce_b1,
--												ce_2 => reg19_ce_b2,
--												ce_3 => reg19_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg19_data );
												
		reg19_data <= x"00000019";

----------------------------------register 20------------------------------------------------
	
	
--reg20_inst: register_vme port map (  d => data_in,
--												ce_0 => reg20_ce_b0,
--												ce_1 => reg20_ce_b1,
--												ce_2 => reg20_ce_b2,
--												ce_3 => reg20_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg20_data );
												
		reg20_data <= x"00000020";		

----------------------------------register 21------------------------------------------------
	
	
--reg21_inst: register_vme port map (  d => data_in,
--												ce_0 => reg21_ce_b0,
--												ce_1 => reg21_ce_b1,
--												ce_2 => reg21_ce_b2,
--												ce_3 => reg21_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg21_data );
												
		reg21_data <= x"00000021";

----------------------------------register 22------------------------------------------------
	
	
--reg22_inst: register_vme port map (  d => data_in,
--												ce_0 => reg22_ce_b0,
--												ce_1 => reg22_ce_b1,
--												ce_2 => reg22_ce_b2,
--												ce_3 => reg22_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg22_data );
												
		reg22_data <= x"00000022";	
	
----------------------------------register 23------------------------------------------------
	
	
--reg23_inst: register_vme port map (  d => data_in,
--												ce_0 => reg23_ce_b0,
--												ce_1 => reg23_ce_b1,
--												ce_2 => reg23_ce_b2,
--												ce_3 => reg23_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg23_data );
												
		reg23_data <= x"00000023";
	
----------------------------------register 24------------------------------------------------
	
	
--reg24_inst: register_vme port map (  d => data_in,
--												ce_0 => reg24_ce_b0,
--												ce_1 => reg24_ce_b1,
--												ce_2 => reg24_ce_b2,
--												ce_3 => reg24_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg24_data );
												
		reg24_data <= x"00000024";	
		
----------------------------------register 25------------------------------------------------
	
	
--reg25_inst: register_vme port map (  d => data_in,
--												ce_0 => reg25_ce_b0,
--												ce_1 => reg25_ce_b1,
--												ce_2 => reg25_ce_b2,
--												ce_3 => reg25_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg25_data );
												
		reg25_data <= x"00000025";
		
----------------------------------register 26------------------------------------------------
	
	
--reg26_inst: register_vme port map (  d => data_in,
--												ce_0 => reg26_ce_b0,
--												ce_1 => reg26_ce_b1,
--												ce_2 => reg26_ce_b2,
--												ce_3 => reg26_ce_b3,
--												clk	=> clk,
--												reset => reset,
--												q => reg26_data );
												
		reg26_data <= x"00000026";
		
---------------------------------------------------------------------------------------------
		reg27_data <= x"00000027";
		reg28_data <= x"00000028";
		reg29_data <= x"00000029";
		reg30_data <= x"00000030";
		reg31_data <= x"00000031";
		
-- NOW must multiplex data from the registers (reg0_data, reg1_data, reg2_data, ... , reg15_data) onto data_out
-- so register values can be read


mux_inst: mux_32 port map ( d0_in => reg0_data,
									 d1_in => reg1_data,
									 d2_in => reg2_data,
									 d3_in => reg3_data,
									 d4_in => reg4_data,
									 d5_in => reg5_data,
									 d6_in => reg6_data,
									 d7_in => reg7_data,
							   	 d8_in => reg8_data,
									 d9_in => reg9_data,
									 d10_in => reg10_data,
									 d11_in => reg11_data,
									 d12_in => reg12_data,
									 d13_in => reg13_data,
									 d14_in => reg14_data,
									 d15_in => reg15_data,
									 d16_in => reg16_data,
									 d17_in => reg17_data,
									 d18_in => reg18_data,
								    d19_in => reg19_data,
									 d20_in => reg20_data,
									 d21_in => reg21_data,
									 d22_in => reg22_data,
									 d23_in => reg23_data,
									 d24_in => reg24_data,
									 d25_in => reg25_data,
									 d26_in => reg26_data,
									 d27_in => reg27_data,
									 d28_in => reg28_data,
									 d29_in => reg29_data,
									 d30_in => reg30_data,
									 d31_in => reg31_data,
									 sel => addr(6 downto 2), --Chose this based on addresses for registers 
									 d_out => data_out);
			 
			
end a1;