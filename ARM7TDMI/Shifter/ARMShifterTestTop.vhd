--**************************************************************************************************** 
-- Shifter tester top entity for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 07.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity ARMShifterTestTop is 
end ARMShifterTestTop; 
 
architecture Struct of ARMShifterTestTop is 
 
component ClockAndResetGenerator is port ( 
	                                      nRESET  : out std_logic; 
						                  CLK     : out std_logic 
						                  ); 
end component;							 
 
component ShifterTesterSim is port ( 
	                    nRESET    : in std_logic; 
						CLK      : in std_logic; 
						 
						BBusOut   : out std_logic_vector(31 downto 0); -- B-bus 
						CFlagOut  : out std_logic; 
						ShLenRs   : out  std_logic_vector(7 downto 0);  -- Shift amount for register shift (value of Rs[7..0])  
						ShLenImm  : out  std_logic_vector(4 downto 0);  -- Shift amount for immediate shift (bits [11..7]) 
						ShType    : out  std_logic_vector(2 downto 0);  -- Shift type (bits 6,5 and 4 of instruction) 
						ShRotImm  : out  std_logic;                     -- Rotate immediate 8-bit value 
						ShEn      : out  std_logic; 
						ShCFlagEn : out  std_logic 
						); 
end component; 
 
component Shifter is port ( 
	                    ShBBusIn   : in  std_logic_vector(31 downto 0); -- Input data (B-Bus) 
						ShOut      : out std_logic_vector(31 downto 0);	-- Output data 
	                    ShCFlagIn  : in  std_logic;                     -- Input of the carry flag  
						ShCFlagOut : out std_logic;                     -- Output of the carry flag  
						ShLenRs    : in  std_logic_vector(7 downto 0);  -- Shift amount for register shift (value of Rs[7..0])  
						ShLenImm   : in  std_logic_vector(4 downto 0);  -- Shift amount for immediate shift (bits [11..7]) 
						ShType     : in  std_logic_vector(2 downto 0);  -- Shift type (bits 6,5 and 4 of instruction) 
						ShRotImm   : in  std_logic;                     -- Rotate immediate 8-bit value 
						ShEn       : in  std_logic; 
						ShCFlagEn  : in  std_logic 
						); 
end component; 
 
-- Signal declarations 
signal nRESET    : std_logic := '0'; 
signal CLK      : std_logic := '0'; 
signal BBus      : std_logic_vector(31 downto 0) := (others => '0'); 
signal CFlag     : std_logic := '0'; 
signal LenRs     : std_logic_vector(7 downto 0) := (others => '0'); 
signal LenImm    : std_logic_vector(4 downto 0) := (others => '0'); 
signal ShiftType : std_logic_vector(2 downto 0) := (others => '0');  
signal ShRotImm  : std_logic := '0'; 
signal ShEn      : std_logic := '0'; 
signal ShCFlagEn : std_logic := '0'; 
 
begin 
 
CLK_And_nRESET:component ClockAndResetGenerator port map ( 
	                                      nRESET  => nRESET, 
						                  CLK    => CLK 
						                  ); 
 
Tester:component ShifterTesterSim port map( 
	                    nRESET   => nRESET, 
						CLK     => CLK, 
						 
						BBusOut   => BBus, 
						CFlagOut  => CFlag, 
						ShLenRs   => LenRs, 
						ShLenImm  => LenImm, 
						ShType    => ShiftType, 
						ShRotImm  => ShRotImm, 
						ShEn      => ShEn, 
						ShCFlagEn => ShCFlagEn 
						); 
 
ShifterUnderTest:component Shifter port map( 
	                    ShBBusIn   => BBus, 
						ShOut      => open, 
	                    ShCFlagIn  => CFlag, 
						ShCFlagOut => open, 
						ShLenRs    => LenRs, 
						ShLenImm   => LenImm, 
						ShType     => ShiftType, 
						ShRotImm   => ShRotImm, 
						ShEn       => ShEn, 
						ShCFlagEn  => ShCFlagEn 
						);	 
 
end Struct;
