--****************************************************************************************************
-- Top entity for ARM Core simulation
-- Designed by Ruslan Lepetenok
-- Modified 04.02.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;

use WORK.MSSCompPackage.all;

entity ARMCoreSimTop is
end ARMCoreSimTop;

architecture Struct of ARMCoreSimTop is

constant CRAMSize      : positive := 4096;
constant CROMBaseAdr   : natural  := 16#00000000#;
constant CROMSize      : positive := 8192;
constant CDisChSTest   : boolean  := FALSE;
constant CBusMonitorOn : boolean  := TRUE;

component ARM7TDMIS_Top is port(
	                        -- Clock
							CLK           : in std_logic;
							CLKEN         : in std_logic;
							-- Interrupts
							nRESET        : in std_logic;
	                        nIRQ          : in std_logic;
							nFIQ          : in std_logic;
							-- Memory interface
							ADDR          : out std_logic_vector(31 downto 0);
	                        WDATA         : out std_logic_vector(31 downto 0);
	                        RDATA         : in  std_logic_vector(31 downto 0);
							ABORT	      : in std_logic;
							WRITE         : out std_logic;
                            SIZE          : out std_logic_vector(1 downto 0);
							PROT          : out std_logic_vector(1 downto 0);
							TRANS         : out std_logic_vector(1 downto 0);
							-- Memory management interface
							CPnTRANS      : out std_logic;
							CPnOPC        : out std_logic;
							-- Coprocessor interface
							CPnMREQ       : out std_logic;
							CPnSEQ        : out std_logic;
							CPTBIT        : out std_logic;
							CPnI          : out std_logic;
							CPA	          : in std_logic;
							CPB	          : in std_logic
							);
end component;

component ClockAndResetGenerator is port (
	                                      nRESET  : out std_logic;
						                  CLK     : out std_logic
						                  );
end component;

signal nRESET    : std_logic := '0';
signal CLK       : std_logic := '0';
signal CLKEN     : std_logic := '0';
signal ADDR      : std_logic_vector (31 downto 0) := (others => '0');
signal RDATA     : std_logic_vector (31 downto 0) := (others => '0');
signal WDATA     : std_logic_vector (31 downto 0) := (others => '0');
signal ABORT     : std_logic := '0';
signal SIZE      : std_logic_vector (1 downto 0) := (others => '0');
signal PROT      : std_logic_vector (1 downto 0) := (others => '0');
signal TRANS     : std_logic_vector (1 downto 0) := (others => '0');
signal WRITE     : std_logic := '0';

begin

CLKAndReset:component ClockAndResetGenerator port map (
	                                      nRESET  => nRESET,
						                  CLK     => CLK
						                  );


ARMSimMemSubsystem_Inst:entity ARMSimMemSubsystem generic map(
									 -- Bus monitor control
	                                 BusMonitorOn => CBusMonitorOn,
	                                 -- ROM parameters
	                                 ROMWidth   => 32,
                                     ROMSize    => CROMSize,
	                                 InFileName => "default.run",
	                                 BaseAdr    => CROMBaseAdr,
                                     BigEndian  => FALSE,
	                           	     ROMBlank   => '0',
									 DisChSTest => CDisChSTest,
									 -- RAM size (in bytes)
	                                 RAMSize => CRAMSize,
	                                 -- Memory address(or range) for ABORT
									 AbtMemAdr => x"FFFF",
							         -- Number of aborts
									 NumberOfAbt => 1,
	                                 -- Memory address(or range) for CLKEN
									 SlowMemAdr  => x"FFFF",
						             -- Number of wait states
									 NumberOfWS => 1
									 )
	                         port map(
								   -- Global control signals
	                               nRESET  => nRESET,
						           CLK     => CLK,
								   -- Address class signals
								   ADDR    => ADDR,
								   WRITE   => WRITE,
								   SIZE    => SIZE,
								   PROT	   => PROT,
								   -- Memory request signals
								   TRANS   => TRANS,
								   -- Data timed signals
								   WDATA   => WDATA,
								   RDATA   => RDATA,
								   ABORT   => ABORT,
								   -- Global control output
								   CLKEN   => CLKEN
								  );



CoreUnderTest:component ARM7TDMIS_Top port map(
	                        -- Clock
							CLK           => CLK,
							CLKEN         => CLKEN,
							-- Interrupts
							nRESET        => nRESET,
	                        nIRQ          => '1',
							nFIQ          => '1',
							-- Memory interface
							ADDR          => ADDR,
	                        WDATA         => WDATA,
	                        RDATA         => RDATA,
							ABORT	      => ABORT,
							WRITE         => WRITE,
                            SIZE          => SIZE,
							PROT          => PROT,
							TRANS         => TRANS,
							-- Memory management interface
							CPnTRANS      => open,
							CPnOPC        => open,
							-- Coprocessor interface
							CPnMREQ       => open,
							CPnSEQ        => open,
							CPTBIT        => open,
							CPnI          => open,
							CPA	          => '0',
							CPB	          => '0'
							);



end Struct;

