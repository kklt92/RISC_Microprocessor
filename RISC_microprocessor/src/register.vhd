--******************************************************************************--
--	Author:			Weihao Ming													--
--	Date:			2014-01-13													--
--	Module:			EE3A1 RISC Microprocessor									-- 
--	Description: 	Register file. Storing rom data. 							--
--******************************************************************************--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY rom IS
	PORT (	address1: 		IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			address2: 		IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			address3: 		IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			output1: 		OUT STD_LOGIC_VECTOR( 31 DOWNTO 0);
			output2: 		OUT STD_LOGIC_VECTOR( 31 DOWNTO 0);
			input: 			IN STD_LOGIC_VECTOR( 31 DOWNTO 0); 
			clk: 			IN STD_LOGIC);
END ENTITY rom;

ARCHITECTURE rtl OF rom IS
	TYPE rom_array IS ARRAY( 0 TO 31) OF STD_LOGIC_VECTOR ( 31 DOWNTO 0);
	SIGNAL rom_data: rom_array:= ( 	X"00000000", X"00000000", X"00000000", X"00000140",		  -- Stored data array.
									X"00001F87", X"000079B1", X"00000237", X"0000C18F",
									X"0000B5A3", X"000177AB", X"00005423", X"0000EBA7",
									X"000073D8", X"0000D8C2", X"00017BF1", X"0000F58C",
									X"00016DA5", X"000077F0", X"000092DD", X"00009EA0",
									X"00007923", X"0000861F", X"0001816D", X"00014E32",
									X"0000C93A", X"00004876", X"0000729F", X"00005328",
									X"000051C5", X"00007030", X"0001336D", X"0000C5BF" );
BEGIN
	PROCESS(clk)
	BEGIN
		IF ( rising_edge(clk) ) THEN									-- Running every at clock rising edge.
			output1 <= rom_data ( CONV_INTEGER (address1) );			-- Push data indicated address by input.
			output2 <= rom_data ( CONV_INTEGER (address2) );
			IF ( input /= "UUUUUUUU") THEN								-- Written protected. Disable written function
				IF( input /= "XXXXXXXX") THEN                         	-- when input is U(unintial) or X(unknown).
					rom_data ( CONV_INTEGER (address3) ) <= input;
				END IF;	
			END IF;	
		END IF;
	END PROCESS;
END ARCHITECTURE rtl;
























	