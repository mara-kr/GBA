--**************************************************************************************************** 
-- B bus multiplexer for ARM7TDMI-S processor 
-- Designed by Ruslan Lepetenok 
-- Modified 04.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity BBusMultiplexer is port( 
					   -- Data input 
	                   RegFileBOut        : in  std_logic_vector(31 downto 0); 
	                   MultiplierBOut     : in  std_logic_vector(31 downto 0); 
					   MemDataRegOut      : in  std_logic_vector(31 downto 0); 
					   AdrGenDataOut	  : in  std_logic_vector(31 downto 0); 
					   -- Immediate fields 
					   SExtOffset24Bit    : in  std_logic_vector(31 downto 0); 
                       Offset12Bit        : in  std_logic_vector(31 downto 0); 
                       Offset8Bit         : in  std_logic_vector(31 downto 0); 
                       Immediate8Bit      : in  std_logic_vector(31 downto 0); 
					   -- Control 
					   RegFileBOutSel     : in  std_logic;	-- Output of the register file 
	                   MultiplierBOutSel  : in  std_logic;	-- Output of the multiplier 
					   MemDataRegOutSel   : in  std_logic;	-- Output of the data in register 
					   SExtOffset24BitSel : in  std_logic; 
                       Offset12BitSel     : in  std_logic; 
                       Offset8BitSel      : in  std_logic; 
                       Immediate8BitSel   : in  std_logic; 
					   AdrGenDataSel	  : in  std_logic; 
					   -- Data output 
					   BBusOut		      : out std_logic_vector(31 downto 0)	 -- Connected to the input of the shifter 
					          ); 
end BBusMultiplexer; 
 
architecture RTL of BBusMultiplexer is 
begin 
 
BBusMux:for i in BBusOut'range generate 
BBusOut(i) <= (RegFileBOut(i) and RegFileBOutSel)or 
              (MultiplierBOut(i) and MultiplierBOutSel)or 
			  (MemDataRegOut(i) and MemDataRegOutSel)or  
			  (SExtOffset24Bit(i) and SExtOffset24BitSel)or  
			  (Offset12Bit(i) and Offset12BitSel)or  
			  (Offset8Bit(i) and Offset8BitSel)or  
			  (Immediate8Bit(i) and Immediate8BitSel)or 
			  (AdrGenDataOut(i) and AdrGenDataSel); 
end generate;	 
	 
end RTL;
