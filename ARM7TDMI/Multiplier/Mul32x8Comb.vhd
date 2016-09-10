--**************************************************************************************************** 
-- 32x8 Combinatorial Multiplier for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 12.02.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity Mul32x8Comb is port (  
							 RmIn            : in  std_logic_vector(31 downto 0); 
	                         Rs9In           : in  std_logic_vector(8 downto 0); 
							 PartialSumIn    : in  std_logic_vector(63 downto 0);   
							 PartialCarryIn  : in  std_logic_vector(63 downto 0);   
							 PartialSumOut   : out std_logic_vector(63 downto 0);  
							 PartialCarryOut : out std_logic_vector(63 downto 0);  
							 UMul            : in  std_logic;     
	                         PP4P            : in  std_logic; 
		                     PP4M            : in  std_logic 
	                         ); 
end Mul32x8Comb; 
 
architecture RTL of Mul32x8Comb is 
 
-- Booth decoder signals 
signal ShiftPPLeft : std_logic_vector(3 downto 0) := (others => '0');  
signal NegPP       : std_logic_vector(3 downto 0) := (others => '0');  
signal ClrPP       : std_logic_vector(3 downto 0) := (others => '0');  
 
type PartialProductType is array(4 downto 0) of std_logic_vector(63 downto 0);  
signal PartialProduct : PartialProductType := (others => x"0000000000000000");  
 
