--******************************************************************************--
--	Author:			Weihao Ming													--
--	Date:			2014-01-13													--
--	Module:			EE3A1 RISC Microprocessor									-- 
--	Description: 	Multiplexer. Forwarding result from ALU back to            	--
--					ALU for next calculation.									--
--******************************************************************************--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY rForward IS
	PORT ( 	feed: 				IN STD_LOGIC;
			feedback1, inout1: 	IN STD_LOGIC_VECTOR( 31 DOWNTO 0);
			out1: 				OUT STD_LOGIC_VECTOR ( 31 DOWNTO 0));
END ENTITY rForward;

ARCHITECTURE rtl OF rForward IS
BEGIN
	out1 <= feedback1 when feed = '1' ELSE inout1;		-- Forward result back to ALU when 	 	
END ARCHITECTURE rtl;									-- multiplexer controller is enable.