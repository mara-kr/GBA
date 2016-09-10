--**************************************************************************************************** 
-- Shifter tester for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 27.01.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity ShifterTesterSim is port ( 
	                    nRESET  : in std_logic; 
						CLK     : in std_logic; 
						 
						BBusOut   : out std_logic_vector(31 downto 0); -- B-bus 
						CFlagOut  : out std_logic; 
						ShLenRs   : out  std_logic_vector(7 downto 0);  -- Shift amount for register shift (value of Rs[7..0])  
						ShLenImm  : out  std_logic_vector(4 downto 0);  -- Shift amount for immediate shift (bits [11..7]) 
						ShType    : out  std_logic_vector(2 downto 0);  -- Shift type (bits 6,5 and 4 of instruction) 
						ShRotImm  : out  std_logic;                     -- Rotate immediate 8-bit value 
						ShEn      : out  std_logic; 
						ShCFlagEn : out  std_logic 
						); 
end ShifterTesterSim; 
 
architecture BEH of ShifterTesterSim is 
 
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
 
procedure SHIFTER_EN is 
begin 
ShEn     <= '1'; 
end SHIFTER_EN; 
 
procedure SHIFTER_DIS is 
begin 
ShEn     <= '0'; 
end SHIFTER_DIS; 
 
procedure LSL_I(Rm : std_logic_vector(BBusOut'range) := (others => '0');shift_imm : std_logic_vector(ShLenImm'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= (others => 'X'); 
 ShLenImm <= shift_imm; 
 ShType   <= "000";	-- LSL Imm 
 ShRotImm <= '0'; 
end LSL_I; 
 
procedure LSL_R(Rm : std_logic_vector(BBusOut'range) := (others => '0'); Rs : std_logic_vector(ShLenRs'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= Rs; 
 ShLenImm <= (others => 'X'); 
 ShType   <= "001";	-- LSL Reg 
 ShRotImm <= '0'; 
end LSL_R; 
 
procedure LSR_I(Rm : std_logic_vector(BBusOut'range) := (others => '0');shift_imm : std_logic_vector(ShLenImm'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= (others => 'X'); 
 ShLenImm <= shift_imm; 
 ShType   <= "010";	-- LSR Imm 
 ShRotImm <= '0'; 
end LSR_I; 
 
procedure LSR_R(Rm : std_logic_vector(BBusOut'range) := (others => '0'); Rs : std_logic_vector(ShLenRs'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= Rs; 
 ShLenImm <= (others => 'X'); 
 ShType   <= "011";	-- LSR Reg 
 ShRotImm <= '0'; 
end LSR_R; 
 
procedure ASR_I(Rm : std_logic_vector(BBusOut'range) := (others => '0');shift_imm : std_logic_vector(ShLenImm'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= (others => 'X'); 
 ShLenImm <= shift_imm; 
 ShType   <= "100";	-- ASR Imm 
 ShRotImm <= '0'; 
end ASR_I; 
 
procedure ASR_R(Rm : std_logic_vector(BBusOut'range) := (others => '0'); Rs : std_logic_vector(ShLenRs'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= Rs; 
 ShLenImm <= (others => 'X'); 
 ShType   <= "101";	-- ASR Reg 
 ShRotImm <= '0'; 
end ASR_R; 
 
procedure ROR_I(Rm : std_logic_vector(BBusOut'range) := (others => '0');shift_imm : std_logic_vector(ShLenImm'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= (others => 'X'); 
 ShLenImm <= shift_imm; 
 ShType   <= "110";	-- ROR Imm 
 ShRotImm <= '0'; 
end ROR_I; 
 
procedure ROR_R(Rm : std_logic_vector(BBusOut'range) := (others => '0'); Rs : std_logic_vector(ShLenRs'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= Rs; 
 ShLenImm <= (others => 'X'); 
 ShType   <= "111";	-- ROR Reg 
 ShRotImm <= '0'; 
end ROR_R; 
 
procedure RRX(Rm : std_logic_vector(BBusOut'range) := (others => '0'); Rs : std_logic_vector(ShLenRs'range) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= (others => 'X'); 
 ShLenImm <= (others => '0'); 
 ShType   <= "110";	-- RRX 
 ShRotImm <= '0'; 
end RRX; 
 
procedure IMM_ROT(Rm : std_logic_vector(BBusOut'range) := (others => '0'); rotate_imm : std_logic_vector(3 downto 0) := (others => '0'); CFlag : std_logic := '0') is 
begin 
wait until CLK='1' and CLK'event; 
 BBusOut  <= Rm;  
 CFlagOut <= CFlag;  
 ShLenRs  <= (others => 'X'); 
 ShLenImm <= rotate_imm&'X'; 
 ShType   <= "XXX";	 
 ShRotImm <= '1'; 
end IMM_ROT; 
 
 
 
 
-- End of procedures  
 
begin 
 
RESET; 
SHIFTER_EN; 
 
IMM_ROT(x"0000_003F",x"E",'0'); 
IMM_ROT(x"0000_00FC",x"F",'0'); 
 
LSL_I(x"5A5A_A5A5","00000",'0'); 
 
--LSL_I(x"0000_0002","00001",'1'); 
--LSL_I(x"0000_0004","00001",'1'); 
 
END_SIM;	 
	 
end process;	 
 
 
ShCFlagEn <= '1'; 
 
	 
	 
	 
end BEH;
