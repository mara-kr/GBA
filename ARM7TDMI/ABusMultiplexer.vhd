--**************************************************************************************************** 
-- A bus multiplexer for ARM7TDMI-S processor 
-- Designed by Ruslan Lepetenok 
-- Modified 04.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity ABusMultiplexer is port( 
					   -- Data input 
	                   RegFileAOut       : in  std_logic_vector(31 downto 0); 
	                   MultiplierAOut    : in  std_logic_vector(31 downto 0); 
					   CPSROut           : in  std_logic_vector(31 downto 0);  
					   SPSROut           : in  std_logic_vector(31 downto 0);  
					   -- Control 
					   RegFileAOutSel    : in  std_logic; 
	                   MultiplierAOutSel : in  std_logic; 
					   CPSROutSel        : in  std_logic;  
					   SPSROutSel        : in  std_logic;  
					   -- Data output 
					   ABusOut		     : out std_logic_vector(31 downto 0) 
					          ); 
end ABusMultiplexer; 
 
architecture RTL of ABusMultiplexer is 
begin 
 
ABusMux:for i in ABusOut'range generate 
ABusOut(i) <= (RegFileAOut(i) and RegFileAOutSel)or 
              (MultiplierAOut(i) and MultiplierAOutSel)or 
			  (CPSROut(i) and CPSROutSel)or 
			  (SPSROut(i) and SPSROutSel); 
end generate;	 
	 
	 
end RTL;

