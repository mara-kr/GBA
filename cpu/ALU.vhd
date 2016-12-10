--****************************************************************************************************
-- ALU for ARM core
-- Designed by Ruslan Lepetenok
-- Modified 16.12.2002
--****************************************************************************************************
library	IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ALU is port (
	                    ADataIn    : in  std_logic_vector(31 downto 0);
						BDataIn    : in  std_logic_vector(31 downto 0);
						DataOut    : out std_logic_vector(31 downto 0);
						InvA	   : in  std_logic;
						InvB	   : in  std_logic;
						PassA	   : in  std_logic;
						PassB	   : in  std_logic;	-- MOV/MVN operations
						-- Logic operations
						AND_Op	   : in  std_logic;
						ORR_Op	   : in  std_logic;
						EOR_Op	   : in  std_logic;
						-- Flag inputs
						CFlagIn	   : in  std_logic;
						CFlagUse   : in  std_logic; -- ADC/SBC/RSC instructions
                        ThADR      : in  std_logic; -- THUMB ADD(5) correction
						-- Flag outputs
						CFlagOut    : out  std_logic;
						VFlagOut    : out  std_logic;
						NFlagOut    : out  std_logic;
						ZFlagOut    : out  std_logic
				    );
end ALU;

architecture RTL of ALU is

signal AThFix  : std_logic_vector(31 downto 0) := (others => '0');
signal AXOROut : std_logic_vector(31 downto 0) := (others => '0');
signal BXOROut : std_logic_vector(31 downto 0) := (others => '0');

signal Adder : std_logic_vector(31 downto 0) := (others => '0');
signal Carry : std_logic_vector(31 downto 0) := (others => '0');

signal LUOut : std_logic_vector(31 downto 0) := (others => '0');

signal ALUResult : std_logic_vector(31 downto 0) := (others => '0');

signal nL_A      : std_logic := '0'; -- '0' -> Logic op./'1' -> Arith. op.

begin

-- Instruction type detecter
nL_A <= not(AND_Op or ORR_Op or EOR_Op);

-- A-Bus (R15) THUMB ADR correction
AThFix <= ADataIn AND X"FFFFFFFC" when ThADR='1' else ADataIn;

-- A-bus XOR gate (inverter)
AXOROut <= not AThFix when InvA='1' else AThFix;

-- B-bus XOR gate (inverter)
BXOROut <= not BDataIn when InvB='1' else BDataIn;

-- Adder
Adder(Adder'low) <= AXOROut(AXOROut'low) xor BXOROut(BXOROut'low) xor ((CFlagIn and CFlagUse)xor(InvA or InvB));
Carry(Carry'low) <= (AXOROut(AXOROut'low) and BXOROut(BXOROut'low))or
				    ((AXOROut(AXOROut'low) or BXOROut(BXOROut'low))and((CFlagIn and CFlagUse)xor(InvA or InvB)));
AdderLogic:for i in 1 to Adder'high generate
 Adder(i) <= AXOROut(i) xor BXOROut(i) xor Carry(i-1);
  Carry(i) <= (AXOROut(i) and BXOROut(i))or((AXOROut(i) or BXOROut(i))and Carry(i-1));
end generate;

-- Logic unit output multiplexer
LogicUnitOutMUX:for i in LUOut'range generate
LUOut(i) <= (AXOROut(i) and BXOROut(i) and AND_Op)or  -- AND
		    ((AXOROut(i) or BXOROut(i)) and ORR_Op)or -- ORR
            ((AXOROut(i) xor BXOROut(i)) and EOR_Op); -- EOR
end generate;

ZFlagOut <= '1' when ALUResult=x"0000_0000" else '0';
NFlagOut <= ALUResult(ALUResult'high);
CFlagOut <= Carry(Carry'high) when nL_A='1' and PassB='0' else
			CFlagIn;

VFlagOut <= (AXOROut(AXOROut'high) and BXOROut(BXOROut'high) and not Adder(Adder'high))or
            (not AXOROut(AXOROut'high) and not BXOROut(BXOROut'high) and Adder(Adder'high));
			 -- ADD/ADC/CMN,SUB/SBC/RSB/RSC/CMP

ALUResultMUX:for i in ALUResult'range generate
ALUResult(i) <= (ADataIn(i) and PassA)or
                (BXOROut(i) and PassB)or -- MOV/MVN
				(Adder(i) and nL_A and not(PassA or PassB))or 	 -- ADD/ADC,SUB/SBC,RSB/RSC,(CMP/CMN)
				(LUOut(i) and not nL_A and not(PassA or PassB)); -- AND/EOR/ORR,BIC,(TST/TEQ)
end generate;

DataOut <= ALUResult;


end RTL;
