-- ***************************************************************************************** 
-- Constants and type declarations for memory subsystem for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 07.02.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
 
package ARMSMSSPackage is 
 
constant DecoderAdrWidth  : positive := 16; 
constant CSlowMemAdrWidth : positive := 16; -- Address width for slow memory detection (CLKEN generation) 
constant CAbtMemAdrWidth  : positive := 16; -- Address width for memory abort detection (ABORT generation) 
 
-- Device addresses 
constant CROMAddress  : std_logic_vector(DecoderAdrWidth-1 downto 0) := x"0030";  
constant CRAMAddress  : std_logic_vector(DecoderAdrWidth-1 downto 0) := x"0000";  
constant CDevCAddress : std_logic_vector(DecoderAdrWidth-1 downto 0) := x"0001";  
constant CDevDAddress : std_logic_vector(DecoderAdrWidth-1 downto 0) := x"0002";  
 
-- Memory remapper register addrerss 
constant CRemapperAddress : std_logic_vector(31 downto 0) := x"FFE00020"; 
 
-- Name of log file for bus 
constant CLogFileName : string := "BusLog.txt"; 
 
-- Function declaration 
function LOG2(Number : positive) return natural; 
end ARMSMSSPackage; 
 
package	body ARMSMSSPackage is 
 
-- Functions	 
function LOG2(Number : positive) return natural is 
variable Temp : positive := 1; 
begin 
if Number=1 then  
 return 0; 
  else  
   for i in 1 to integer'high loop 
    Temp := 2*Temp;  
     if Temp>=Number then  
      return i; 
     end if; 
end loop;
return 0; 
end if;	 
end LOG2;	 
-- End of functions	 
 
end ARMSMSSPackage;
