--**************************************************************************************************** 
-- Multiplier tester for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 12.02.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity MultiplierTesterSim is port (  
						   -- Global signals 
	                       nRESET      : in  std_logic; 
						   CLK         : in  std_logic; 
						   CLKEN       : out std_logic; 
	                       -- Data outputs 
	                       ADataOut    : out std_logic_vector(31 downto 0); -- RdHi(Rn)/Rs data path  
						   BDataOut    : out std_logic_vector(31 downto 0); -- RdLo(Rd)/Rm data path 
						   -- Control outputs 
						   LoadRsRm    : out std_logic; -- Load Rs and Rm and start 
						   LoadPS      : out std_logic; -- Load partial sum register with RHi:RLo    
						   ClearPSC    : out std_logic; -- Clear prtial sum register 
						   UnsignedMul : out std_logic; -- Unsigned multiplication 
						   ReadLH	   : out std_logic;	-- 0 - Read PS/PC low,1 - Read PS/PC high 
						   -- Control inputs 
						   MulResRdy   : in  std_logic  -- Multiplication result is ready 
						   ); 
end MultiplierTesterSim; 
 
architecture Beh of MultiplierTesterSim is 
 
begin 
	 
MultiplierTestBench:process 
 
-- Beginning of procedures 
 
procedure RESET is 
begin 
CLKEN <= '1'; 
ADataOut <= (others => 'X'); 
BDataOut <= (others => 'X'); 
LoadRsRm <= '0'; 
LoadPS <= '0'; 
ClearPSC <= '0'; 
UnsignedMul <= '0'; 
ReadLH <= '0'; 
wait until nRESET='1';	 
end RESET; 
 
procedure END_SIM is 
begin 
report "Simulation completed" severity WARNING; 
wait;	 
end END_SIM; 
 
 
-- MUL 
procedure MUL(Rm : std_logic_vector(BDataOut'range);Rs : std_logic_vector(ADataOut'range)) is 
begin 
wait until CLK='1' and CLK'event; 
-- Registers loading 
ADataOut<=Rs; 
BDataOut<=Rm; 
LoadRsRm <='1';    
UnsignedMul <= '0'; 
ReadLH <= '0'; 
wait until CLK='1' and CLK'event; 
LoadRsRm <='0';    
 wait until MulResRdy='1'; 
  ClearPSC <='1'; 
wait until CLK='1' and CLK'event and MulResRdy='1'; 
ClearPSC <='0'; 
end MUL; 
 
