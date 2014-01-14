LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY testP IS
END ENTITY testP;

ARCHITECTURE test of testP IS
	TYPE in1_array IS ARRAY( 0 TO 32) OF STD_LOGIC_VECTOR ( 31 DOWNTO 0);
	SIGNAL in1_data: in1_array := ( B"000100_00001_00011_00001_00000000000", B"000100_00001_00100_00001_00000000000", 
									B"001110_00001_00101_00001_00000000000", B"001110_00001_00110_00001_00000000000", 
									B"000100_00001_00111_00001_00000000000", B"000100_00001_01000_00001_00000000000",
									B"001110_00001_01001_00001_00000000000", B"001110_00001_01010_00001_00000000000",
									B"000100_00001_01011_00001_00000000000", B"000100_00001_01100_00001_00000000000",
									B"001110_00001_01101_00001_00000000000", B"001110_00001_01110_00001_00000000000",
									B"000100_00001_01111_00001_00000000000", B"000100_00001_10000_00001_00000000000",
									B"001110_00001_10001_00001_00000000000", B"001110_00001_10010_00001_00000000000",
									B"000100_00001_10011_00001_00000000000", B"000100_00001_10100_00001_00000000000",
									B"001110_00001_10101_00001_00000000000", B"001110_00001_10110_00001_00000000000",
									B"000100_00001_10111_00001_00000000000", B"000100_00001_11000_00001_00000000000",
									B"001110_00001_11001_00001_00000000000", B"001110_00001_11010_00001_00000000000",
									B"000100_00001_11011_00001_00000000000", B"000100_00001_11100_00001_00000000000",
									B"001110_00001_11101_00001_00000000000", B"001110_00001_11110_00001_00000000000",
									B"000100_00001_11111_00001_00000000000", B"000000_00000_00000_00000_00000000000",
									B"000000_00000_00000_00000_00000000000",B"000000_00000_00000_00000_00000000000",
									B"000000_00000_00000_00000_00000000000");
	SIGNAL in1: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL clk: STD_LOGIC;

BEGIN
	g1: ENTITY work.mpBeta(rtl)
		PORT MAP( instruction1 => in1, clk => clk);
		
	PROCESS
	BEGIN
		clk <= '1';
		WAIT FOR 1 NS;
		clk <= '0';
		WAIT FOR 1 NS;
	END PROCESS;
	
	process
	begin
		FOR i IN 0 TO 32 LOOP
		in1 <= in1_data(i);
		WAIT UNTIL rising_edge(clk);
		END LOOP;
		WAIT;				 
	end process;
	
END ARCHITECTURE test;
	