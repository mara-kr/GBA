--****************************************************************************************************
-- Top entity of memory sybsistem for ARM core simualtion
-- Designed by Ruslan Lepetenok
-- Modified 03.02.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;

use Work.ARMSMSSPackage.all; -- Constants and types
use Work.MSSCompPackage.all; -- Component declarations

entity ARMSimMemSubsystem is generic(
									 -- Bus monitor control
	                                 BusMonitorOn : boolean := TRUE;
	                                 -- ROM parameters
	                                 ROMWidth   : positive  := 32;
                                     ROMSize    : positive  := 4096;
	                                 InFileName : string    := "test.s19";
	                                 BaseAdr    : natural   := 16#300000#;
                                     BigEndian  : boolean   := FALSE;
	                           	     ROMBlank   : std_logic := '0';
									 DisChSTest : boolean   := FALSE;
									 -- RAM size (in bytes)
	                                 RAMSize: positive := 128;
	                                 -- Memory address(or range) for ABORT
									 AbtMemAdr   : std_logic_vector(CAbtMemAdrWidth-1 downto 0) := x"FFFF";
							         -- Number of aborts
									 NumberOfAbt : positive := 1;
	                                 -- Memory address(or range) for CLKEN
									 SlowMemAdr  : std_logic_vector(CSlowMemAdrWidth-1 downto 0):= x"FFFF";
						             -- Number of wait states
									 NumberOfWS  : positive := 1
									 );
	                         port (
								   -- Global control signals
	                               nRESET  : in  std_logic;
						           CLK     : in  std_logic;
								   -- Address class signals
								   ADDR    : in  std_logic_vector(31 downto 0);
								   WRITE   : in  std_logic;
								   SIZE    : in  std_logic_vector(1 downto 0);
								   PROT	   : in  std_logic_vector(1 downto 0);
								   -- Memory request signals
								   TRANS   : in  std_logic_vector(1 downto 0);
								   -- Data timed signals
								   WDATA   : in  std_logic_vector(31 downto 0);
								   RDATA   : out std_logic_vector(31 downto 0);
								   ABORT   : out std_logic;
								   -- Global control output
								   CLKEN   : out std_logic
								  );
end ARMSimMemSubsystem;

architecture Struct of ARMSimMemSubsystem is