-- MLA 
procedure MLA(Rm : std_logic_vector(BDataOut'range);Rs : std_logic_vector(ADataOut'range); Rn : std_logic_vector(BDataOut'range)) is 
begin 
wait until CLK='1' and CLK'event; 
-- Preload partial sum register(low) 
ADataOut <= (others => 'X'); -- (others => '0') 
BDataOut <= Rn; 
LoadPS <='1'; 
ReadLH <= '0'; 
wait until CLK='1' and CLK'event; 
-- Registers loading 
ADataOut<=Rs; 
BDataOut<=Rm; 
LoadRsRm <='1';    
LoadPS <='0'; 
UnsignedMul <= '0'; 
wait until CLK='1' and CLK'event; 
LoadRsRm <='0';    
 wait until MulResRdy='1'; 
  ClearPSC <='1'; 
wait until CLK='1' and CLK'event and MulResRdy='1'; 
ClearPSC <='0'; 
end MLA; 
 
-- UMULL 
procedure UMULL(Rm : std_logic_vector(BDataOut'range);Rs : std_logic_vector(ADataOut'range)) is 
begin 
wait until CLK='1' and CLK'event; 
-- Registers loading 
ADataOut<=Rs; 
BDataOut<=Rm; 
LoadRsRm <='1';    
UnsignedMul <= '1'; 
ReadLH <= '0'; 
wait until CLK='1' and CLK'event; 
LoadRsRm <='0';    
wait until CLK='1' and CLK'event and MulResRdy='1'; 
ClearPSC <='1'; 
ReadLH <= '1'; -- Read high part(bits 63:32) of partial sum/carry registers 
wait until CLK='1' and CLK'event; 
ClearPSC <='0'; 
ReadLH <= '0'; 
end UMULL; 
 
-- UMLAL 
procedure UMLAL(Rm : std_logic_vector(BDataOut'range);   Rs : std_logic_vector(ADataOut'range); 
                RdHi : std_logic_vector(ADataOut'range); RdLo : std_logic_vector(BDataOut'range)) is 
 
begin 
wait until CLK='1' and CLK'event; 
-- Preload partial sum register(high and low) 
ADataOut <= RdHi; 
BDataOut <= RdLo; 
LoadPS <='1';   
wait until CLK='1' and CLK'event; 
-- Registers loading 
ADataOut<=Rs; 
BDataOut<=Rm; 
LoadRsRm <='1';    
LoadPS <='0';    
UnsignedMul <= '1'; 
ReadLH <= '0'; 
wait until CLK='1' and CLK'event; 
LoadRsRm <='0';    
wait until CLK='1' and CLK'event and MulResRdy='1'; 
ClearPSC <='1'; 
ReadLH <= '1'; -- Read high part(bits 63:32) of partial sum/carry registers 
wait until CLK='1' and CLK'event; 
ClearPSC <='0'; 
ReadLH <= '0'; 
end UMLAL; 
 
-- SMULL 
procedure SMULL(Rm : std_logic_vector(BDataOut'range);Rs : std_logic_vector(ADataOut'range)) is 
begin 
wait until CLK='1' and CLK'event; 
-- Registers loading 
ADataOut<=Rs; 
BDataOut<=Rm; 
LoadRsRm <='1';    
UnsignedMul <= '0'; 
ReadLH <= '0'; 
wait until CLK='1' and CLK'event; 
LoadRsRm <='0';    
ClearPSC <='0'; 
wait until CLK='1' and CLK'event and MulResRdy='1'; 
ClearPSC <='1'; 
ReadLH <= '1'; -- Read high part(bits 63:32) of partial sum/carry registers 
wait until CLK='1' and CLK'event; 
ClearPSC <='0'; 
ReadLH <= '0'; 
end SMULL; 
 
-- SMLAL 
procedure SMLAL(Rm : std_logic_vector(BDataOut'range);   Rs : std_logic_vector(ADataOut'range); 
                RdHi : std_logic_vector(ADataOut'range); RdLo : std_logic_vector(BDataOut'range)) is				 
				 
begin 
-- Preload partial sum register(high and low) 
ADataOut <= RdHi; 
BDataOut <= RdLo; 
LoadPS <='1';   
wait until CLK='1' and CLK'event; 
-- Registers loading 
ADataOut<=Rs; 
BDataOut<=Rm; 
LoadRsRm <='1';    
LoadPS <='0';    
UnsignedMul <= '0'; 
ReadLH <= '0'; 
wait until CLK='1' and CLK'event; 
LoadRsRm <='0';    
wait until CLK='1' and CLK'event and MulResRdy='1'; 
ClearPSC <='1'; 
ReadLH <= '1'; -- Read high part(bits 63:32) of partial sum/carry registers 
wait until CLK='1' and CLK'event; 
ClearPSC <='0'; 
ReadLH <= '0'; 
end SMLAL; 
 
-- End of procedures  
 
-- Notes: 
-- For the moment -> [Rs]         propagates through A bus 
--					 [Rm]         propagates through B bus 
--					 [RdHi]       propagates through A bus (only for accumulation) 
--					 [RdLo]([Rn]) propagates through B bus (only for accumulation) 
 
begin 
 
RESET; 
 
--MLA(x"FBCD1234",x"ADFC5467",x"EABC5678"); 
--MLA(x"ADFC5467",x"FBCD1234",x"EABC5678"); -- ?? 
 
--MUL(x"80000001",x"80000001"); 
--MUL(x"FFFFFFFF",x"FFFFFFFF"); 
--MUL(x"00000001",x"00000081"); 
--MUL(x"00000081",x"00000001"); 
SMULL(x"00000001",x"00000081"); 
--UMULL(x"00000081",x"00000001"); 
-- Tested 
 
--MUL(x"7FFFFFFF",x"7FFFFFFF");   
 
--MUL(x"0000_0100",x"0000_0004");   
--MUL(x"0000_0004",x"0000_0100");   
 
--MUL(x"00000001",x"00000002");   
--MUL(x"80000000",x"80000000"); -- OK 
--MUL(x"80000001",x"80000001"); 
 
--MUL(x"12345678",x"fedcba90"); -- OK 
--MUL(x"fedcba90",x"12345678"); 
 
 
-- Signed multiplication tests 
--SMULL(x"80000001",x"80000001"); -- OK 
--SMULL(x"7FFFFFFF",x"7FFFFFFF"); -- OK 
--SMULL(x"FFFFFFFF",x"FFFFFFFF"); -- OK 
--SMULL(x"80000000",x"80000000"); -- OK 
--SMULL(x"12345678",x"fedcba90"); -- OK 
--SMULL(x"fedcba90",x"12345678"); -- OK 
--SMULL(x"00000001",x"80000000"); -- OK 
--SMULL(x"80000000",x"00000001"); -- OK 
--SMULL(x"12348765",x"cdefba90"); -- OK 
--SMULL(x"cdefba90",x"12348765"); -- OK 
 
-- Unsigned multiplication tests 
--UMULL(x"80000000",x"80000000"); -- OK 
--UMULL(x"FFFFFFFF",x"FFFFFFFF"); -- OK 
--UMULL(x"80000001",x"80000001"); -- OK 
--UMULL(x"7FFFFFFF",x"7FFFFFFF"); -- OK 
--UMULL(x"80000000",x"00000001"); -- OK 
--UMULL(x"00000001",x"80000000"); -- OK 
--UMULL(x"12345678",x"fedcba90"); -- OK 
--UMULL(x"fedcba90",x"12345678"); -- OK 
 
--SMULL(x"12345678",x"fedcba90"); -- OK 
--SMULL(x"fedcba90",x"12345678"); -- OK 
--SMULL(x"12348765",x"cdefba90"); -- OK 
--SMULL(x"cdefba90",x"12348765"); -- OK 
 
--MLA(x"00000000",x"00000000",x"00000004");	 -- OK 
--MLA(x"00000003",x"00000002",x"00000004");  -- OK 
 
--MLA(x"0000_FFFF",x"0000_FFFF",x"0001_FFFE"); -- OK 
--MUL(x"0000FFFF",x"0000FFFF"); -- OK 
 
--UMLAL(x"00000003",x"00000002",x"80000000",x"00000001"); -- OK 
--UMLAL(x"00000003",x"00000002",x"FFFF_FFFF",x"FFFF_FFFF"); -- OK 
 
--SMLAL(x"80000000",x"80000000",x"10000000",x"12345678"); 
 
END_SIM;	 
	 
end process;		 
 
end Beh;
