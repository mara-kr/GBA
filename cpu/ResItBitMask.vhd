--**************************************************************************************************** 
-- This module cleares/sets bit 0 and clears 1 of ALU bus for ARM7TDMI-S processor 
-- Designed by Ruslan Lepetenok 
-- Modified 18.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity ResltBitMask is port( 
					   -- Data 
	                   DataIn     : in  std_logic_vector(31 downto 0); 
	                   DataOut    : out std_logic_vector(31 downto 0); 
					   -- Control 
					   ClrBitZero : in std_logic; 
					   ClrBitOne  : in std_logic; 
					   SetBitZero : in std_logic 
	                  ); 
end ResltBitMask; 
 
architecture RTL of ResltBitMask is 
begin 
 
DataOut(DataOut'high downto 2)<= DataIn(DataIn'high downto 2);	 
	 
DataOut(0) <= (DataIn(0) and not(ClrBitZero or SetBitZero))or -- Nomal mode (pass bit[0]) 
              SetBitZero;                                     -- Set bit[0] - Thumb mode Branch with link (LR bit[0]='1') 
 
DataOut(1) <= '0' when ClrBitOne='1' else DataIn(1); 
 
	 
end RTL; 
