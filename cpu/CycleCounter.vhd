--**************************************************************************************************** 
-- Cycle counter for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 17.01.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity CycleCounter is port ( 
						   -- Global control signals 
	                       nRESET    : in  std_logic; 
						   CLK       : in  std_logic; 
						   CLKEN     : in  std_logic; 
						   -- Transaction type 
						   TRANS     : in  std_logic_vector(1 downto 0) 
   						    ); 
end CycleCounter; 
 
architecture RTL of CycleCounter is 
constant CycleCntWidth : positive := 32;  
signal CycleCnt : std_logic_vector (CycleCntWidth-1 downto 0) := (others => '0'); 
 
signal NCycleCnt : std_logic_vector (CycleCntWidth-1 downto 0) := (others => '0'); 
signal SCycleCnt : std_logic_vector (CycleCntWidth-1 downto 0) := (others => '0'); 
signal ICycleCnt : std_logic_vector (CycleCntWidth-1 downto 0) := (others => '0'); 
signal CCycleCnt : std_logic_vector (CycleCntWidth-1 downto 0) := (others => '0'); 
 
begin 
 
CycleCounter:process(nRESET,CLK) 
begin 
if nRESET='0' then                          -- Reset 
  CycleCnt  <= (others =>'0'); 
  ICycleCnt <= (others =>'0'); 
  NCycleCnt <= (others =>'0'); 
  SCycleCnt <= (others =>'0'); 
  CCycleCnt <= (others =>'0'); 
 
 elsif CLK='1' and CLK'event then           -- Clock 
   if CLKEN='1' then                        -- Clock enable 
    CycleCnt  <= CycleCnt+1; 
 
   case TRANS is 
   when CTT_I => ICycleCnt <= ICycleCnt+1;  
   when CTT_N => NCycleCnt <= NCycleCnt+1;  
   when CTT_S => SCycleCnt <= SCycleCnt+1;  
   when CTT_C => CCycleCnt <= CCycleCnt+1;  
   when others => null;  
   end case;	    
    
   end if;	 
end if; 
end process;			 
 
end RTL; 
