--**************************************************************************************************** 
-- ALU tester for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 23.01.2003 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity ALUTesterSim is port ( 
	                    nRESET     : in std_logic; 
						CLK        : in std_logic; 
						 
						ADataOut   : out  std_logic_vector(31 downto 0);  
						BDataOut   : out  std_logic_vector(31 downto 0);  
						InvA	   : out  std_logic; 
						InvB	   : out  std_logic; 
						PassA	   : out  std_logic; 
						PassB	   : out  std_logic;	-- MOV/MVN operations 
						-- Logic operations 
						AND_Op	   : out  std_logic; 
						ORR_Op	   : out  std_logic; 
						EOR_Op	   : out  std_logic; 
						-- Tester flag outputs						 
						CFlagOut   : out  std_logic; 
						CFlagUse   : out  std_logic  -- ADC/SBC/RSC instructions 
						     ); 
end ALUTesterSim; 
 
architecture BEH of ALUTesterSim is 
 
begin 
	 
TestBench:process 
-- Beginning of procedures 
 
procedure RESET is 
begin 
wait until nRESET='1';	 
end RESET; 
 
procedure END_SIM is 
begin 
report "Simulation completed" severity WARNING; 
wait;	 
end END_SIM; 
 
 
 
-- ADD 
procedure ADD(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end ADD; 
 
-- ADC 
procedure ADC(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= CFlag; 
CFlagUse <=	'1'; 
end ADC; 
 
-- SUB 
procedure SUB(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'1'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end SUB; 
 
-- SBC 
procedure SBC(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'1'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= CFlag; 
CFlagUse <=	'1'; 
end SBC; 
 
-- RSB 
procedure RSB(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '1'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end RSB; 
 
-- RSC 
procedure RSC(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '1'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= CFlag; 
CFlagUse <=	'1'; 
end RSC; 
 
-- CMP 
procedure CMP(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'1'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end CMP; 
 
-- CMN 
procedure CMN(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end CMN; 
 
-- !!!!!!!!!!!!!!!!!! 
 
--TST 
procedure TST(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '1'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut <= 'X'; 
CFlagUse <=	'0'; 
end TST; 
 
--TEQ 
procedure TEQ(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '1'; 
CFlagOut <= 'X'; 
CFlagUse <=	'0'; 
end TEQ; 
 
 
--ANDD 
procedure ANDD(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '1'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end ANDD; 
 
--EOR 
procedure EOR(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '1'; 
CFlagOut <= 'X'; 
CFlagUse <=	'0'; 
end EOR; 
 
--ORR 
procedure ORR(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '0'; 
ORR_Op <= '1'; 
EOR_Op <= '0'; 
CFlagOut <= 'X'; 
CFlagUse <=	'0'; 
end ORR; 
 
--BIC 
procedure BIC(Rn : std_logic_vector(ADataOut'range) := (others => '0'); Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	Rn; 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'1'; 
PassA <= '0'; 
PassB <= '0'; 
AND_Op <= '1'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut <= 'X'; 
CFlagUse <=	'0'; 
end BIC; 
 
--MOV 
procedure MOV(Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	(others => 'X'); 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'0'; 
PassA <= '0'; 
PassB <= '1'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut	<= 'X'; 
CFlagUse <=	'0'; 
end MOV; 
 
--MVN 
procedure MVN(Op2 : std_logic_vector(BDataOut'range) := (others => '0')) is 
begin 
wait until CLK='1' and CLK'event; 
ADataOut <=	(others => 'X'); 
BDataOut <= Op2; 
InvA <= '0'; 
InvB <=	'1'; 
PassA <= '0'; 
PassB <= '1'; 
AND_Op <= '0'; 
ORR_Op <= '0'; 
EOR_Op <= '0'; 
CFlagOut <= 'X'; 
CFlagUse <=	'0'; 
end MVN; 
 
-- End of procedures  
 
begin 
 
RESET; 
 
--ADD(x"F000_0000",x"F000_0000"); 
SUB(x"0000_0003",x"0000_0001"); 
RSB(x"0000_0001",x"0000_0003"); 
 
END_SIM;	 
	 
end process;	 
 
 
 
 
	 
	 
	 
end BEH; 
