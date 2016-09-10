--**************************************************************************************************** 
-- Constants for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 30.01.2003 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
package	ARMPackage is 
 
-- ARM core modes (CPSR [4:0]) 
constant CUserMode   : std_logic_vector(4 downto 0) := "10000"; 
constant CFIQMode    : std_logic_vector(4 downto 0) := "10001"; 
constant CIRQMode    : std_logic_vector(4 downto 0) := "10010"; 
constant CSVCMode    : std_logic_vector(4 downto 0) := "10011"; 
constant CAbortMode  : std_logic_vector(4 downto 0) := "10111"; 
constant CUndefMode  : std_logic_vector(4 downto 0) := "11011"; 
constant CSystemMode : std_logic_vector(4 downto 0) := "11111";	 
 
constant CPSRInitVal : std_logic_vector(31 downto 0) := (31 downto 8 => '0')&"110"&CSVCMode; 
 
-- Exception vector adressses 
constant CExcAdrUndefined : std_logic_vector(31 downto 0) := x"0000_0004"; 
constant CExcAdrSWI       : std_logic_vector(31 downto 0) := x"0000_0008"; 
constant CExcAdrPrfAbt    : std_logic_vector(31 downto 0) := x"0000_000C"; 
constant CExcAdrDtAbt     : std_logic_vector(31 downto 0) := x"0000_0010"; 
constant CExcAdrIRQ       : std_logic_vector(31 downto 0) := x"0000_0018"; 
constant CExcAdrFIQ       : std_logic_vector(31 downto 0) := x"0000_001C"; 
 
-- Bus transaction types (TRANS[1:0]) 
constant CTT_I : std_logic_vector(1 downto 0) := "00"; -- Internal cycle  
constant CTT_C : std_logic_vector(1 downto 0) := "01"; -- Coprocessor register transfer cycle	 
constant CTT_N : std_logic_vector(1 downto 0) := "10"; -- Nonsequential cycle	 
constant CTT_S : std_logic_vector(1 downto 0) := "11"; -- Sequential cycle 
 
-- Bus transaction sizes (SIZE[1:0]) 
constant CTS_B  : std_logic_vector(1 downto 0) := "00"; -- Byte  
constant CTS_HW : std_logic_vector(1 downto 0) := "01"; -- Halfword (16 bit) 
constant CTS_W  : std_logic_vector(1 downto 0) := "10"; -- Word(32 bit)	 
 
-- TBD (depends on the address multiplexer structure) 
constant CPCInitVal  : std_logic_vector(31 downto 0) := x"0000_0000";  
 
-- Symbolic register names 
constant CR_PC  : std_logic_vector(3 downto 0) := "1111"; -- PC(R15) 
constant CR_LR  : std_logic_vector(3 downto 0) := "1110"; -- LR(R14) 
 
-- Thumb 
constant CThumbImp : boolean := TRUE; 
 
-- Don't care value 
constant CDnCr : std_logic := '0'; 
 
end; 	 
