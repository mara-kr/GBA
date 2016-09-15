-- *****************************************************************************************
-- Components for ARM memory subsystem (simulation)
-- Designed by Ruslan Lepetenok
-- Modified 02.02.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use WORK.ARMSMSSPackage.all;

package MSSCompPackage is

component ARMSimMemSubsystem is generic(
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
	                                 RAMSize    : positive := 128;
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
end component;


component RAM32B is generic(RAMSize : positive := 128);
	              port(
		     		   -- Global control signals
        			   CLK       : in  std_logic;
					   CLKEN     : in  std_logic;
  	                   -- Address and data
					   Address   : in  std_logic_vector(LOG2(RAMSize/4)-1 downto 0);
                       RAMSel	 : in  std_logic;
					   ByteWE	 : in  std_logic_vector(3 downto 0);
		               DataIn    : in  std_logic_vector(31 downto 0);
		               DataOut   : out std_logic_vector(31 downto 0)
					   );
end component;

component ROM is port (
                    Address : in  std_logic_vector (31 downto 0);
                    Data    : out std_logic_vector (31 downto 0));
end component;


component AdrCtrlReg is port (
						   -- Global control signals
	                       nRESET    : in  std_logic;
						   CLK       : in  std_logic;
						   CLKEN     : in  std_logic;
						   -- Address class signals
						   ADDR_In   : in  std_logic_vector(31 downto 0);
						   WRITE_In  : in  std_logic;
						   SIZE_In   : in  std_logic_vector(1 downto 0);
						   -- Outputs
						   ADDR_Out  : out std_logic_vector(31 downto 0);
						   WRITE_Out : out std_logic;
						   SIZE_Out  : out std_logic_vector(1 downto 0)
						  );
end component;


component Decoder is generic(AddressA : std_logic_vector(DecoderAdrWidth-1 downto 0);
	                         AddressB : std_logic_vector(DecoderAdrWidth-1 downto 0);
	                         AddressC : std_logic_vector(DecoderAdrWidth-1 downto 0);
	                         AddressD : std_logic_vector(DecoderAdrWidth-1 downto 0)
	                         );
	                 port
	                      (
						   -- Address class signals
						   ADDR_In   : in  std_logic_vector(31 downto 0);
						   WRITE_In  : in  std_logic;
						   SIZE_In   : in  std_logic_vector(1 downto 0);
						   -- Outputs
						   SelDevA	 : out std_logic;
						   SelDevB	 : out std_logic;
						   SelDevC	 : out std_logic;
						   SelDevD	 : out std_logic;
						   ByteWE	 : out std_logic_vector(3 downto 0)
						 );
end component;


component DataMux is port (
					    -- Control inputs
						SelDevA	 : in  std_logic;
						SelDevB	 : in  std_logic;
						SelDevC	 : in  std_logic;
						SelDevD	 : in  std_logic;
					    -- Input data
						DataAIn  : in  std_logic_vector(31 downto 0);
						DataBIn  : in  std_logic_vector(31 downto 0);
						DataCIn  : in  std_logic_vector(31 downto 0);
						DataDIn  : in  std_logic_vector(31 downto 0);
						-- Data output
						DataOut  : out std_logic_vector(31 downto 0)
       				   );
end component;


component ABORTGenerator is generic(AbtMemAdr   : std_logic_vector(CAbtMemAdrWidth-1 downto 0);
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
end component;

component CLKENGenerator is generic(SlowMemAdr : std_logic_vector(CSlowMemAdrWidth-1 downto 0);
								    NumberOfWS : positive
	                            );
	              port(
		     		   -- Global control signals
        			   nRESET  : in  std_logic;
					   CLK     : in  std_logic;
					   -- Memory request signals
					   TRANS   : in  std_logic_vector(1 downto 0);
					   -- ADDR and data
					   ADDR    : in  std_logic_vector(31 downto 0);
                       -- Output
					   CLKEN   : out std_logic
					   );
end component;


component MemoryRemapper is generic (RemapperAddress : std_logic_vector(31 downto 0));
	                    port (
						   -- Global control signals
	                       nRESET     : in  std_logic;
						   CLK        : in  std_logic;
						   CLKEN      : in  std_logic;
						   -- Address and data
                           Address    : in  std_logic_vector(31 downto 0);
					       ByteWE	  : in  std_logic_vector(3 downto 0);
		                   DataIn     : in  std_logic_vector(31 downto 0);
						   -- Memory select signals for remapping
						   SelDevAIn  : in  std_logic;
						   SelDevBIn  : in  std_logic;
						   SelDevAOut : out std_logic;
						   SelDevBOut : out std_logic
						   );
end component;

component ROMS19FR is generic(
								ROMWidth   : positive;
                                ROMSize    : positive;
	                            InFileName : string;
	                            BaseAdr    : natural;
                                BigEndian  : boolean;
	                           	ROMBlank   : std_logic;
								DisChSTest : boolean
							    );
		                port(
					         Address   : in  std_logic_vector(LOG2(ROMSize/(ROMWidth/8))-1 downto 0);
		                     DataOut   : out std_logic_vector(ROMWidth-1 downto 0)
					        );
end component;

component CycleCounter is port (
						   -- Global control signals
	                       nRESET    : in  std_logic;
						   CLK       : in  std_logic;
						   CLKEN     : in  std_logic;
						   -- Transaction type
						   TRANS     : in  std_logic_vector(1 downto 0)
   						    );
end component;

component BusMonitor is generic(LogFileName : string);
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


end component;

end MSSCompPackage;
