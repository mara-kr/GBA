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
 
-- Constants 
constant CThBLFP   : std_logic_vector(4 downto 0) := "11110";    -- First part of Thumb BL 
constant CThBLSP   : std_logic_vector(4 downto 0) := "11111";    -- Second part of Thumb BL 
constant CBrTemp   : std_logic_vector(7 downto 0) := "11101010"; -- Branch(ARM) opcode 
 
begin 
 
HalfWordForDecode <= InstForDecode(15 downto 0) when HalfWordAddress='0' else 
					 InstForDecode(31 downto 16); 
 
ExpandedInst <= DecoderOut when ThumbDecoderEn='1' else -- Thumb instruction 
				InstForDecode;                          -- ARM instruction 
				 
-- Decoder is TBD 				 
-- Combinatorial process 
ThDcdComb:process(HalfWordForDecode) 
begin 
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

