--****************************************************************************************************
-- Register file for ARM core
-- Designed by Ruslan Lepetenok
-- Modified 23.01.2003
--****************************************************************************************************
library	IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use WORK.ARMPackage.all;

entity RegFile is  generic(DebugMode : boolean := TRUE); -- Debug mode flag

	               port(
						-- Global control signals
	                    nRESET         : in std_logic;
						CLK            : in std_logic;
						CLKEN          : in std_logic;
						-- Data buses
						ABusOut        : out std_logic_vector(31 downto 0);
						BBusOut        : out std_logic_vector(31 downto 0);
						DataIn         : in  std_logic_vector(31 downto 0);
						-- Address an control
						ABusRdAdr      : in std_logic_vector(3 downto 0);
						BBusRdAdr      : in std_logic_vector(3 downto 0);
						WriteAdr       : in std_logic_vector(3 downto 0);
						WrEn	       : in std_logic;
						-- Program counter
						PCIn           : in  std_logic_vector(31 downto 0);
						PCOut          : out std_logic_vector(31 downto 0);
						PCWrEn         : in  std_logic; --???
						PCSrcSel       : in  std_logic;
						-- Global control
						RFMode         : in std_logic_vector(4 downto 0);
						SaveBaseReg    : in std_logic;
						RestoreBaseReg : in std_logic
						);
end RegFile;

architecture RTL of RegFile is
attribute mark_debug : string;


-- User mode registers r0-r15
type UMRegisterFileType is array(0 to 15) of std_logic_vector(31 downto 0);

signal UMRegisterFile : UMRegisterFileType := (others => x"0000_0000");

-- FIQ mode registers r8-r14
type FIQMRegisterFileType is array(8 to 14) of std_logic_vector(31 downto 0);
signal FIQMRegisterFile : FIQMRegisterFileType := (others => x"0000_0000");

-- Other modes registers r13,r14
type OMRegisterFileType is array(13 to 14) of std_logic_vector(31 downto 0);
signal SVCMRegisterFile : OMRegisterFileType := (others => x"0000_0000"); -- SVC
signal AMRegisterFile    : OMRegisterFileType := (others => x"0000_0000"); -- Abort
signal IRQMRegisterFile  : OMRegisterFileType := (others => x"0000_0000"); -- IRQ
signal UndMRegisterFile  : OMRegisterFileType := (others => x"0000_0000"); -- Undefined

