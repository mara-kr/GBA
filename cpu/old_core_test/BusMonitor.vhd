-- *********************************************************************************************
-- Bus monitor for ARM core simulation
-- Modified 15.03.2003
-- Designed by Ruslan Lepetenok
-- *********************************************************************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

use STD.textio.all;

use WORK.ARMPackage.all;

entity BusMonitor is generic(LogFileName : string := "Log.txt");
	                 port(
								   -- Global control signals
	                               nRESET  : in  std_logic;
						           CLK     : in  std_logic;
								   CLKEN   : in  std_logic;
								   -- Address class signals
								   ADDR    : in  std_logic_vector(31 downto 0);
								   WRITE_I : in  std_logic;
								   SIZE    : in  std_logic_vector(1 downto 0);
								   PROT	   : in  std_logic_vector(1 downto 0);
								   -- Memory request signals
								   TRANS   : in  std_logic_vector(1 downto 0);
								   -- Data timed signals
								   WDATA   : in  std_logic_vector(31 downto 0);
								   RDATA   : in  std_logic_vector(31 downto 0);
								   ABORT   : in  std_logic
								   );


end BusMonitor;

architecture Beh of BusMonitor is

type TransferType is (IDLE,COPR,NONSEQ,SEQ);
type TransferSizeType is (Word,HalfWord,Byte,Reserved);
type OperationType is (ReadOp,WriteOp);
type ProtectionType is (UsrOpc,UsrData,PrivOpc,PrivData);

constant CPT_UsrOpc   : std_logic_vector(1 downto 0) := "00";
constant CPT_UsrData  : std_logic_vector(1 downto 0) := "01";
constant CPT_PrivOpc  : std_logic_vector(1 downto 0) := "10";
constant CPT_PrivData : std_logic_vector(1 downto 0) := "11";

file OutLogFile : text open write_mode is LogFileName;

type AddressClassSignalsType is record
  Address      : std_logic_vector(ADDR'range);
  Operation	   : OperationType;
  Transfer     : TransferType;
  TransferSize : TransferSizeType;
  Protection   : ProtectionType;
end record;

-- Functions
function Std_Logic_Vector_To_String(InVector : std_logic_vector) return string is
variable ResultString : string (1 to InVector'length/4) := (others => '0'); -- TBD
variable TempNibble : natural range 0 to 15 := 0;
variable TempVector : std_logic_vector(InVector'high downto 0) := (others => '0');

begin

if InVector'ascending then
 TempVector := InVector(InVector'reverse_range);
  else
   TempVector := InVector;
    end if;

Outer:for i in 1 to InVector'length/4 loop
 TempNibble := 0;
  for j in 0 to 3 loop

   exit Outer when (4*(i-1)+j) > InVector'high;

    if TempVector(4*(i-1)+j)='1' then
     TempNibble := TempNibble + 2**(j);
      end if;

end loop;

if TempNibble <= 9 then -- 0..9
 ResultString(InVector'length/4-i+1) := character'val(character'pos('0') + CONV_INTEGER(TempNibble));
  else			        -- A..F
   ResultString(InVector'length/4-i+1) := character'val(character'pos('A') + CONV_INTEGER(TempNibble) - 10);
    end if;

end loop;

return ResultString;

end Std_Logic_Vector_To_String;

begin

AddressAndControlLatch:process

variable L : line;

variable FirstCycle : boolean := TRUE;

variable CurrentAdrCtrlSgs : AddressClassSignalsType;
variable PrevAdrCtrlSgs    : AddressClassSignalsType;

variable CycleCounter : integer := 0;

constant Separator : character := ':';

begin

 wait until nRESET='1' and CLK='1' and CLK'event and CLKEN='1';

 -- Decode address class signals
  CurrentAdrCtrlSgs.Address := ADDR;

  if WRITE_I='1' then
    CurrentAdrCtrlSgs.Operation := WriteOp;
     else
          CurrentAdrCtrlSgs.Operation := ReadOp;
   end if;

   case TRANS is
	when CTT_I  => CurrentAdrCtrlSgs.Transfer := IDLE;
   	when CTT_C  => CurrentAdrCtrlSgs.Transfer := COPR;
 	when CTT_N  => CurrentAdrCtrlSgs.Transfer := NONSEQ;
	when CTT_S  => CurrentAdrCtrlSgs.Transfer := SEQ;
	when others => null;
   end case;

   case SIZE is
	when CTS_B  => CurrentAdrCtrlSgs.TransferSize := Byte;
   	when CTS_HW => CurrentAdrCtrlSgs.TransferSize := HalfWord;
	when CTS_W  => CurrentAdrCtrlSgs.TransferSize := Word;
	when "11"   => CurrentAdrCtrlSgs.TransferSize := Reserved;
				   report "Unsupported transfer size" severity ERROR;
	when others => null;
   end case;

   case PROT is
    when CPT_UsrOpc => CurrentAdrCtrlSgs.Protection := UsrOpc;
	when CPT_UsrData => CurrentAdrCtrlSgs.Protection := UsrData;
	when CPT_PrivOpc => CurrentAdrCtrlSgs.Protection := PrivOpc;
	when CPT_PrivData => CurrentAdrCtrlSgs.Protection := PrivData;
	when others => null;
   end case;

 if not FirstCycle then

 CycleCounter := CycleCounter+1;

  assert CycleCounter>0
   report"Wrong cycle counter value"
     severity FAILURE;

-- Write log file
 write(L,"Cycle cnt. = "&integer'image(CycleCounter)&Separator);

-- Address
 write(L,"0x"&Std_Logic_Vector_To_String(PrevAdrCtrlSgs.Address)&Separator);

-- Control
  write(L,OperationType'image(PrevAdrCtrlSgs.Operation)&Separator);
  write(L,TransferType'image(PrevAdrCtrlSgs.Transfer)&Separator);
  write(L,TransferSizeType'image(PrevAdrCtrlSgs.TransferSize)&Separator);
  write(L,ProtectionType'image(PrevAdrCtrlSgs.Protection)&Separator);

  if PrevAdrCtrlSgs.Operation=ReadOp then
   write(L,"0x"&Std_Logic_Vector_To_String(RDATA)&" -- Was read");
    else
   	 write(L,"0x"&Std_Logic_Vector_To_String(WDATA)&" -- Was write");
      end if;

   write(L,Separator);

   if ABORT='1' then
     write(L,"Memory abort"&Separator);
   end if;

  writeline(OutLogFile,L); -- Write to file

 else
  FirstCycle := FALSE;
 end if;

  PrevAdrCtrlSgs := CurrentAdrCtrlSgs;

end process;


end Beh;
