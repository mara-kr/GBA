--**************************************************************************************************** 
-- Address multiplexer and incrementer for ARM7TDMI-S processor 
-- Designed by Ruslan Lepetenok 
-- Modified 15.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
entity AddressMux_Incrementer is port( 
					   -- Clock and reset 
				       nRESET               : in  std_logic;  
					   CLK                  : in  std_logic; 
					   CLKEN                : in  std_logic; 
	                   -- Address and control 
					   ADDR                 : out std_logic_vector(31 downto 0); 
				 	   FromPC		        : in  std_logic_vector(31 downto 0); 
					   ToPC			        : out std_logic_vector(31 downto 0); 
					   FromALU		        : in  std_logic_vector(31 downto 0); 
					   ExceptionVector      : in  std_logic_vector(31 downto 0); 
					   PCInSel		        : in  std_logic; 
					   ALUInSel		        : in  std_logic; 
					   ExceptionVectorSel   : in  std_logic; 
					   PCIncStep            : in  std_logic; 
					   AdrIncStep			: in  std_logic; 
					   AdrToPCSel	        : in  std_logic; 
					   AdrCntEn	            : in  std_logic 
					                  ); 
					    
end AddressMux_Incrementer; 
 
architecture RTL of AddressMux_Incrementer is 
 
signal AddressMUX  : std_logic_vector(ADDR'range) := (others => '0');  
signal Adr_Inc     : std_logic_vector(ADDR'range) := (others => '0');  
signal AdrReg      : std_logic_vector(ADDR'range) := (others => '0');  
signal PC_Inc      : std_logic_vector(ADDR'range) := (others => '0');  
 
begin 
 
Adr_Inc <= AddressMUX +4 when AdrIncStep='0' else  -- ARM mode or Load/Store multiple  
		   AddressMUX +2;                          -- Thumb mode 
 
PC_Inc <= FromPC +4 when PCIncStep='0' else  -- ARM mode 
		  FromPC +2;                             -- Thumb mode 
   
AddressIncReg:process(nRESET,CLK) 
begin 
if nRESET='0' then                           -- Reset 
  AdrReg  <= (others => '0');      
elsif CLK='1' and CLK'event then             -- Clock 
 if AdrCntEn='1' and CLKEN='1' then  -- Clock enable 
  AdrReg <= Adr_Inc; 
 end if;		 
end if;	 
end process;	 
 
AdrInMUX:for i in AddressMUX'range generate 
AddressMUX(i) <= (FromPC(i) and PCInSel)or									     -- Load/store operations 
                 (FromALU(i) and ALUInSel)or									 -- Branches 
                 (ExceptionVector(i) and ExceptionVectorSel)or                   -- Exceptions 
				 (AdrReg(i) and not(PCInSel or ALUInSel or ExceptionVectorSel)); -- Nomal program execution 
end generate; 
 
 
-- Outputs 
ADDR <= AddressMUX; 
ToPC <= AddressMUX when AdrToPCSel='1' else PC_Inc; 
 
end RTL; 

