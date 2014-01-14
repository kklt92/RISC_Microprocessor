--******************************************************************************--
--	Author:			Weihao Ming													--
--	Date:			2014-01-13													--
--	Module:			EE3A1 RISC Microprocessor									-- 
--	Description: 	This file is basic motherbroad of microprocessor.			--
--					It has linking wires, instruction decoder,					--
--					and multiplexer controller.									--
--******************************************************************************--


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mpBeta IS
	PORT ( 	clk: 			IN STD_LOGIC;                                       	-- Two ports input. One for clock and another one for instruction.
			instruction1: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0) );
END ENTITY mpBeta;

ARCHITECTURE rtl OF mpBeta IS
SIGNAL 	instruction2:  													STD_LOGIC_VECTOR(31 DOWNTO 0);		-- Recieving instruction from re-order buffer.
SIGNAL 	linkOut1a, linkOut2b, linkResultInput1, linkResultInput2: 		STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
SIGNAL 	address1_input, address2_input, 
		address3_input1, address3_input2, address3_input3: 				STD_LOGIC_VECTOR ( 4 DOWNTO 0 );
SIGNAL 	opcode_input1, opcode_input2: 									STD_LOGIC_VECTOR (	5 DOWNTO 0 ); 
SIGNAL 	inout1: 														STD_LOGIC_VECTOR ( 31 DOWNTO 0);	-- Wires connected Multiplexer and Register.	
SIGNAL 	feed: 															STD_LOGIC;							-- Multiplexer Controller
	
BEGIN
	g1: ENTITY work.rom(rtl)
		PORT MAP( 	output1 => inout1, output2 => linkOut2b, input => linkResultInput2,							 					 
					address1 => address1_input, address2 => address2_input, 
					address3 => address3_input3, clk => clk);
	g2: ENTITY work.alu(rtl)
		PORT MAP( 	a => linkOut1a, b => linkOut2b, result => linkResultInput1,
					opcode => opcode_input2, clk => clk);
	g3: ENTITY work.rForward(rtl)														-- Multiplexer. I call it register forward.
		PORT MAP( 	feed => feed, inout1 => inout1, feedback1 => linkResultInput2, 
					out1 => linkOut1a);
	g4: ENTITY work.reorderBuffer(rtl)
		PORT MAP( 	in1 => instruction1, out1 => instruction2, clk => clk);
		
		
	opcode_input1 <= instruction2(31 DOWNTO 26);      				-- Instruction decoder.
	address1_input <= instruction2(25 DOWNTO 21);
	address2_input <= instruction2(20 DOWNTO 16);
	address3_input1 <= instruction2(15 DOWNTO 11);

	process(clk)
	begin
		if ( rising_edge(clk) ) then
			address3_input2 <= address3_input1;            			-- D-type flip-flop between wires to keep pipeline stable.
			address3_input3 <= address3_input2;
			linkResultInput2 <= linkResultInput1;
			opcode_input2 <= opcode_input1;
			if (address1_input = address3_input2)then          		-- Check if current read address is same as 
				feed <= '1';										-- previous write address. If it is same then enable multiplexer.
			ELSE
				feed <= '0';
			end if;	
		end if;	
	end process;
	
END ARCHITECTURE rtl;

	