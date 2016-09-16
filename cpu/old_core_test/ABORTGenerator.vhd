--****************************************************************************************************
-- Behavioural model of ABORT generation for ARM core simualtion
-- Designed by Ruslan Lepetenok
-- Modified 23.01.2003
--****************************************************************************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use Work.ARMSMSSPackage.all;
use WORK.ARMPackage.all;

entity ABORTGenerator is generic(AbtMemAdr   : std_logic_vector(CAbtMemAdrWidth-1 downto 0);
								 NumberOfAbt : positive
	                            );
	              port(
		     		   -- Global control signals
        			   nRESET  : in  std_logic;
					   CLK     : in  std_logic;
					   CLKEN   : in  std_logic;
					   -- Memory request signals
					   TRANS   : in  std_logic_vector(1 downto 0);
					   -- ADDR
					   ADDR    : in  std_logic_vector(31 downto 0);
                       -- Output
					   ABORT   : out std_logic
					   );
end ABORTGenerator;

architecture Beh of ABORTGenerator is

signal ABORT_Int : std_logic := '0';

begin

ABORTGen:process(nRESET,CLK)
variable AbtOcCnt : natural := 0;
variable FirstAbt : boolean := TRUE;
begin
if nRESET='0' then                          -- Reset
 ABORT_Int <= '0';
 AbtOcCnt := 0;
 FirstAbt := TRUE;
  elsif CLK='1' and CLK'event then          -- Clock
   if CLKEN ='1' then                       -- Clock enable
   case ABORT_Int is
	when '0' =>
     if AbtMemAdr=ADDR(AbtMemAdr'range) and (TRANS=CTT_N or TRANS=CTT_S) and AbtOcCnt>0 then
      ABORT_Int <= '1';
	   report "Abort has occured" severity WARNING;
	  if FirstAbt then         -- The first abort occurence
	  AbtOcCnt := NumberOfAbt-1;
	   else
	   AbtOcCnt := AbtOcCnt-1;
	  end if;
	 end if;

	 when '1' => ABORT_Int <= '0';

	when others => null;
   end case;
   end if;
end if;
end process;

ABORT <= ABORT_Int;

end Beh;