alias PC : std_logic_vector(31 downto 0) is UMRegisterFile(15);
signal PCSrc : std_logic_vector(PC'range) := (others => '0');

signal ABusOutMUX : UMRegisterFileType := (others => x"0000_0000");
signal BBusOutMUX : UMRegisterFileType := (others => x"0000_0000");

--signal RegFileOut : UMRegisterFileType := (others => x"0000_0000");

signal RegFileAOut : UMRegisterFileType := (others => x"0000_0000");
signal RegFileBOut : UMRegisterFileType := (others => x"0000_0000");

-- Modes
signal UserMode  : std_logic := '0';
signal FIQMode   : std_logic := '0';
signal IRQMode   : std_logic := '0';
signal SVCMode   : std_logic := '0';
signal AbortMode : std_logic := '0';
signal UndefMode : std_logic := '0';

signal SavedBaseReg : std_logic_vector(31 downto 0);
signal RegsIn       : std_logic_vector(31 downto 0);
signal lr           : std_logic_vector(31 downto 0);
signal sp           : std_logic_vector(31 downto 0);
signal r0           : std_logic_vector(31 downto 0);
signal r1           : std_logic_vector(31 downto 0);
signal r2           : std_logic_vector(31 downto 0);
signal r3           : std_logic_vector(31 downto 0);
signal r4           : std_logic_vector(31 downto 0);
signal r5           : std_logic_vector(31 downto 0);
signal r6           : std_logic_vector(31 downto 0);
signal r7           : std_logic_vector(31 downto 0);
signal r8           : std_logic_vector(31 downto 0);
signal r9           : std_logic_vector(31 downto 0);
signal r10           : std_logic_vector(31 downto 0);
signal r11           : std_logic_vector(31 downto 0);
signal r12           : std_logic_vector(31 downto 0);


attribute mark_debug of lr : signal is "true";
attribute mark_debug of sp : signal is "true";
attribute mark_debug of r0 : signal is "true";
attribute mark_debug of r1 : signal is "true";
attribute mark_debug of r2 : signal is "true";
attribute mark_debug of r3 : signal is "true";
attribute mark_debug of r4 : signal is "true";
attribute mark_debug of r7 : signal is "true";




-- Individual write enable signals
--signal IndWrEn : std_logic_vector(15 downto 0) := (others => '0');

begin

lr <= UMRegisterFile(14);
sp <= UMRegisterFile(13);
r0 <= UMRegisterFile(0);
r1 <= UMRegisterFile(1);
r2 <= UMRegisterFile(2);
r3 <= UMRegisterFile(3);
r4 <= UMRegisterFile(4);
r5 <= UMRegisterFile(5);
r6 <= UMRegisterFile(6);
r7 <= UMRegisterFile(7);
r8 <= UMRegisterFile(8);
r9 <= UMRegisterFile(9);
r10 <= UMRegisterFile(10);
r11 <= UMRegisterFile(11);
r12 <= UMRegisterFile(12);




--IndWriteEnLogic:for i in IndWrEn'range generate
-- IndWrEn(i)	<= '1' when i=WriteAdr else '0';
--end generate;

-- Mode decode logic
UserMode <= '1' when RFMode=CUserMode or RFMode=CSystemMode else '0';
FIQMode  <= '1' when RFMode=CFIQMode else '0';
IRQMode  <= '1' when RFMode=CIRQMode else '0';
SVCMode  <= '1' when RFMode=CSVCMode else '0';
AbortMode <= '1' when RFMode=CAbortMode else '0';
UndefMode <= '1' when RFMode=CUndefMode else '0';


RegsIn <= SavedBaseReg when RestoreBaseReg='1' else	DataIn;


BaseRegister:process(nRESET,CLK)
begin
if nRESET='0' then                                -- Reset
 SavedBaseReg <= (others => '0');
elsif CLK='1' and CLK'event then                  -- Clock
 if SaveBaseReg='1' and CLKEN='1' then           -- Clock enable
  SavedBaseReg <= ABusOutMUX(ABusOutMUX'high);
 end if;
end if;
end process;


LowAndUMHighRegs:process(nRESET,CLK)
begin
if nRESET='0' then                                -- Reset
 if DebugMode then
  for i in UMRegisterFile'low to UMRegisterFile'high-1 loop -- was '-1'
	UMRegisterFile(i) <= (others => '0');
  end loop;
    PC <=CPCInitVal;
 end if;
elsif CLK='1' and CLK'event then                  -- Clock
 -- User Mode registers r0-r7
  for i in UMRegisterFile'low to 7 loop
   if WrEn='1' and i=WriteAdr and CLKEN='1' then  -- Clock enable
	  UMRegisterFile(i) <= RegsIn;
   end if;
  end loop;

  -- User Mode registers r8-r12(banked)
  for i in 8 to 12 loop
   if WrEn='1' and i=WriteAdr and FIQMode='0' and CLKEN='1' then -- Clock enable
	  UMRegisterFile(i) <= RegsIn;
   end if;
   end loop;

   -- User Mode registers r13-r14(banked)
  for i in 8 to UMRegisterFile'high-1 loop
   if WrEn='1' and i=WriteAdr and UserMode='1' and CLKEN='1' then -- Clock enable
	  UMRegisterFile(i) <= RegsIn;
   end if;
   end loop;

 -- Program counter (r15)
 if ((WrEn='1' and WriteAdr="1111")or PCWrEn='1')and CLKEN='1' then -- Clock enable
      PC <= PCSrc(31 downto 1) & '0';
 end if;

end if;
end process;


-- Program counter logic
PCSrc <= PCIn when PCSrcSel='0' else DataIn;
PCOut <= PC;

-- r8-r14 FIQ Mode
FIQModeHighRegs:process(nRESET,CLK)
begin
if nRESET='0' then                                                      -- Reset
 if DebugMode then
  for i in FIQMRegisterFile'range loop
	FIQMRegisterFile(i) <= (others => '0');
  end loop;
 end if;
elsif CLK='1' and CLK'event then                                         -- Clock
  for i in FIQMRegisterFile'range loop
   if WrEn='1' and i=WriteAdr and FIQMode='1' and CLKEN='1' then         -- Clock enable
	  FIQMRegisterFile(i) <= RegsIn;
   end if;
   end loop;
end if;
end process;

-- r13-r14 SVC Mode
SVCModeHighRegs:process(nRESET,CLK)
begin
if nRESET='0' then                                                       -- Reset
 if DebugMode then
  for i in SVCMRegisterFile'range loop
	SVCMRegisterFile(i) <= (others => '0');
  end loop;
 end if;
elsif CLK='1' and CLK'event then                                         -- Clock
  for i in 13 to SVCMRegisterFile'high loop
   if WrEn='1' and i=WriteAdr and SVCMode='1' and CLKEN='1' then         -- Clock enable
	  SVCMRegisterFile(i) <= RegsIn;
   end if;
   end loop;
end if;
end process;


-- r13-r14 Abort Mode
AbortModeHighRegs:process(nRESET,CLK)
begin
if nRESET='0' then                                                 -- Reset
 if DebugMode then
  for i in AMRegisterFile'range loop
	AMRegisterFile(i) <= (others => '0');
  end loop;
 end if;
elsif CLK='1' and CLK'event then                                   -- Clock
  for i in AMRegisterFile'range loop
   if WrEn='1' and i=WriteAdr and AbortMode='1' and CLKEN='1' then -- Clock enable
	  AMRegisterFile(i) <= RegsIn;
   end if;
   end loop;
end if;
end process;

-- r13-r14 IRQ Mode
IRQModeHighRegs:process(nRESET,CLK)
begin
if nRESET='0' then                                                -- Reset
 if DebugMode then
  for i in IRQMRegisterFile'range loop
	IRQMRegisterFile(i) <= (others => '0');
  end loop;
 end if;
elsif CLK='1' and CLK'event then                                  -- Clock
  for i in IRQMRegisterFile'range loop
   if WrEn='1' and i=WriteAdr and IRQMode='1' and CLKEN='1' then  -- Clock enable
	  IRQMRegisterFile(i) <= RegsIn;
   end if;
   end loop;
end if;
end process;

-- r13-r14 Undefined Mode
UndefModeHighRegs:process(nRESET,CLK)
begin
if nRESET='0' then                                                 -- Reset
 if DebugMode then
  for i in UndMRegisterFile'range loop
	UndMRegisterFile(i) <= (others => '0');
  end loop;
 end if;
elsif CLK='1' and CLK'event then                                   -- Clock
  for i in UndMRegisterFile'range loop
   if WrEn='1' and i=WriteAdr and UndefMode='1' and CLKEN='1' then -- Clock enable
	  UndMRegisterFile(i) <= RegsIn;
   end if;
   end loop;
end if;
end process;

-- Output multiplexers

-- Non banked registers (R0-R7)
RegistersOutputsLow:for i in UMRegisterFile'low to 7 generate
 RegFileAOut(i)	<= 	UMRegisterFile(i);
 RegFileBOut(i)	<= 	UMRegisterFile(i);
end generate;

-- R8-R12
RegistersOutputs:for i in 8 to 12 generate
 RegFileAOut(i)	<= UMRegisterFile(i) when FIQMode='0' else
                   FIQMRegisterFile(i);

 RegFileBOut(i)	<= UMRegisterFile(i) when FIQMode='0' else
                   FIQMRegisterFile(i);
end generate;

-- R13-R14
RegistersOutputsHigh:for i in 13 to 14 generate
RegFileAOut(i)	<= UMRegisterFile(i)   when UserMode='1'  else
                   FIQMRegisterFile(i) when	FIQMode='1'   else
				   SVCMRegisterFile(i) when SVCMode='1'	  else
 				   AMRegisterFile(i)   when AbortMode='1' else
				   IRQMRegisterFile(i) when IRQMode='1'	  else
                   UndMRegisterFile(i) when UndefMode='1' else
				   (others => CDnCr);

RegFileBOut(i)	<= UMRegisterFile(i)   when UserMode='1'  else
                   FIQMRegisterFile(i) when	FIQMode='1'   else
				   SVCMRegisterFile(i) when SVCMode='1'	  else
 				   AMRegisterFile(i)   when AbortMode='1' else
				   IRQMRegisterFile(i) when IRQMode='1'	  else
                   UndMRegisterFile(i) when UndefMode='1' else
				   (others => CDnCr);
end generate;

--R15
RegFileAOut(RegFileAOut'high) <= PC;
RegFileBOut(RegFileBOut'high) <= PC;

ABusOutMUX(ABusOutMUX'low) <= RegFileAOut(RegFileAOut'low);
BBusOutMUX(BBusOutMUX'low) <= RegFileBOut(RegFileBOut'low);
OutputDataMUX:for i in 1 to RegFileAOut'high generate
 ABusOutMUX(i) <= RegFileAOut(i) when i=ABusRdAdr else ABusOutMUX(i-1);
  BBusOutMUX(i) <= RegFileBOut(i) when i=BBusRdAdr else BBusOutMUX(i-1);
end generate;

ABusOut <= ABusOutMUX(ABusOutMUX'high);
BBusOut <= BBusOutMUX(BBusOutMUX'high);


end RTL;
