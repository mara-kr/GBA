--**************************************************************************************************** 
-- Address and address class signals registers for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 07.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity AdrCtrlReg is port ( 
						   -- Global control signals 
	                       nRESET    : in  std_logic; 
						   CLK       : in  std_logic; 
						   CLKEN     : in  std_logic; 
						   -- Address class signals  
						   ADDR_In   : in  std_logic_vector(31 downto 0); 
						   WRITE_In  : in  std_logic; 
						   SIZE_In   : in  std_logic_vector(1 downto 0); 
						   -- Outputs 
						   ADDR_Out  : out std_logic_vector(31 downto 0); 
						   WRITE_Out : out std_logic; 
						   SIZE_Out  : out std_logic_vector(1 downto 0) 
						  ); 
end AdrCtrlReg; 
 
architecture RTL of AdrCtrlReg is 
begin 
 
AdrClassSigReg:process(nRESET,CLK) 
begin 
if nRESET='0' then                          -- Reset 
  ADDR_Out  <= (others =>'0'); 
  WRITE_Out <= '0'; 
  SIZE_Out  <= (others =>'0'); 
  elsif CLK='1' and CLK'event then           -- Clock 
   if CLKEN='1' then                          -- Clock enable 
  ADDR_Out  <= ADDR_In; 
  WRITE_Out <= WRITE_In; 
  SIZE_Out  <= SIZE_In;	  
   end if;	 
end if; 
end process;			 
	 
end RTL; 
