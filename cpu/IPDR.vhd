--****************************************************************************************************
-- Instruction pipeline register, data in register  for ARM7TDMI-S processor
-- Designed by Ruslan Lepetenok
-- Modified 23.01.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;

use WORK.ARMPackage.all;

entity IPDR is port(
	                   -- Clock and reset
				       nRESET               : in  std_logic;
					   CLK                  : in  std_logic;
					   CLKEN                : in  std_logic;
					   -- Memory interface
	                   RDATA                : in  std_logic_vector(31 downto 0);
					   ABORT	            : in  std_logic;
					   -- Thumb decoder interface
					   ToThumbDecoder		: out std_logic_vector(31 downto 0);
					   FromThumbDecoder		: in  std_logic_vector(31 downto 0);
					   HalfWordAddress		: out std_logic;
					   -- Interfaces for the internal CPU modules
					   InstForDecode        : out std_logic_vector(31 downto 0);
					   InstFetchAbort       : out std_logic;
					   ADDRLow              : in  std_logic_vector(1 downto 0); -- Address [1..0]
					   StagnatePipeline	    : in  std_logic;
					   StagnatePipelineDel	: in  std_logic;
					   FirstInstFetch		: in  std_logic;
					   -- Data out register and control(sign/zero, byte/halfword  extension)
					   DataOut              : out std_logic_vector(31 downto 0);
					   SignExt				: in  std_logic;
					   ZeroExt				: in  std_logic;
					   nB_HW				: in  std_logic;
					   -- Immediate fields out
					   SExtOffset24Bit      : out std_logic_vector(31 downto 0);
                       Offset12Bit          : out std_logic_vector(31 downto 0);
                       Offset8Bit           : out std_logic_vector(31 downto 0);
                       Immediate8Bit        : out std_logic_vector(31 downto 0);
					   -- Bus control
					   EndianMode           : in  std_logic
					   );
end IPDR;

architecture RTL of IPDR is

-- Endian converter
signal EndianConverterOut : std_logic_vector(RDATA'range) := (others => '0');

-- Data rotator
signal DataRotator : std_logic_vector(RDATA'range) := (others => '0');

-- Set of signals for prefetch
signal PrefetchedInstruction : std_logic_vector(RDATA'range) := (others => '0');
signal PrefetchedAbort : std_logic := '0';
signal PrefetchedHWAdr : std_logic := '0'; -- Address of halfword (ADDR[1])

-- Set of signals for fetch
signal FetchedInstructionIn : std_logic_vector(RDATA'range) := (others => '0');

signal FetchedAbortIn       : std_logic := '0';
signal FetchADDRLow         : std_logic_vector(ADDRLow'range) := (others => '0');
signal FetchedHWAdrIn       : std_logic := '0'; -- HWAdrIn for FETCH instruction

-- Sign or zero extension signals
signal DataReg : std_logic_vector(RDATA'range) := (others => '0');
signal ByteExtended     : std_logic_vector(RDATA'range) := (others => '0');
signal HalfWordExtended : std_logic_vector(RDATA'range) := (others => '0');

begin

-- Big endian to little endian convertion ??
EndianConverterOut <= RDATA when EndianMode='0' else                                                   -- Little endian mode
					  RDATA(7 downto 0)&RDATA(15 downto 8)&RDATA(23 downto 16)&RDATA(31 downto 24);	-- Big endian mode

Prefetch:process(nRESET,CLK)
begin
if nRESET='0' then                                                      -- Reset
  PrefetchedInstruction <= (others => '0');
  PrefetchedAbort <= '0';
  PrefetchedHWAdr <= '0';
 elsif CLK='1' and CLK'event then                                       -- Clock
 if StagnatePipelineDel='0' and StagnatePipeline='1' and CLKEN='1' then -- Clock enable
  PrefetchedInstruction <= EndianConverterOut;
  PrefetchedAbort <= ABORT;
  PrefetchedHWAdr <= ADDRLow(1); -- TBD might need to be FetchedADDRLow
 end if;
end if;
end process;

FetchedInstructionIn <= PrefetchedInstruction when
                        StagnatePipelineDel='1' and StagnatePipeline='0'
						else EndianConverterOut;

FetchedAbortIn <= PrefetchedAbort when
                  StagnatePipelineDel='1' and StagnatePipeline='0'
				  else ABORT;

FetchedHWAdrIn <= PrefetchedHWAdr when
                  StagnatePipelineDel='1' and StagnatePipeline='0'
                  else ADDRLow(1);


Fetch:process(nRESET,CLK)
begin
if nRESET='0' then                             -- Reset
  ToThumbDecoder <= (others => '0');
  InstFetchAbort <= '0';
  HalfWordAddress <= '0';
 elsif CLK='1' and CLK'event then              -- Clock
 if StagnatePipeline='0' and FirstInstFetch='1' and CLKEN='1' then    -- Clock enable
  ToThumbDecoder <= FetchedInstructionIn;
  InstFetchAbort <= FetchedAbortIn;
  HalfWordAddress <= FetchedHWAdrIn;
 end if;
end if;
end process;

InstForDecode <= FromThumbDecoder;


ImmediateDataRegs:process(nRESET,CLK)
begin
if nRESET='0' then                             -- Reset
  SExtOffset24Bit <= (others => '0');
  Offset12Bit <= (others => '0');
  Offset8Bit <= (others => '0');
  Immediate8Bit <= (others => '0');
 elsif CLK='1' and CLK'event then              -- Clock
 if StagnatePipeline='0' and CLKEN='1' then    -- Clock enable
  SExtOffset24Bit <= (31 downto 24 => FromThumbDecoder(23))&FromThumbDecoder(23 downto 0);
  Offset12Bit <= (31 downto 12 => '0')&FromThumbDecoder(11 downto 0);
  Offset8Bit <= (31 downto 8 => '0')&FromThumbDecoder(11 downto 8)&FromThumbDecoder(3 downto 0);
  Immediate8Bit <= (31 downto 8 => '0')&FromThumbDecoder(7 downto 0);
 end if;
end if;
end process;

-- Data in register
DataInReg:process(nRESET,CLK)
begin
if nRESET='0' then                     -- Reset
  DataReg <= (others => '0');
  elsif CLK='1' and CLK'event then      -- Clock
 if CLKEN='1' then -- Clock enable
  DataReg <= DataRotator; -- Data fetched from memory
 end if;
end if;
end process;

-- Data rotator
DataRotator <= EndianConverterOut when ADDRLow="00" else
	           EndianConverterOut(7 downto 0)&EndianConverterOut(31 downto 8) when ADDRLow="01" else
			   EndianConverterOut(15 downto 0)&EndianConverterOut(31 downto 16) when ADDRLow="10" else
			   EndianConverterOut(23 downto 0)&EndianConverterOut(31 downto 24) when ADDRLow="11" else
			   (others => CDnCr);


ByteExtended <= (31 downto 8 =>'0')&DataReg(7 downto 0) when SignExt='0' else
				(31 downto 8 => DataReg(7))&DataReg(7 downto 0);

HalfWordExtended <= (31 downto 16 =>'0')&DataReg(15 downto 0) when SignExt='0' else
				    (31 downto 16 => DataReg(15))&DataReg(15 downto 0);

DataOut <= DataReg when  SignExt='0' and ZeroExt='0' else
           ByteExtended when nB_HW='0' else
		   HalfWordExtended when nB_HW='1' else
		   (others => CDnCr);

end RTL;
