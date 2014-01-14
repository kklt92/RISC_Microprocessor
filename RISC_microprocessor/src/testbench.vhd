LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY testbench IS
END ENTITY testbench;

ARCHITECTURE test OF testbench IS
SIGNAL in1, in2, out1: STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL in3: STD_LOGIC_VECTOR (5 DOWNTO 0);

BEGIN
	g1: ENTITY work.alu(rtl)
		PORT MAP ( a=>in1, b=>in2, opcode=>in3, result=>out1);
		in1 <= X"00000140", X"000079B1" AFTER 20 NS, X"0000C18F" AFTER 40 NS;
		in2 <= X"00001F87", X"00000237" AFTER 20 NS, X"0000B5A3" AFTER 40 NS;
		in3 <= B"000100", B"001110" AFTER 20 NS, B"000100" AFTER 40 NS;
END ARCHITECTURE test;				
