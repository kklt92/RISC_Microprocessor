--******************************************************************************--
--	Author:		Weihao Ming	        		        	--
--	Date:		2014-01-13						--
--	Module:		EE3A1 RISC Microprocessor				-- 
--	Description: 	ALU. Responsibilty for calculation.			--
--******************************************************************************--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY alu IS
	PORT ( 	a, b: 		IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		opcode: 	IN STD_LOGIC_VECTOR( 5 DOWNTO 0);
		result: 	OUT STD_LOGIC_VECTOR( 31 DOWNTO 0);
		clk: 		IN STD_LOGIC);
END ENTITY alu;


ARCHITECTURE rtl OF alu IS

BEGIN 
	PROCESS(a,b,opcode)			  -- Action when a, b, or opcode is changed.
	BEGIN
		CASE opcode IS 					  
			WHEN "000100" =>
				result <= a + b;
			WHEN "001110" =>
				result <= a - b;
			WHEN "001111" =>
				result <= abs(a);
			WHEN "001000" =>
				result <= -a;
			WHEN "000010" =>
				result <= abs(b);
			WHEN "001010" =>
				result <= -b;
			WHEN "001100" =>
				result <= a or b;
			WHEN "000110" =>
				result <= not a;
			WHEN "000011" =>
				result <= not b;
			WHEN "001011" =>
				result <= a and b;
			WHEN "000101" =>
				result <= a xor b;
			WHEN OTHERS =>
				result <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";  		-- Output X(unknown) when opcode is invalid,
		END CASE;								-- and register will enable written protection automatic.
	END PROCESS;
END ARCHITECTURE rtl;
