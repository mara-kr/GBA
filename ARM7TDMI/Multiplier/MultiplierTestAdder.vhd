--**************************************************************************************************** 
-- Adder for multiplier tester for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 27.01.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity MultiplierTestAdder is port( 
						   -- Global signals 
	                       nRESET      : in  std_logic; 
						   CLK         : in  std_logic; 
						   CLKEN       : in std_logic; 
	                       -- Data inputs 
	                       ADataIn     : in std_logic_vector(31 downto 0); 
						   BDataIn     : in std_logic_vector(31 downto 0); 
						   -- Control inputs 
						   ReadLH      : in  std_logic; 
						   MulResRdy   : in  std_logic 
						   ); 
end MultiplierTestAdder; 
 
architecture Beh of MultiplierTestAdder is 
 
signal PartialSumTmp    : std_logic_vector(63 downto 0) := (others => '0'); 
signal PartialCarryTmp  : std_logic_vector(63 downto 0) := (others => '0'); 
signal TestAdder        : std_logic_vector(63 downto 0) := (others => '0'); 
signal TestAdderCarry   : std_logic_vector(63 downto 0) := (others => '0'); 
 
begin 
 
LoadLow:process(nRESET,CLK) 
begin 
if nRESET='0' then                   -- Reset	 
  PartialSumTmp(31 downto 0) <= (others => '0'); 
  PartialCarryTmp(31 downto 0) <= (others => '0');   
elsif CLK='1' and  CLK'event then  -- Clock 
 if CLKEN='1' and MulResRdy='1' and ReadLH='0'  then   -- Clock enable  
  PartialSumTmp(31 downto 0) <= ADataIn; 
  PartialCarryTmp(31 downto 0) <= BDataIn; 
 end if;   
end if;   
end process;	 
 
LoadHigh:process(nRESET,CLK) 
begin 
if nRESET='0' then                   -- Reset	 
  PartialSumTmp(63 downto 32) <= (others => '0'); 
  PartialCarryTmp(63 downto 32) <= (others => '0');   
elsif CLK='1' and  CLK'event then  -- Clock 
 if  CLKEN='1' and MulResRdy='1' and ReadLH='1' then   -- Clock enable  
  PartialSumTmp(63 downto 32) <= ADataIn; 
  PartialCarryTmp(63 downto 32) <= BDataIn; 
 end if;   
end if;   
end process;	 
 
-- New adder for test(Now partial carry is shifted left inside multiplier) 
TestAdder(0) <= PartialSumTmp(0) xor PartialCarryTmp(0); 
TestAdderCarry(0) <= PartialSumTmp(0) and PartialCarryTmp(0); 
AdderForTest:for i in 1 to TestAdder'high generate 
TestAdder(i) <= PartialSumTmp(i) xor PartialCarryTmp(i) xor TestAdderCarry(i-1);	 
TestAdderCarry(i) <= (PartialSumTmp(i) and PartialCarryTmp(i))or 
                     ((PartialSumTmp(i) or PartialCarryTmp(i) ) and TestAdderCarry(i-1)); 
end generate;		 
 
end Beh; 
