--**************************************************************************************************** 
-- Memory remapper for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 26.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity MemoryRemapper is generic (RemapperAddress : std_logic_vector(31 downto 0)); 
	                    port ( 
						   -- Global control signals 
	                       nRESET     : in  std_logic; 
						   CLK        : in  std_logic; 
						   CLKEN      : in  std_logic; 
						   -- Address and data 
                           Address    : in  std_logic_vector(31 downto 0); 
					       ByteWE	  : in  std_logic_vector(3 downto 0); 
		                   DataIn     : in  std_logic_vector(31 downto 0); 
						   -- Memory select signals for remapping 
						   SelDevAIn  : in  std_logic; 
						   SelDevBIn  : in  std_logic; 
						   SelDevAOut : out std_logic; 
						   SelDevBOut : out std_logic 
						   ); 
end MemoryRemapper; 
 
architecture RTL of MemoryRemapper is 
 
signal RemapReg : std_logic := '0'; 
 
begin 
 
RemapperRegister:process(nRESET,CLK) 
begin 
if nRESET='0' then                          -- Reset 
  RemapReg <= '0'; 
  elsif CLK='1' and CLK'event then           -- Clock 
   if Address=RemapperAddress and ByteWE(ByteWE'low)='1' and CLKEN='1' then -- Clock enable 
	RemapReg <= DataIn(DataIn'low) or RemapReg; 
   end if;	 
end if; 
end process;			 
 
SelDevAOut <= SelDevAIn when RemapReg='1' else SelDevBIn; 
SelDevBOut <= SelDevBIn when RemapReg='1' else SelDevAIn; 
 
end RTL; 