signal PX  : std_logic_vector(RmIn'high+1 downto 0) := (others => '0'); -- +X 
signal MX  : std_logic_vector(RmIn'high+1 downto 0) := (others => '0');	-- -X 
 
-- Carry save adders (CSA) signals 
type CSAType is array (4 downto 0) of std_logic_vector(63 downto 0); 
signal CSA_AIn      : CSAType := (others => x"0000000000000000");  
signal CSA_BIn      : CSAType := (others => x"0000000000000000");  
signal CSA_CarryIn  : CSAType := (others => x"0000000000000000");  
signal CSA_SumOut   : CSAType := (others => x"0000000000000000");  
signal CSA_CarryOut : CSAType := (others => x"0000000000000000");  
 
-- Added for the purpose of test only 
signal SumTest : std_logic_vector(63 downto 0) := (others => '0'); 
	 
begin 
 
BoothDecoder:for i in ShiftPPLeft'range generate 
ShiftPPLeft(i) <= '1' when Rs9In(i*2+2 downto i*2)="011" or Rs9In(i*2+2 downto i*2)="100" else '0'; -- 2X 
NegPP(i) <= '1' when Rs9In(i*2+2)='1' else '0'; -- -X/-2X 
ClrPP(i) <= '1' when Rs9In(i*2+2 downto i*2)="000" or Rs9In(i*2+2 downto i*2)="111" else '0';	-- Clear must have higher priority than	Neg	 
end generate;	 
 
PX <= RmIn(RmIn'high)&RmIn when UMul='0' else  -- For the signed multiplication 
	  '0'&RmIn;     						   -- For the unsigned multiplication 
 
MX <= not(RmIn(RmIn'high)&RmIn) + 1 when UMul='0' else  -- For the signed multiplication 
	  not('0'&RmIn)+1;                                  -- For the unsigned multiplication 
 
PartialProduct(0) <= (others => '0') when ClrPP(0)='1' else		                                    -- +/-0 
	                 (63 downto 33 => PX(PX'high))&PX when ShiftPPLeft(0)='0' and NegPP(0)='0' else -- +X 
				     (63 downto 33 => MX(MX'high))&MX when ShiftPPLeft(0)='0' and NegPP(0)='1' else -- -X 
					 (63 downto 34 => PX(PX'high))&PX&'0' when ShiftPPLeft(0)='1' and NegPP(0)='0' else -- +2X 
				     (63 downto 34 => MX(MX'high))&MX&'0' when ShiftPPLeft(0)='1' and NegPP(0)='1' else -- -2X 
					 (others => CDnCr); 
 
PartialProduct(1) <= (others => '0') when ClrPP(1)='1' else		                                    -- +/-0 
	                 (63 downto 35 => PX(PX'high))&PX&"00" when ShiftPPLeft(1)='0' and NegPP(1)='0' else -- +X 
				     (63 downto 35 => MX(MX'high))&MX&"00" when ShiftPPLeft(1)='0' and NegPP(1)='1' else -- -X 
					 (63 downto 36 => PX(PX'high))&PX&"000" when ShiftPPLeft(1)='1' and NegPP(1)='0' else -- +2X 
				     (63 downto 36 => MX(MX'high))&MX&"000" when ShiftPPLeft(1)='1' and NegPP(1)='1' else -- -2X 
					 (others => CDnCr);					  
					  
PartialProduct(2) <= (others => '0') when ClrPP(2)='1' else		                                    -- +/-0 
	                 (63 downto 37 => PX(PX'high))&PX&"0000" when ShiftPPLeft(2)='0' and NegPP(2)='0' else -- +X 
				     (63 downto 37 => MX(MX'high))&MX&"0000" when ShiftPPLeft(2)='0' and NegPP(2)='1' else -- -X 
					 (63 downto 38 => PX(PX'high))&PX&"00000" when ShiftPPLeft(2)='1' and NegPP(2)='0' else -- +2X 
				     (63 downto 38 => MX(MX'high))&MX&"00000" when ShiftPPLeft(2)='1' and NegPP(2)='1' else -- -2X 
					 (others => CDnCr); 
 
PartialProduct(3) <= (others => '0') when ClrPP(3)='1' else		                                    -- +/-0 
	                 (63 downto 39 => PX(PX'high))&PX&"000000" when ShiftPPLeft(3)='0' and NegPP(3)='0' else -- +X 
	                 (63 downto 39 => MX(MX'high))&MX&"000000" when ShiftPPLeft(3)='0' and NegPP(3)='1' else -- -X 
	                 (63 downto 40 => PX(PX'high))&PX&"0000000" when ShiftPPLeft(3)='1' and NegPP(3)='0' else -- +2X 
	                 (63 downto 40 => MX(MX'high))&MX&"0000000" when ShiftPPLeft(3)='1' and NegPP(3)='1' else -- -2X 
					 (others => CDnCr);					  
 
PartialProduct(4) <= (63 downto 41 => PX(PX'high))&PX&"00000000" when PP4P='1' else	-- Last cycle of the unsigned multiplication or ??? +X 
	                 (63 downto 41 => MX(MX'high))&MX&"00000000" when PP4M='1' else -- -X     
	                 (others => '0');					 																 
					  
-- Carry save adders 
 
-- CSA stage 0 
CSA_AIn(0) <= PartialProduct(0); 
CSA_BIn(0) <= PartialSumIn; 
CSA_CarryIn(0) <= PartialCarryIn(62 downto 0)&'0'; 
 
-- CSA stages 1 to 4(?)  
CSA_Connection:for i in 1 to 4 generate  
CSA_AIn(i) <= PartialProduct(i); 
CSA_BIn(i) <= CSA_SumOut(i-1); 
CSA_CarryIn(i) <= CSA_CarryOut(i-1)(62 downto 0)&'0'; 
end generate;	 
 
CarrySaveAdders:for i in CSAType'range generate 
 CSA_SumOut(i)  <= CSA_AIn(i) xor CSA_BIn(i) xor CSA_CarryIn(i); 
 CSA_CarryOut(i) <= (CSA_AIn(i) and CSA_BIn(i)) or ((CSA_AIn(i) or CSA_BIn(i)) and CSA_CarryIn(i)); 
end generate;	 
 
PartialSumOut <= CSA_SumOut(CSAType'high);  
PartialCarryOut <= CSA_CarryOut(CSAType'high); 
 
-- Added for the purpose of test only 
SumTest <= CSA_SumOut(CSAType'high) + (CSA_CarryOut(CSAType'high)(62 downto 0)&'0'); 
 
end RTL; 
