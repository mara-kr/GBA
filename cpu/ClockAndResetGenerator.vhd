--****************************************************************************************************
-- Clock and reset generator for ARM core simulation
-- Designed by Ruslan Lepetenok
-- Modified 22.12.2002
--****************************************************************************************************
library	IEEE;
use IEEE.std_logic_1164.all;

entity ClockAndResetGenerator is port (
	                                      nRESET  : out std_logic;
						                  CLK     : out std_logic
						                  );
end ClockAndResetGenerator;
architecture Beh of ClockAndResetGenerator is

constant CLK_Period : time := 5 sec;
constant nRESET_Delay : time := 1 sec;

signal nRESET_Int  : std_logic := '0';
signal CLK_Int    : std_logic := '0';

begin

nRESET_Int <= '0', '1' after nRESET_Delay;
CLK_Int <= not CLK_Int after CLK_Period/2;

nRESET <= nRESET_Int;
CLK <= CLK_Int;

end Beh;