signal CLKEN_Int    : std_logic := '0';
signal ByteWE       : std_logic_vector(3 downto 0) := (others => '0');
signal ADDRLatched  : std_logic_vector(ADDR'range) := (others => '0');
signal WRITELatched : std_logic := '0';
signal SIZELatched  : std_logic_vector(SIZE'range):= (others => '0');

signal ROMDOut      : std_logic_vector(RDATA'range) := (others => '0');
signal RAMDOut      : std_logic_vector(RDATA'range) := (others => '0');
signal DevCDOut     : std_logic_vector(RDATA'range) := (others => '0');
signal DevDDOut     : std_logic_vector(RDATA'range) := (others => '0');

signal SelDevA      : std_logic := '0';
signal SelDevB      : std_logic := '0';
signal SelDevC      : std_logic := '0';
signal SelDevD      : std_logic := '0';

signal SelROM      : std_logic := '0';
signal SelRAM      : std_logic := '0';

signal ABORT_Int   : std_logic := '0';
signal RDATA_Int   : std_logic_vector(RDATA'range) := (others => '0');

begin

RAM32B_Inst:component RAM32B generic map(RAMSize => RAMSize)
	              port map(
		     		   -- Global control signals
        			   CLK       => CLK,
					   CLKEN     => CLKEN_Int,
  	                   -- Address and data
					   Address   => ADDRLatched(LOG2(ROMWidth/8)+LOG2(RAMSize/4)-1 downto LOG2(ROMWidth/8)),
                       RAMSel	 => SelRAM,
					   ByteWE	 => ByteWE,
		               DataIn    => WDATA,
		               DataOut   => RAMDOut
					       );


ROMS19FR_Inst:component ROMS19FR generic map (
								ROMWidth   => ROMWidth,
                                ROMSize    => ROMSize,
	                            InFileName => InFileName,
	                            BaseAdr    => BaseAdr,
                                BigEndian  => BigEndian,
	                           	ROMBlank   => ROMBlank,
								DisChSTest => DisChSTest
							    )
		                port map (
					         Address   => ADDRLatched(LOG2(ROMWidth/8)+LOG2(ROMSize/(ROMWidth/8))-1 downto LOG2(ROMWidth/8)),
		                     DataOut   => ROMDOut
					        );


AdrCtrlReg_Inst:component AdrCtrlReg port map(
						   -- Global control signals
	                       nRESET    => nRESET,
						   CLK       => CLK,
						   CLKEN     => CLKEN_Int,
						   -- Address class signals
						   ADDR_In   => ADDR,
						   WRITE_In  => WRITE,
						   SIZE_In   => SIZE,
						   -- Outputs
						   ADDR_Out  => ADDRLatched,
						   WRITE_Out => WRITELatched,
						   SIZE_Out  => SIZELatched
						  );

Decoder_Inst:component Decoder generic map
	                      (AddressA => CROMAddress,
	                       AddressB => CRAMAddress,
	                       AddressC => CDevCAddress,
	                       AddressD => CDevDAddress
	                       )
	                 port map
	                      (
						   -- Address class signals
						   ADDR_In   => ADDRLatched,
						   WRITE_In  => WRITELatched,
						   SIZE_In   => SIZELatched,
						   -- Outputs
						   SelDevA	 => SelDevA, -- ROM address space
						   SelDevB	 => SelDevB, -- RAM address space
						   SelDevC	 => SelDevC,
						   SelDevD	 => SelDevD,
						   ByteWE	 => ByteWE
						 );


DataMux_Inst:component DataMux port map(
					    -- Control inputs
						SelDevA	 => SelROM,
						SelDevB	 => SelRAM,
						SelDevC	 => SelDevC,
						SelDevD	 => SelDevD,
					    -- Input data
						DataAIn  => ROMDOut,
						DataBIn  => RAMDOut,
						DataCIn  => DevCDOut,
						DataDIn  => ROMDOut, -- ROM address space occupates two positions
						-- Data output
						DataOut  => RDATA_Int
       				   );

ABORTGenerator_Inst:component ABORTGenerator
	               generic map(AbtMemAdr   => AbtMemAdr,
							   NumberOfAbt => NumberOfAbt
	                          )
	              port map(
		     		   -- Global control signals
        			   nRESET  => nRESET,
					   CLK     => CLK,
					   CLKEN   => CLKEN_Int,
					   -- Memory request signals
					   TRANS   => TRANS,
					   -- ADDR
					   ADDR    => ADDR,
                       -- Output
					   ABORT   => ABORT_Int
					   );

CLKENGenerator_Inst:component CLKENGenerator
	                generic map(SlowMemAdr => SlowMemAdr,
						        NumberOfWS => NumberOfWS
	                           )
	              port map(
		     		   -- Global control signals
        			   nRESET  => nRESET,
					   CLK     => CLK,
					   -- Memory request signals
					   TRANS   => TRANS,
					   -- ADDR and data
					   ADDR    => ADDR,
                       -- Output
					   CLKEN   => CLKEN_Int
					   );

MemoryRemapper_Inst:component MemoryRemapper generic map (RemapperAddress => CRemapperAddress)
	                    port map(
						   -- Global control signals
	                       nRESET     => nRESET,
						   CLK        => CLK,
						   CLKEN      => CLKEN_Int,
						   -- Address and data
                           Address    => ADDRLatched,
					       ByteWE	  => ByteWE,
		                   DataIn     => WDATA,
						   -- Memory select signals for remapping
						   SelDevAIn  => SelDevA,
						   SelDevBIn  => SelDevB,
						   SelDevAOut => SelROM,
						   SelDevBOut => SelRAM
						   );


CycleCounter_Inst:component CycleCounter port map (
						   -- Global control signals
	                       nRESET    => nRESET,
						   CLK       => CLK,
						   CLKEN     => CLKEN_Int,
						   -- Transaction type
						   TRANS     => TRANS
   						                          );

BusMon:if BusMonitorOn generate

BusMonitor_Inst:component BusMonitor generic map(LogFileName => CLogFileName)
	                 port map(
								   -- Global control signals
	                               nRESET  => nRESET,
						           CLK     => CLK,
								   CLKEN   => CLKEN_Int,
								   -- Address class signals
								   ADDR    => ADDR,
								   WRITE_I => WRITE,
								   SIZE    => SIZE,
								   PROT	   => PROT,
								   -- Memory request signals
								   TRANS   => TRANS,
								   -- Data timed signals
								   WDATA   => WDATA,
								   RDATA   => RDATA_Int,
								   ABORT   => ABORT_Int
								   );

end generate;

-- Outputs
ABORT <= ABORT_Int;
RDATA <= RDATA_Int;
CLKEN <= CLKEN_Int;

end Struct;
