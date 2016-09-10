--**************************************************************************************************** 
-- ARM barrel shifter testbench 
-- Designed by Ruslan Lepetenok 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
use IEEE.std_logic_arith.all; 
 
entity ShifterTestbench is port ( 
	                    ShTbIn       : in  std_logic_vector(31 downto 0); -- Input data 
						ShTbOut      : out std_logic_vector(31 downto 0);	-- Output data 
	                    ShTbCFlagIn  : in  std_logic; -- Input of the carry flag  
						ShTbCFlagOut : out std_logic; -- Output of the carry flag  
						ShEn         : out  std_logic; -- Shifter enable 
						ShLen        : out  std_logic_vector(31 downto 0); -- Shift length !!! 
						ShType       : out  std_logic_vector(1 downto 0); -- Shift type (bits 6 and 5 of instruction) 
						ShRotImm     : out  std_logic  -- Rotate immediate 8-bit value 
								 ); 
end ShifterTestbench; 
 
architecture BEH of ShifterTestbench is 
begin 
 
Test:process 
variable TestVar : integer := 0; 
begin 
 
for i 0 to 	 
	 
	 
	 
end process; 
	 
	 
end BEH;
