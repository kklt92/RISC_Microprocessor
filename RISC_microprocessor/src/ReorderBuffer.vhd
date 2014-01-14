--******************************************************************************--
--	Author:			Weihao Ming													--
--	Date:			2014-01-13													--
--	Module:			EE3A1 RISC Microprocessor									-- 
--	Description: 	Re-order buffer. Placing before instruction decoder			--
--					and automatic re-order instruction for 						--
--					microprocessor.												--
--******************************************************************************--


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;  
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;


ENTITY reorderBuffer IS
	PORT(	in1 : 		IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			out1: 		OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			clk: 		IN STD_LOGIC);		
END ENTITY reorderBuffer;

ARCHITECTURE rtl OF reorderBuffer IS
	TYPE buffer_array IS ARRAY( 0 TO 5) OF STD_LOGIC_VECTOR ( 31 DOWNTO 0);
	SIGNAL buffer_data: buffer_array:=	(X"00000000", X"00000000", X"00000000",	  	-- 6 addresses buffer.
										X"00000000", X"00000000", X"00000000");	

	
BEGIN
	PROCESS(clk)
	variable i: integer := 2;													-- i is for pre-running instruction.			  
	variable j: integer := 0;													-- j is for post-running instruction.
	variable c: integer := 0;													-- 0 for incomplete output. 1 for complete.
	variable output1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";			-- Temperaryly store output.
	variable buffer_temp : buffer_array := buffer_data;						 	-- Copy all the data in buffer to
	BEGIN																	  	-- re-order it. and pushing everything
		IF(rising_edge(clk)) THEN											  	-- forward to fullfill empty address.
			i := 2;
			j := 0;
			c := 0;
			WHILE ( i < 6 ) LOOP										   		-- Storing incoming instruction in an empty address.
				IF( buffer_data(i) /= X"00000000")THEN                         	
					i := i + 1;
				ELSE
					buffer_data(i) <= in1;
					buffer_temp(i) := in1;
					i := 0;
					EXIT;
				END IF;
			END LOOP;
			i := 2;
			j := 0;
			c := 0;
			WHILE ( i < 6 ) LOOP
				IF( buffer_data(0) = X"00000000")                           	-- If previous two instructions are both no-op,
							AND (buffer_data(1) = X"00000000") THEN            	-- then output first no no-op instruction.
					IF(buffer_data(i) /= X"00000000") THEN
				    	out1 <= buffer_data(i);
						buffer_data(i) <= X"00000000";
						buffer_temp(i) := X"00000000";
						output1 := buffer_data(i);
						i := 2;
						c := 1;
						EXIT;
					ELSE
						i := i+1; 
					END IF;
				ELSIF (buffer_data(1)(15 DOWNTO 11) = buffer_data(2)(25 DOWNTO 21)) THEN  	-- If current reading is previous written,
					out1 <= buffer_data(2);													-- then output to meet multiplexer funtion.
					output1 := buffer_data(2);
					buffer_data(2) <= X"00000000";
					buffer_temp(2) := X"00000000";
					i :=2;
					c :=1;
					EXIT;
				ELSE
					j := 0;																	-- Check if there is data hazard. if so, then reorder.
					WHILE ( j < 3 ) LOOP
						IF(buffer_data(j) /= X"00000000") THEN
							IF( buffer_data(i)(25 DOWNTO 21) /= buffer_data(j)(15 DOWNTO 11)) THEN
								IF(buffer_data(i)(20 DOWNTO 16) /= buffer_data(j)(15 DOWNTO 11)) THEN
									IF(buffer_data(i) /= X"00000000") THEN
										out1 <= buffer_data(i);
										output1 := buffer_data(i);
										buffer_data(i) <= X"00000000";
										buffer_temp(i) :=  X"00000000";
										i := 2;
										j := 0;
										c := 1;
										EXIT;
									ELSE
										j := j+1;
									END IF;
								ELSE
									j := j+1;
								END IF;
							ELSE
								j := j+1;
							END IF;
						ELSE
							j := j + 1;
						END IF;						
					END LOOP;
				END IF;
						
				IF ( c = 0) THEN		
					i := i + 1;
				ELSE
					i := 2;
					j := 0;
					EXIT;
				END IF;
		
				
			END LOOP;
			IF ( c = 0) THEN							  	-- If there will be data harzard for all buffer instruction,
				out1 <= X"00000000";					  	-- then output no-op.
				output1 := X"00000000";
				c := 1;
			END IF;
			buffer_data(0) <= buffer_data(1);
			buffer_data(1) <= output1;
			
			i := 2;
			WHILE( i < 5) LOOP                          	-- Pushing buffer data forward to fullfill empty address.
				IF(buffer_temp(i) = X"00000000") THEN
					buffer_temp(i) := buffer_temp(i+1);
					buffer_temp(i+1) := X"00000000";
				END IF;
				i := i+1;
			END LOOP;
			
			i:=2;
			WHILE( i < 6) LOOP                        		-- Writing temperary data to address.
				buffer_data(i) <= buffer_temp(i);
				i := i+1;
			END LOOP;
						
		END IF;
	END PROCESS;
END ARCHITECTURE rtl;