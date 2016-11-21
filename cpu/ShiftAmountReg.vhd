--**************************************************************************************************** 
-- Shifter control register for ARM7TDMI-S processor 
-- Designed by Ruslan Lepetenok 
-- Modified 11.11.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity ShiftAmountReg is port( 
	                   -- Clock and reset 
				       nRESET     : in  std_logic;  
					   CLK        : in  std_logic; 
					   CLKEN      : in  std_logic;                       
					   -- Data signals 
					   ShLenRsIn  : in   std_logic_vector(7 downto 0);  -- Shift amount for register shift (value of Rs[7..0])  
					   ShLenRsOut : out  std_logic_vector(7 downto 0) 
					   ); 
end ShiftAmountReg; 
 
architecture RTL of ShiftAmountReg is 
begin 
 
ShAmRg:process(nRESET,CLK) 
begin 
if nRESET='0' then                -- Reset 
 ShLenRsOut <= (others => '0'); 
 elsif CLK='1' and CLK'event then -- Clock	 
  if CLKEN='1' then               -- Clock enable	  
    ShLenRsOut <= ShLenRsIn; 
  end if;	   
end if;	  
end process; 
	 
end RTL; 
