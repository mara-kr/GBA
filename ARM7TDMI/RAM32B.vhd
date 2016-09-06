-**************************************************************************************************** 
-- 32-bit RAM(behavioural) for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 01.01.2003 
--**************************************************************************************************** 
 
library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use Work.ARMSMSSPackage.all; 
 
entity RAM32B is generic(RAMSize : positive := 128); 
	              port( 
		     		   -- Global control signals 
        			   CLK       : in  std_logic; 
					   CLKEN     : in  std_logic; 
  	                   -- Address and data 
					   Address   : in  std_logic_vector(LOG2(RAMSize/4)-1 downto 0); 
                       RAMSel	 : in  std_logic; 
					   ByteWE	 : in  std_logic_vector(3 downto 0); 
		               DataIn    : in  std_logic_vector(31 downto 0); 
		               DataOut   : out std_logic_vector(31 downto 0) 
					   ); 
end RAM32B; 
 
architecture Beh of RAM32B is 
type RAM32BFileType is array(0 to RAMSize/4-1) of std_logic_vector(DataIn'range); 
signal RAM32BFile : RAM32BFileType := (others => x"00000000");  
 
begin 
 
DataWrite:process(CLK) 
begin 
if CLK='1' and CLK'event then            -- Clock 
 if CLKEN='1' then                       -- Clock enable  
  for i in ByteWE'range loop 
	 if ByteWE(i)='1' and RAMSel='1' then   
	  RAM32BFile(CONV_INTEGER(Address))((i+1)*8-1 downto i*8) <= DataIn((i+1)*8-1 downto i*8);	 
   	 end if; 
	end loop; 
  end if; 
end if; 
end process;	 
 
DataOut <= RAM32BFile(CONV_INTEGER(Address)); 
 
end Beh; 
