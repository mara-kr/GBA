--**************************************************************************************************** 
-- Behavioural model of CLKEN generation for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 01.01.2003 
--**************************************************************************************************** 
 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use Work.ARMSMSSPackage.all; 
use WORK.ARMPackage.all; 
 
entity CLKENGenerator is generic(SlowMemAdr : std_logic_vector(CSlowMemAdrWidth-1 downto 0); 
								 NumberOfWS : positive 
	                            ); 
	              port( 
		     		   -- Global control signals 
        			   nRESET  : in  std_logic; 
					   CLK     : in  std_logic; 
					   -- Memory request signals 
					   TRANS   : in  std_logic_vector(1 downto 0); 
					   -- ADDR and data 
					   ADDR    : in  std_logic_vector(31 downto 0); 
                       -- Output 
					   CLKEN   : out std_logic 
					   ); 
end CLKENGenerator; 
 
architecture Beh of CLKENGenerator is 
 
signal CLKEN_Int : std_logic := '0'; 
 
begin 
 
CLKENGen:process(nRESET,CLK) 
variable WSCnt : natural := 0; 
begin 
if nRESET='0' then                          -- Reset 
 CLKEN_Int <= '1'; 
 WSCnt := 0; 
  elsif CLK='1' and CLK'event then           -- Clock 
   case CLKEN_Int is  
	when '1' => 
     if SlowMemAdr=ADDR(SlowMemAdr'range) and (TRANS=CTT_N or TRANS=CTT_S) then 
      CLKEN_Int <= '0';	 	 
	  WSCnt := NumberOfWS; 
	 end if; 
 
	 when '0' => 
	 if WSCnt=0 then 
      CLKEN_Int <= '1';	 	 
	 else  
	  WSCnt := WSCnt-1; 
	 end if; 
	 
	when others => null; 
   end case;	 
	 
end if; 
end process;			 
 
CLKEN <= CLKEN_Int; 
 
end Beh;
