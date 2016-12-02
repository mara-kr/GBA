--****************************************************************************************************
-- Thumb decoder for ARM7TDMI-S processor
-- Designed by Ruslan Lepetenok
-- Modified 30.01.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ThumbDecoder is port(
                       CLK             : in  std_logic;
                       nRESET          : in  std_logic;
                       CLKEN           : in  std_logic;
					   InstForDecode   : in  std_logic_vector(31 downto 0);
					   ExpandedInst	   : out std_logic_vector(31 downto 0);
					   HalfWordAddress : in  std_logic;
					   ThumbDecoderEn  : in  std_logic;
                       StagnatePipeline: in  std_logic;
					   ThBLFP          : out std_logic;
                       ThBLSP          : out std_logic;
                       ThADR           : out std_logic
					       );
end ThumbDecoder;

architecture RTL of ThumbDecoder is
attribute mark_debug : string;

signal HalfWordForDecode : std_logic_vector(15 downto 0) := (others => '0');
attribute mark_debug of HalfWordForDecode : signal is "true";

signal DecoderOut        : std_logic_vector(31 downto 0) := (others => '0');

signal ThBLFP_Int : std_logic := '0'; -- The first part of Thumb branch with link instruction
signal ThBLSP_Int : std_logic := '0'; -- The second part of Thumb branch with link instruction
signal ThBLFP_Reg : std_logic_vector(10 downto 0) := (others => '0');
signal ThBLFP_Reg_EN : std_logic;

signal ThADR_IDC : std_logic;
signal ThADR_Int : std_logic;
-----------------------------------------------------------------
-- Instruction types

------------------------------------------------------------------

-- Constants
constant CThBLFP   : std_logic_vector(4 downto 0) := "11110";    -- First part of Thumb BL
constant CThBLSP   : std_logic_vector(4 downto 0) := "11111";    -- Second part of Thumb BL

begin

HalfWordForDecode <= InstForDecode(15 downto 0) when HalfWordAddress='0' else
					 InstForDecode(31 downto 16);

ExpandedInst <= DecoderOut when ThumbDecoderEn='1' else -- Thumb instruction
				InstForDecode;                          -- ARM instruction

ThADR_Register:process(nRESET, CLK)
begin
    if nRESET='0' then
        ThADR_Int <= '0';
    elsif CLK='1' and CLK'event then
        if (CLKEN='1' and StagnatePipeline='0') then
            ThADR_Int <= ThADR_IDC;
        end if;
    end if;
end process;

ThBL_Reg:process(nRESET, CLK)
begin
    if nRESET='0' then
        ThBLFP_Reg <= (others => '0');
    elsif CLK='1' and CLK'event then -- Maybe need CLKEN?
        if (CLKEN='1' and ThBLFP_Reg_EN='1') then
            ThBLFP_Reg <= HalfWordForDecode(10 downto 0);
        end if;
    end if;
end process;

-- Combinatorial process
-- Naming based on ARM ISA
--ThBLFP_Int <= '1' when HalfWordForDecode(15 downto 11)=CThBLFP else '0';
--ThBLSP_Int <= '1' when HalfWordForDecode(15 downto 11)=CThBLSP else '0';

