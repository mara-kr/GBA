--****************************************************************************************************
-- Thumb decoder for ARM7TDMI-S processor
-- Designed by Ruslan Lepetenok
-- Modified 30.01.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;

entity ThumbDecoder is port(
					   InstForDecode   : in  std_logic_vector(31 downto 0);
					   ExpandedInst	   : out std_logic_vector(31 downto 0);
					   HalfWordAddress : in  std_logic;
					   ThumbDecoderEn  : in  std_logic;
					   ThBLFP          : out std_logic;
                       ThBLSP          : out std_logic
					       );
end ThumbDecoder;

architecture RTL of ThumbDecoder is
signal HalfWordForDecode : std_logic_vector(15 downto 0) := (others => '0');
signal DecoderOut        : std_logic_vector(31 downto 0) := (others => '0');
signal DecodedInst       : std_logic_vector(DecoderOut'range) := (others => '0');

signal ThBLFP_Int : std_logic := '0'; -- The first part of Thumb branch with link instruction
signal ThBLSP_Int : std_logic := '0'; -- The second part of Thumb branch with link instruction

-----------------------------------------------------------------
-- Instruction types
-- Naming based on ARM ISA

-- Move
signal Th_MOV1     : std_logic := '0';
signal Th_MOV2     : std_logic := '0';
signal Th_MOV3     : std_logic := '0';

-- Arithmetic
signal Th_ADC      : std_logic := '0';

signal Th_ADD1     : std_logic := '0';
signal Th_ADD2     : std_logic := '0';
signal Th_ADD3     : std_logic := '0';
signal Th_ADD4     : std_logic := '0';
signal Th_ADD5     : std_logic := '0';
signal Th_ADD6     : std_logic := '0';
signal Th_ADD7     : std_logic := '0';

signal Th_CMN      : std_logic := '0';

signal Th_CMP1     : std_logic := '0';
signal Th_CMP2     : std_logic := '0';
signal Th_CMP3     : std_logic := '0';

signal Th_MUL      : std_logic := '0';
signal Th_NEG      : std_logic := '0';
signal Th_SBC      : std_logic := '0';

signal Th_SUB1     : std_logic := '0';
signal Th_SUB2     : std_logic := '0';
signal Th_SUB3     : std_logic := '0';
signal Th_SUB4     : std_logic := '0';

-- Logical
signal Th_AND      : std_logic := '0';
signal Th_BIC      : std_logic := '0';
signal Th_EOR      : std_logic := '0';
signal Th_MVN      : std_logic := '0';
signal Th_ORR      : std_logic := '0';
signal Th_TST      : std_logic := '0';

-- Shift/Rotate
signal Th_LSL1     : std_logic := '0';
signal Th_LSL2     : std_logic := '0';

signal Th_LSR1     : std_logic := '0';
signal Th_LSR2     : std_logic := '0';

signal Th_ASR1     : std_logic := '0';
signal Th_ASR2     : std_logic := '0';

signal Th_ROR      : std_logic := '0';

-- Branch
signal Th_B1       : std_logic := '0';
signal Th_B2       : std_logic := '0';

signal Th_BL       : std_logic := '0';
signal Th_BX       : std_logic := '0';

-- Load
signal Th_LDMIA    : std_logic := '0';

signal Th_LDR1     : std_logic := '0';
signal Th_LDR2     : std_logic := '0';
signal Th_LDR3     : std_logic := '0';
signal Th_LDR4     : std_logic := '0';

signal Th_LDRB1    : std_logic := '0';
signal Th_LDRB2    : std_logic := '0';

signal Th_LDRH1    : std_logic := '0';
signal Th_LDRH2    : std_logic := '0';

signal Th_LDRSB    : std_logic := '0';
signal Th_LDRSH    : std_logic := '0';

-- Store
signal Th_STMIA    : std_logic := '0';

signal Th_STR1     : std_logic := '0';
signal Th_STR2     : std_logic := '0';
signal Th_STR3     : std_logic := '0';

signal Th_STRB1     : std_logic := '0';
signal Th_STRB2     : std_logic := '0';

signal Th_STRH1     : std_logic := '0';
signal Th_STRH2     : std_logic := '0';

-- Push/Pop
signal Th_POP       : std_logic := '0';
signal Th_PUSH      : std_logic := '0';

-- Software Interrupt
signal Th_SWI       : std_logic := '0';

------------------------------------------------------------------

-- Constants
constant CThBLFP   : std_logic_vector(4 downto 0) := "11110";    -- First part of Thumb BL
constant CThBLSP   : std_logic_vector(4 downto 0) := "11111";    -- Second part of Thumb BL
constant CBrTemp   : std_logic_vector(7 downto 0) := "11101010"; -- Branch(ARM) opcode

begin


HalfWordForDecode <= InstForDecode(15 downto 0) when HalfWordAddress='0' else
					 InstForDecode(31 downto 16);

ExpandedInst <= DecoderOut when ThumbDecoderEn='1' else -- Thumb instruction
				InstForDecode;                          -- ARM instruction

------------------------------------------------------------------
-- Decoder: Determine instruction type (only one type should be set)
-- Move
Th_MOV1 <= '1' when HalfWordForDecode(15:11)="00100" else '0';
Th_MOV2 <= '1' when HalfWordForDecode(15:6)="0001110000" else '0';
Th_MOV3 <= '1' when HalfWordForDecode(15:8)="01000110" else '0';

-- Arithmetic
Th_ADC  <= '1' when HalfWordForDecode(15:6)="0100000101" else '0';

Th_ADD1 <= '1' when HalfWordForDecode(15:9)="0001110" else '0';
Th_ADD2 <= '1' when HalfWordForDecode(15:11)="00110" else '0';
Th_ADD3 <= '1' when HalfWordForDecode(15:9)="0001100" else '0';
Th_ADD4 <= '1' when HalfWordForDecode(15:8)="01000100" else '0';
Th_ADD5 <= '1' when HalfWordForDecode(15:11)="10100" else '0';
Th_ADD6 <= '1' when HalfWordForDecode(15:11)="10101" else '0';
Th_ADD7 <= '1' when HalfWordForDecode(15:7)="101100000" else '0';

Th_CMN <=  '1' when HalfWordForDecode(15:6)="0100001011" else '0';

Th_CMP1 <= '1' when HalfWordForDecode(15:11)="00101" else '0';
Th_CMP2 <= '1' when HalfWordForDecode(15:6)="0100001010" else '0';
Th_CMP3 <= '1' when HalfWordForDecode(15:8)="01000101" else '0';

Th_MUL  <= '1' when HalfWordForDecode(15:6)="0100001101" else '0';
Th_NEG  <= '1' when HalfWordForDecode(15:6)="0100001111" else '0';
Th_SBC  <= '1' when HalfWordForDecode(15:6)="0100000110" else '0';

Th_SUB1 <= '1' when HalfWordForDecode(15:9)="0001111" else '0';
Th_SUB2 <= '1' when HalfWordForDecode(15:11)="00111" else '0';
Th_SUB3 <= '1' when HalfWordForDecode(15:9)="0001101" else '0';
Th_SUB4 <= '1' when HalfWordForDecode(15:7)="101100001" else '0';

-- Logical
Th_AND  <= '1' when HalfWordForDecode(15:6)="0100000000" else '0';
Th_BIC  <= '1' when HalfWordForDecode(15:6)="0100001110" else '0';
Th_EOR  <= '1' when HalfWordForDecode(15:6)="0100000001" else '0';
Th_MVN  <= '1' when HalfWordForDecode(15:6)="0100001111" else '0';
Th_ORR  <= '1' when HalfWordForDecode(15:6)="0100001100" else '0';
Th_TST  <= '1' when HalfWordForDecode(15:6)="0100001000" else '0';

-- Shift/Rotate
Th_LSL1 <= '1' when HalfWordForDecode(15:11)="00000" else '0';
Th_LSL2 <= '1' when HalfWordForDecode(15:6)="0100000010" else '0';

Th_LSR1 <= '1' when HalfWordForDecode(15:11)="00001" else '0';
Th_LSR2 <= '1' when HalfWordForDecode(15:6)="0100000011" else '0';

Th_ASR1 <= '1' when HalfWordForDecode(15:11)="00010" else '0';
Th_ASR2 <= '1' when HalfWordForDecode(15:6)="0100000100" else '0';

Th_ROR  <= '1' when HalfWordForDecode(15:6)="0100000111" else '0';

-- Branch
Th_B1   <= '1' when HalfWordForDecode(15:12)="1101" else '0';
Th_B2   <= '1' when HalfWordForDecode(15:11)="11100" else '0';

Th_BL   <= '1' when HalfWordForDecode(15:13)="111" else '0';
Th_BX   <= '1' when HalfWordForDecode(15:7)="010001110" else '0';

-- Load
Th_LDMIA <= '1' when HalfWordForDecode(15:11)="11001" else '0';

Th_LDR1 <= '1' when HalfWordForDecode(15:11)="01101" else '0';
Th_LDR2 <= '1' when HalfWordForDecode(15:9)="0101100" else '0';
Th_LDR3 <= '1' when HalfWordForDecode(15:11)="01001" else '0';
Th_LDR4 <= '1' when HalfWordForDecode(15:11)="10011" else '0';

Th_LDRB1 <= '1' when HalfWordForDecode(15:11)="01111" else '0';
Th_LDRB2 <= '1' when HalfWordForDecode(15:9)="0101110" else '0';

Th_LDRH1 <= '1' when HalfWordForDecode(15:11)="10001" else '0';
Th_LDRH2 <= '1' when HalfWordForDecode(15:9)="0101101" else '0';

Th_LDRSB <= '1' when HalfWordForDecode(15:9)="0101011" else '0';
Th_LDRSH <= '1' when HalfWordForDecode(15:9)="0101111" else '0';

-- Store
Th_STMIA <= '1' when HalfWordForDecode(15:11)="11000" else '0';

Th_STR1 <= '1' when HalfWordForDecode(15:11)="01100" else '0';
Th_STR2 <= '1' when HalfWordForDecode(15:9)="0101000" else '0';
Th_STR3 <= '1' when HalfWordForDecode(15:11)="10010" else '0';

Th_STRB1 <= '1' when HalfWordForDecode(15:11)="01110" else '0';
Th_STRB2 <= '1' when HalfWordForDecode(15:9)="0101010" else '0';

Th_STRH1 <= '1' when HalfWordForDecode(15:11)="10000" else '0';
Th_STRH2 <= '1' when HalfWordForDecode(15:9)="0101001" else '0';

-- Push/Pop
Th_POP   <= '1' when HalfWordForDecode(15:9)="1011110" else '0';
Th_PUSH  <= '1' when HalfWordForDecode(15:9)="1011010" else '0';

-- Software Interrupt
Th_SWI   <= '1' when HalfWordForDecode(15:8)="11011111" else '0';

------------------------------------------------------------------

-- Decoder is TBD
-- Combinatorial process
ThDcdComb:process(HalfWordForDecode)
begin
 -- Set Decode Inst based on which Th_* signals are set
    -- Move Instructions
    if (HalfWordForDecode(15:11)="00100" then           -- MOV1
        DecodedInst(31:28) <= "1110";
        DecodedInst(27:20) <= "00111011";
        DecodedInst(19:16) <= SBZ?;
        DecodedInst(15:12) <= '0' & HalfWordForDecode(10:8);
        DecodedInst(11:8) <= "0000";
        DecodedInst(7:0) <= HalfWordForDecode(7:0);
    elsif (HalfWordForDecode(15:6)="0001110000" then    -- MOV2
        DecodedInst(31:28) <= "1110";
        DecodedInst(27:20) <= "00101001";
        DecodedInst(19:16) <= '0' & HalfWordForDecode(5:3);
        DecodedInst(15:12) <= '0' & HalfWordForDecode(2:0);
        DecodedInst(11:0) <= "000000000000";
    elsif (HalfWordForDecode(15:8)="01000110" then      -- MOV3
        DecodedInst(31:28) <= "1110";
        DecodedInst(27:20) <= "00011010";
        DecodedInst(19:16) <= SBZ?;
        DecodedInst(15) <= HalfWordForDecode(7);
        DecodedInst(14:12) <= HalfWordForDecode(2:0);
        DecodedInst(11:4) <= "000000000";
        DecodedInst(3) <= HalfWordForDecode(6);
        DecodedInst(2:0) <= HalfWordForDecode(5:3);
    -- Arithmetic Instructions
    elsif (HalfWordForDecode(15:6)="0100000101") then   -- ADC
        DecodedInst(31:28) <= "1110";
        DecodedInst(27:20) <= "00001011";
        DecodedInst(19:16) <= '0' & HalfWordForDecode(2:0);
        DecodedInst(15:12) <= '0' & HalfWordForDecode(2:0);
        DecodedInst(11:4) <= "00000000";
        DecodedInst(3:0) <= '0' & HalfWordForDecode(5:3);
    elsif (HalfWordForDecode(15:9)="0001110") then      -- ADD1
        DecodedInst(31:28) <= "1110";
        DecodedInst(27:20) <= "00101001";
        DecodedInst(19:16) <= '0' & HalfWordForDecode(5:3);
        DecodedInst(15:12) <= '0' & HalfWordForDecode(2:0);
        DecodedInst(11:3) <= "000000000";
        DecodedInst(2:0) <= HalfWordForDecode(8:6);
    elsif (HalfWordForDecode(15:11)="00110") then       -- ADD2
        DecodedInst(31:28) <= "1110";
        DecodedInst(27:20) <= "00101001";
        DecodedInst(19:16) <= '0' & HalfWordForDecode(10:8);
        DecodedInst(15:12) <= '0' & HalfWordForDecode(10:8);
        DecodedInst(11:8) <= "0000";
        DecodedInst(7:0) <= HalfWordForDecode(7:0);
    elsif (HalfWordForDecode(15:9)="0001100") then      -- ADD3



    else

    end if;
    -- Arithmetic
    Th_ADD3 <= '1' when HalfWordForDecode(15:9)="0001100" else '0';
    Th_ADD4 <= '1' when HalfWordForDecode(15:8)="01000100" else '0';
    Th_ADD5 <= '1' when HalfWordForDecode(15:11)="10100" else '0';
    Th_ADD6 <= '1' when HalfWordForDecode(15:11)="10101" else '0';
    Th_ADD7 <= '1' when HalfWordForDecode(15:7)="101100000" else '0';

    Th_CMN <=  '1' when HalfWordForDecode(15:6)="0100001011" else '0';

    Th_CMP1 <= '1' when HalfWordForDecode(15:11)="00101" else '0';
    Th_CMP2 <= '1' when HalfWordForDecode(15:6)="0100001010" else '0';
    Th_CMP3 <= '1' when HalfWordForDecode(15:8)="01000101" else '0';

    Th_MUL  <= '1' when HalfWordForDecode(15:6)="0100001101" else '0';
    Th_NEG  <= '1' when HalfWordForDecode(15:6)="0100001111" else '0';
    Th_SBC  <= '1' when HalfWordForDecode(15:6)="0100000110" else '0';

    Th_SUB1 <= '1' when HalfWordForDecode(15:9)="0001111" else '0';
    Th_SUB2 <= '1' when HalfWordForDecode(15:11)="00111" else '0';
    Th_SUB3 <= '1' when HalfWordForDecode(15:9)="0001101" else '0';
    Th_SUB4 <= '1' when HalfWordForDecode(15:7)="101100001" else '0';

    -- Logical
    Th_AND  <= '1' when HalfWordForDecode(15:6)="0100000000" else '0';
    Th_BIC  <= '1' when HalfWordForDecode(15:6)="0100001110" else '0';
    Th_EOR  <= '1' when HalfWordForDecode(15:6)="0100000001" else '0';
    Th_MVN  <= '1' when HalfWordForDecode(15:6)="0100001111" else '0';
    Th_ORR  <= '1' when HalfWordForDecode(15:6)="0100001100" else '0';
    Th_TST  <= '1' when HalfWordForDecode(15:6)="0100001000" else '0';

    -- Shift/Rotate
    Th_LSL1 <= '1' when HalfWordForDecode(15:11)="00000" else '0';
    Th_LSL2 <= '1' when HalfWordForDecode(15:6)="0100000010" else '0';

    Th_LSR1 <= '1' when HalfWordForDecode(15:11)="00001" else '0';
    Th_LSR2 <= '1' when HalfWordForDecode(15:6)="0100000011" else '0';

    Th_ASR1 <= '1' when HalfWordForDecode(15:11)="00010" else '0';
    Th_ASR2 <= '1' when HalfWordForDecode(15:6)="0100000100" else '0';

    Th_ROR  <= '1' when HalfWordForDecode(15:6)="0100000111" else '0';

    -- Branch
    Th_B1   <= '1' when HalfWordForDecode(15:12)="1101" else '0';
    Th_B2   <= '1' when HalfWordForDecode(15:11)="11100" else '0';

    Th_BL   <= '1' when HalfWordForDecode(15:13)="111" else '0';
    Th_BX   <= '1' when HalfWordForDecode(15:7)="010001110" else '0';

    -- Load
    Th_LDMIA <= '1' when HalfWordForDecode(15:11)="11001" else '0';

    Th_LDR1 <= '1' when HalfWordForDecode(15:11)="01101" else '0';
    Th_LDR2 <= '1' when HalfWordForDecode(15:9)="0101100" else '0';
    Th_LDR3 <= '1' when HalfWordForDecode(15:11)="01001" else '0';
    Th_LDR4 <= '1' when HalfWordForDecode(15:11)="10011" else '0';

    Th_LDRB1 <= '1' when HalfWordForDecode(15:11)="01111" else '0';
    Th_LDRB2 <= '1' when HalfWordForDecode(15:9)="0101110" else '0';

    Th_LDRH1 <= '1' when HalfWordForDecode(15:11)="10001" else '0';
    Th_LDRH2 <= '1' when HalfWordForDecode(15:9)="0101101" else '0';

    Th_LDRSB <= '1' when HalfWordForDecode(15:9)="0101011" else '0';
    Th_LDRSH <= '1' when HalfWordForDecode(15:9)="0101111" else '0';

    -- Store
    Th_STMIA <= '1' when HalfWordForDecode(15:11)="11000" else '0';

    Th_STR1 <= '1' when HalfWordForDecode(15:11)="01100" else '0';
    Th_STR2 <= '1' when HalfWordForDecode(15:9)="0101000" else '0';
    Th_STR3 <= '1' when HalfWordForDecode(15:11)="10010" else '0';

    Th_STRB1 <= '1' when HalfWordForDecode(15:11)="01110" else '0';
    Th_STRB2 <= '1' when HalfWordForDecode(15:9)="0101010" else '0';

    Th_STRH1 <= '1' when HalfWordForDecode(15:11)="10000" else '0';
    Th_STRH2 <= '1' when HalfWordForDecode(15:9)="0101001" else '0';

    -- Push/Pop
    Th_POP   <= '1' when HalfWordForDecode(15:9)="1011110" else '0';
    Th_PUSH  <= '1' when HalfWordForDecode(15:9)="1011010" else '0';

    -- Software Interrupt
    Th_SWI   <= '1' when HalfWordForDecode(15:8)="11011111" else '0';

 DecodedInst <= (others => '0');
end process;

-- Thumb branch with link instruction decode
ThBLFP_Int <= '1' when HalfWordForDecode(15 downto 11)=CThBLFP  else '0';
ThBLSP_Int <= '1' when HalfWordForDecode(15 downto 11)=CThBLSP  else '0';

DecoderOut   <= CBrTemp&(23 downto 11 => HalfWordForDecode(10))&HalfWordForDecode(10 downto 0) -- (B-opcode) (Signed extended(offset_11)
                when (ThBLFP_Int or ThBLSP_Int)='1' else
			    DecodedInst;	-- Normal expanded instructions

-- Outputs
ThBLFP <= ThBLFP_Int;
ThBLSP <= ThBLSP_Int;

end RTL;