ThDcdComb:process(HalfWordForDecode)
begin
    -- Move Instructions
    ThBLFP_Int <= '0';
    ThBLSP_Int <= '0';
    ThBLFP_Reg_EN <= '0';
    ThADR_IDC <= '0';
    DecoderOut(31 downto 0) <= (others => '0');
    if (HalfWordForDecode(15 downto 11)="00100") then           -- MOV1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00111011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 6)="0001110000") then    -- MOV2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00101001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 0) <= "000000000000";
    elsif (HalfWordForDecode(15 downto 8)="01000110") then      -- MOV3
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011010";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15) <= HalfWordForDecode(7);
        DecoderOut(14 downto 12) <= HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "0000" & "0000";
        DecoderOut(3) <= HalfWordForDecode(6);
        DecoderOut(2 downto 0) <= HalfWordForDecode(5 downto 3);
    -- Arithmetic Instructions
    elsif (HalfWordForDecode(15 downto 6)="0100000101") then   -- ADC
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00001011";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 9)="0001110") then      -- ADD1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00101001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 3) <= "000000000";
        DecoderOut(2 downto 0) <= HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 11)="00110") then       -- ADD2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00101001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 9)="0001100") then      -- ADD3
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00001001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 8)="01000100") then     -- ADD4
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00001000";
        DecoderOut(19) <= HalfWordForDecode(7);
        DecoderOut(18 downto 16) <= HalfWordForDecode(2 downto 0);
        DecoderOut(15) <= HalfWordForDecode(7);
        DecoderOut(14 downto 12) <= HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3) <= HalfWordForDecode(6);
        DecoderOut(2 downto 0) <= HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 11)="10100") then       -- ADD5
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00101000";
        DecoderOut(19 downto 16) <= "1111";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 8) <= "1111";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
        ThADR_IDC <= '1';
    elsif (HalfWordForDecode(15 downto 11)="10101") then       -- ADD6
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00101000";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 8) <= "1111";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 7)="101100000") then    -- ADD7
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00101000";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15 downto 12) <= "1101";
        DecoderOut(11 downto 7) <= "11110";
        DecoderOut(6 downto 0) <= HalfWordForDecode(6 downto 0);
    elsif (HalfWordForDecode(15 downto 6)="0100001011") then   -- CMN
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00010111";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= "0000";
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 11)="00101") then       -- CMP1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00110101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(15 downto 12) <= "0000";
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 6)="0100001010") then   -- CMP2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00010101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= "0000";
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 8)="01000101") then     -- CMP3
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00010101";
        DecoderOut(19) <= HalfWordForDecode(7);
        DecoderOut(18 downto 16) <= HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= "0000";
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3) <= HalfWordForDecode(6);
        DecoderOut(2 downto 0) <= HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100001101") then   -- MUL
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00000001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= "0000";
        DecoderOut(11 downto 8) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(7 downto 4) <= "1001";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100001001") then   -- NEG
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00100111";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 0) <= "000000000000";
    elsif (HalfWordForDecode(15 downto 6)="0100000110") then   -- SBC
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00001101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 9)="0001111") then      -- SUB1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00100101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 3) <= "000000000";
        DecoderOut(2 downto 0) <= HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 11)="00111") then       -- SUB2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00100101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 9)="0001101") then      -- SUB3
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00000101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 7)="101100001") then    -- SUB4
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00100100";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15 downto 12) <= "1101";
        DecoderOut(11 downto 7) <= "11110";
        DecoderOut(6 downto 0) <= HalfWordForDecode(6 downto 0);
    -- Logical Operations
    elsif (HalfWordForDecode(15 downto 6)="0100000000") then   -- AND
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00000001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100001110") then   -- BIC
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100000001") then   -- EOR
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00000011";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100001111") then   -- MVN
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011111";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100001100") then   -- ORR
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100001000") then   -- TST
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00010001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(15 downto 12) <= "0000";
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    -- Shift/Rotate Instructions
    elsif (HalfWordForDecode(15 downto 11)="00000") then       -- LSL1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 7) <= HalfWordForDecode(10 downto 6);
        DecoderOut(6 downto 4) <= "000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100000010") then   -- LSL2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(7 downto 4) <= "0001";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(2 downto 0);
    elsif (HalfWordForDecode(15 downto 11)="00001") then        -- LSR1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 7) <= HalfWordForDecode(10 downto 6);
        DecoderOut(6 downto 4) <= "010";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100000011") then   -- LSR2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(7 downto 4) <= "0011";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(2 downto 0);
    elsif (HalfWordForDecode(15 downto 11)="00010") then       -- ASR1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 7) <= HalfWordForDecode(10 downto 6);
        DecoderOut(6 downto 4) <= "100";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(5 downto 3);
    elsif (HalfWordForDecode(15 downto 6)="0100000100") then   -- ASR2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(19 downto 16) <= "0000";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(7 downto 4) <= "0101";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(2 downto 0);
    elsif (HalfWordForDecode(15 downto 6)="0100000111") then   -- ROR
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011011";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(7 downto 4) <= "0111";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(2 downto 0);
    -- Branch Instructions
    elsif (HalfWordForDecode(15 downto 12)="1101") then        -- B1
        DecoderOut(31 downto 28) <= HalfWordForDecode(11 downto 8);
        DecoderOut(27 downto 24) <= "1010";
        DecoderOut(23 downto 8) <= (23 downto 8 => HalfWordForDecode(7)); -- Sign extend
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 11)="11100") then       -- B2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 24) <= "1010";
        DecoderOut(23 downto 11) <= (23 downto 11 => HalfWordForDecode(10)); -- sign extend
        DecoderOut(10 downto 0) <= HalfWordForDecode(10 downto 0);
    elsif (HalfWordForDecode(15 downto 13)="111") then         -- BL
        if (HalfWordForDecode(12 downto 11)="10") then -- 1st Part of BL
            ThBLFP_Reg_EN <= '1'; -- NOP
            --ThBLFP <= '1';
            DecoderOut(31 downto 28) <= "1110";
            DecoderOut(27 downto 24) <= "0000";
            DecoderOut(23 downto 11) <= "0000000000000";
            DecoderOut(10 downto 0) <= "00000000000";
        else -- HalfWordForDecode(12:11)="11" - 2nd part of BL
            --ThBLSP <= '1';
            DecoderOut(31 downto 28) <= "1110";
            DecoderOut(27 downto 24) <= "1011";
            DecoderOut(23) <= ThBLFP_Reg(10);
            DecoderOut(22 downto 12) <= ThBLFP_Reg;
            DecoderOut(11 downto 1)  <=
                std_logic_vector(unsigned(HalfWordForDecode(10 downto 0)) - 1);
            DecoderOut(0) <= '0';
        end if;
    elsif (HalfWordForDecode(15 downto 7)="010001110") then    -- BX
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 24) <= "0001";
        DecoderOut(23 downto 20) <= "0010";
        DecoderOut(19 downto 16) <= "1111";
        DecoderOut(15 downto 12) <= "1111";
        DecoderOut(11 downto 8) <= "1111";
        DecoderOut(7 downto 4) <= "0001";
        DecoderOut(3) <= HalfWordForDecode(6);
        DecoderOut(2 downto 0) <= HalfWordForDecode(5 downto 3);
    -- Load
    elsif (HalfWordForDecode(15 downto 11)="11001") then       -- LDMIA
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 22) <= "100010";

        --DecoderOut(21) <= '0' when HalfWordForDecode(HalfWordForDecode(10 downto 8))='1'
        --                      else '1';
        -- Send help, I am lost
        DecoderOut(21) <= '1';
        DecoderOut(20) <= '1';
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(15 downto 8) <= "00000000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 11)="01101") then       -- LDR1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 7) <= "00000";
        DecoderOut(6 downto 2) <= HalfWordForDecode(10 downto 6);
        DecoderOut(1 downto 0) <= "00";
    elsif (HalfWordForDecode(15 downto 9)="0101100") then     -- LDR2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01111001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 11)="01001") then      -- LDR3
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011001";
        DecoderOut(19 downto 16) <= "1111";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 10) <= "00";
        DecoderOut(9 downto 2) <= HalfWordForDecode(7 downto 0);
        DecoderOut(1 downto 0) <= "00";
    elsif (HalfWordForDecode(15 downto 11)="10011") then      -- LDR4
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011001";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 10) <= "00";
        DecoderOut(9 downto 2) <= HalfWordForDecode(7 downto 0);
        DecoderOut(1 downto 0) <= "00";
    elsif (HalfWordForDecode(15 downto 11)="01111") then      -- LDRB1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 5) <= "0000000";
        DecoderOut(4 downto 0) <= HalfWordForDecode(10 downto 6);
    elsif (HalfWordForDecode(15 downto 9)="0101110") then     -- LDRB2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01111101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 11)="10001") then      -- LDRH1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011101";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 10) <= "00";
        DecoderOut(9 downto 8) <= HalfWordForDecode(10 downto 9);
        DecoderOut(7 downto 4) <= "1011";
        DecoderOut(3 downto 1) <= HalfWordForDecode(8 downto 6);
        DecoderOut(0) <= '0';
    elsif (HalfWordForDecode(15 downto 9)="0101101") then     -- LDRH2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 4) <= "1011";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 9)="0101011") then     -- LDRSB
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 4) <= "1101";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 9)="0101111") then     -- LDRSH
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011001";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 4) <= "1111";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    -- Store Instructions
    elsif (HalfWordForDecode(15 downto 11)="11000") then      --STMIA
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "10001010";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(15 downto 8) <= "00000000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 11)="01100") then      -- STR1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011000";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 7) <= "00000";
        DecoderOut(6 downto 2) <= HalfWordForDecode(10 downto 6);
        DecoderOut(1 downto 0) <= "00";
    elsif (HalfWordForDecode(15 downto 9)="0101000") then     -- STR2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01111000";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWorDForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 11)="10010") then      -- STR3
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011000";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(10 downto 8);
        DecoderOut(11 downto 10) <= "00";
        DecoderOut(9 downto 2) <= HalfWordForDecode(7 downto 0);
        DecoderOut(1 downto 0) <= "00";
    elsif (HalfWordForDecode(15 downto 11)="01110") then      -- STRB1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01011100";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 5) <= "0000000";
        DecoderOut(4 downto 0) <= HalfWordForDecode(10 downto 6);
    elsif (HalfWordForDecode(15 downto 9)="0101010") then     -- STRB2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "01111100";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 4) <= "00000000";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    elsif (HalfWordForDecode(15 downto 11)="10000") then      -- STRH1
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011100";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 10) <= "00";
        DecoderOut(9 downto 8) <= HalfWordForDecode(10 downto 9);
        DecoderOut(7 downto 4) <= "1011";
        DecoderOut(3 downto 1) <= HalfWordForDecode(8 downto 6);
        DecoderOut(0) <= '0';
    elsif (HalfWordForDecode(15 downto 9)="0101001") then     -- STRH2
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "00011000";
        DecoderOut(19 downto 16) <= '0' & HalfWordForDecode(5 downto 3);
        DecoderOut(15 downto 12) <= '0' & HalfWordForDecode(2 downto 0);
        DecoderOut(11 downto 8) <= "0000";
        DecoderOut(7 downto 4) <= "1011";
        DecoderOut(3 downto 0) <= '0' & HalfWordForDecode(8 downto 6);
    -- Other
    elsif (HalfWordForDecode(15 downto 9)="1011110") then     -- Pop
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "10001011";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15) <= HalfWordForDecode(8);
        DecoderOut(14 downto 8) <= "0000000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 9)="1011010") then     -- PUSH
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 20) <= "10010010";
        DecoderOut(19 downto 16) <= "1101";
        DecoderOut(15) <= '0';
        DecoderOut(14) <= HalfWordForDecode(8);
        DecoderOut(13 downto 8) <= "000000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    elsif (HalfWordForDecode(15 downto 8)="11011111") then    -- SWI
        DecoderOut(31 downto 28) <= "1110";
        DecoderOut(27 downto 24) <= "1111";
        DecoderOut(23 downto 8) <= "0000000000000000";
        DecoderOut(7 downto 0) <= HalfWordForDecode(7 downto 0);
    else
        DecoderOut <= (others => 'X');

    end if;
end process;

-- Outputs
ThBLFP <= ThBLFP_Int;
ThBLSP <= ThBLSP_Int;
ThADR <= ThADR_Int and ThumbDecoderEn;

end RTL;

