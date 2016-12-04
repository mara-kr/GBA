--****************************************************************************************************
-- Top entity for ARM7TDMI-S processor
-- Designed by Ruslan Lepetenok
-- Modified 12.02.2003
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;

use WORK.ARMPackage.all;

entity ARM7TDMIS_Top is port(
	                        -- Clock
							CLK           : in std_logic;
							PAUSE         : in std_logic;
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
                            -- Information signals
                            MODE          : out std_logic_vector(4 downto 0);
                            PREEMPTABLE    : out std_logic
							);
end ARM7TDMIS_Top;

architecture Struct of ARM7TDMIS_Top is

constant CSlackEstim : boolean := FALSE;

-- Components

-- ALU
component ALU is port (
	                    ADataIn    : in  std_logic_vector(31 downto 0);
						BDataIn    : in  std_logic_vector(31 downto 0);
						DataOut    : out std_logic_vector(31 downto 0);
						InvA	   : in  std_logic;
						InvB	   : in  std_logic;
						PassA	   : in  std_logic;
						PassB	   : in  std_logic;	-- MOV/MVN operations
						-- Logic operations
						AND_Op	   : in  std_logic;
						ORR_Op	   : in  std_logic;
						EOR_Op	   : in  std_logic;
						-- Flag inputs
						CFlagIn	   : in  std_logic;
						CFlagUse   : in  std_logic; -- ADC/SBC/RSC instructions
                        ThADR      : in  std_logic;
						-- Flag outputs
						CFlagOut    : out  std_logic;
						VFlagOut    : out  std_logic;
						NFlagOut    : out  std_logic;
						ZFlagOut    : out  std_logic
				    );
end component;

-- Shifter
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

-- Multiplier
component Multiplier is port (
						   -- Global signals
	                       nRESET      : in  std_logic;
						   CLK         : in  std_logic;
						   CLKEN       : in  std_logic;
	                       -- Data inputs
	                       ADataIn     : in  std_logic_vector(31 downto 0); -- RdHi(Rn)/Rs data path
						   BDataIn     : in  std_logic_vector(31 downto 0); -- RdLo(Rd)/Rm data path
						   -- Data outputs
						   ADataOut    : out  std_logic_vector(31 downto 0);
						   BDataOut    : out  std_logic_vector(31 downto 0);
						   -- Control inputs
						   LoadRsRm    : in  std_logic; -- Load Rs and Rm and start
						   LoadPS      : in  std_logic; -- Load partial sum register with RHi:RLo
						   ClearPSC    : in  std_logic; -- Clear prtial sum register
						   UnsignedMul : in  std_logic; -- Unsigned multiplication
						   ReadLH	   : in  std_logic;	-- 0 - Read PS/PC low,1 - Read PS/PC high
						   -- Control outputs
						   MulResRdy   : out std_logic  -- Multiplication result is ready
						   );
end component;


-- Register file
component RegFile is generic(DebugMode : boolean);
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
end component;

-- Program status registers
component PSR is port(
						-- Global control signals
	                    nRESET    : in  std_logic;
						CLK       : in  std_logic;
						CLKEN     : in  std_logic;
						-- ALU Data in
						DataIn    : in  std_logic_vector(31 downto 0);
						PSRDInSel : in  std_logic;
						-- Current program state
						CPSRIn    : in  std_logic_vector(31 downto 0);
						CPSRWrEn  : in  std_logic_vector(31 downto 0);
						CPSROut   : out std_logic_vector(31 downto 0);
						CFlForMul : in  std_logic;
						-- Saved program state
						SPSRIn    : in  std_logic_vector(31 downto 0);
	                    SPSROut   : out std_logic_vector(31 downto 0);
						SPSRWrMsk : in  std_logic_vector(3 downto 0);
						-- PSR mode control
						PSRMode   : in  std_logic_vector(4 downto 0)
						);
end component;



-- Instruction pipeline, data in register, immediate data extractor
component IPDR is port(
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
					   EndianMode              : in  std_logic
					   );
end component;



-- Address register and incrementer
component AddressMux_Incrementer is port(
					   -- Clock and reset
				       nRESET             : in  std_logic;
					   CLK                : in  std_logic;
					   CLKEN              : in  std_logic;
	                   -- Address and control
					   ADDR               : out std_logic_vector(31 downto 0);
				 	   FromPC		      : in  std_logic_vector(31 downto 0);
					   ToPC			      : out std_logic_vector(31 downto 0);
					   FromALU		      : in  std_logic_vector(31 downto 0);
					   ExceptionVector    : in  std_logic_vector(31 downto 0);
					   PCInSel		      : in  std_logic;
					   ALUInSel		      : in  std_logic;
					   ExceptionVectorSel : in  std_logic;
					   PCIncStep          : in  std_logic;
					   AdrIncStep		  : in  std_logic;
					   AdrToPCSel	      : in  std_logic;
					   AdrCntEn	          : in  std_logic
					                    );

end component;

-- Data out register
component DataOutMux is port(
						-- Control signals
						StoreHalfWord : in  std_logic;
						StoreByte	  : in  std_logic;
						BigEndianMode : in  std_logic;
						-- Data signals
						DataIn        : in  std_logic_vector(31 downto 0);
						WDATA         : out std_logic_vector(31 downto 0)
						     );

end component;


-- Register for shift amount
component ShiftAmountReg is port(
	                   -- Clock and reset
				       nRESET     : in  std_logic;
					   CLK        : in  std_logic;
					   CLKEN      : in  std_logic;
					   -- Data signals
					   ShLenRsIn  : in   std_logic_vector(7 downto 0);  -- Shift amount for register shift (value of Rs[7..0])
					   ShLenRsOut : out  std_logic_vector(7 downto 0)
					   );
end component;


-- A bus multiplexer
component ABusMultiplexer is port(
					   -- Data input
	                   RegFileAOut      : in  std_logic_vector(31 downto 0);
	                   MultiplierAOut   : in  std_logic_vector(31 downto 0);
					   CPSROut          : in  std_logic_vector(31 downto 0);
					   SPSROut          : in  std_logic_vector(31 downto 0);
					   -- Control
					   RegFileAOutSel    : in  std_logic;
	                   MultiplierAOutSel : in  std_logic;
					   CPSROutSel        : in  std_logic;
					   SPSROutSel        : in  std_logic;
					   -- Data output
					   ABusOut		    : out std_logic_vector(31 downto 0)
					          );
end component;

-- B bus multiplexer
component BBusMultiplexer is port(
					   -- Data input
	                   RegFileBOut       : in  std_logic_vector(31 downto 0);
	                   MultiplierBOut    : in  std_logic_vector(31 downto 0);
					   MemDataRegOut     : in  std_logic_vector(31 downto 0);
					   AdrGenDataOut	 : in  std_logic_vector(31 downto 0);
					   -- Immediate fields
					   SExtOffset24Bit   : in  std_logic_vector(31 downto 0);
                       Offset12Bit       : in  std_logic_vector(31 downto 0);
                       Offset8Bit        : in  std_logic_vector(31 downto 0);
                       Immediate8Bit     : in  std_logic_vector(31 downto 0);
					   -- Control
					   RegFileBOutSel     : in  std_logic;	-- Output of the register file
	                   MultiplierBOutSel  : in  std_logic;	-- Output of the multiplier
					   MemDataRegOutSel   : in  std_logic;	-- Output of the data in register
					   SExtOffset24BitSel : in  std_logic;
                       Offset12BitSel     : in  std_logic;
                       Offset8BitSel      : in  std_logic;
                       Immediate8BitSel   : in  std_logic;
					   AdrGenDataSel		 : in  std_logic;
					   -- Data output
					   BBusOut		     : out std_logic_vector(31 downto 0)	 -- Connected to the input of the shifter
					          );
end component;

-- Address generator for load/store
component LSAdrGen is port (
						-- Global control signals
	                    nRESET           : in  std_logic;
						CLK              : in  std_logic;
						CLKEN            : in  std_logic;
	                    -- Control and data
						RmDataIn	     : in  std_logic_vector(31 downto 0);
						BDataOut	     : out std_logic_vector(31 downto 0);
						RegisterList     : in  std_logic_vector(15 downto 0);
	                    IncBeforeSel     : in  std_logic;
	                    DecBeforeSel     : in  std_logic;
						DecAfterSel      : in  std_logic;
						MltAdrSel	     : in  std_logic; -- 0 -> Start address, 1-> Base reg. update (only for LDM/STM)
						SngMltSel	     : in  std_logic  -- 0 -> LDM/STM, 1 -> LDR/STR
						);
end component;

component ResltBitMask is port(
					   -- Data
	                   DataIn     : in  std_logic_vector(31 downto 0);
	                   DataOut    : out std_logic_vector(31 downto 0);
					   -- Control
					   ClrBitZero : in std_logic;
					   ClrBitOne  : in std_logic;
					   SetBitZero : in std_logic
	                          );
end component;

-- Combinatorial Thumb decoder
component ThumbDecoder is port(
                       CLK             : in  std_logic;
                       nRESET          : in  std_logic;
                       CLKEN           : in  std_logic;
					   InstForDecode   : in  std_logic_vector(31 downto 0);
					   ExpandedInst	   : out std_logic_vector(31 downto 0);
					   HalfWordAddress : in  std_logic;
					   ThumbDecoderEn  : in  std_logic;
                       StagnatePipeline: in  std_logic;
					   ThBLFP          : out std_logic;
                       ThBLSP          : out std_logic;
                       ThADR           : out std_logic
					       );
end component;

-- Control logic
component ControlLogic is port(
	                   -- Clock and reset
				       nRESET               : in  std_logic;
					   CLK                  : in  std_logic;
					   CLKEN                : in  std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Control signals commom for several modules
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   BigEndianMode        : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Instruction pipeline and data in registers control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Interfaces for the internal CPU modules
					   InstForDecode        : in  std_logic_vector(31 downto 0);
					   InstFetchAbort       : in  std_logic;
					   StagnatePipeline	    : out std_logic;
					   StagnatePipelineDel	: out  std_logic;
					   FirstInstFetch		: out  std_logic;
					   -- Data out register and control(sign/zero, byte/halfword  extension)
					   SignExt				: out std_logic;
					   ZeroExt				: out std_logic;
					   nB_HW				: out std_logic;
					   -- Bus control
					   EndianMode              : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Data output register control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
						StoreHalfWord : out  std_logic;
						StoreByte	  : out  std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Address multiplexer and incrementer control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   ExceptionVector      : out std_logic_vector(31 downto 0);
					   PCInSel		        : out std_logic;
					   ALUInSel		        : out std_logic;
					   ExceptionVectorSel   : out std_logic;
			  		   PCIncStep            : out std_logic; 	-- ?? Common  1
					   AdrIncStep		    : out std_logic;
					   AdrToPCSel	        : out std_logic;
					   AdrCntEn             : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- ALU control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					    InvA	   : out std_logic;
						InvB	   : out std_logic;
						PassA	   : out std_logic;
						PassB	   : out std_logic;	-- MOV/MVN operations
						-- Logic operations
						AND_Op	   : out std_logic;
						ORR_Op	   : out std_logic;
						EOR_Op	   : out std_logic;
						-- Flag inputs
						CFlagUse   : out std_logic; -- ADC/SBC/RSC instructions
						-- Flag outputs
						CFlagOut    : in  std_logic;
						VFlagOut    : in  std_logic;
						NFlagOut    : in  std_logic;
						ZFlagOut    : in  std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Multiplier control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   LoadRsRm    : out std_logic; -- Load Rs and Rm and start
					   LoadPS      : out std_logic; -- Load partial sum register with RHi:RLo
					   ClearPSC     : out std_logic; -- Clear prtial sum register
					   UnsignedMul : out std_logic; -- Unsigned multiplication
					   ReadLH	   : out std_logic;	-- 0 - Read PS/PC low,1 - Read PS/PC high
					   MulResRdy   : in  std_logic; -- Multiplication result is ready

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Register file control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					    ABusRdAdr      : out  std_logic_vector(3 downto 0);
						BBusRdAdr      : out  std_logic_vector(3 downto 0);
						WriteAdr       : out  std_logic_vector(3 downto 0);
						WrEn	       : out  std_logic;
						-- Program counter
						PCWrEn         : out  std_logic;
						PCSrcSel       : out  std_logic;
						-- Mode control signals
						RFMode         : out  std_logic_vector(4 downto 0);
					   	SaveBaseReg    : out  std_logic;
                        RestoreBaseReg : out  std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Programm Status Registers control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- ALU bus input control
                       PSRDInSel : out std_logic;
					   -- Current program state
					   CPSRIn    : out std_logic_vector(31 downto 0);
					   CPSRWrEn  : out std_logic_vector(31 downto 0);
					   CPSROut   : in  std_logic_vector(31 downto 0);
					   CFlForMul : out std_logic;
					   -- Saved program state
					   SPSRIn    : out std_logic_vector(31 downto 0);
					   SPSROut   : in  std_logic_vector(31 downto 0);
					   SPSRWrMsk  : out std_logic_vector(3 downto 0);
					   -- PSR mode control
					   PSRMode   : out std_logic_vector(4 downto 0);

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Shifter control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--	                   ShCFlagIn  : out std_logic;                     -- Input of the carry flag
--					   ShCFlagOut : in  std_logic;                     -- Output of the carry flag
					   ShLenImm   : out std_logic_vector(4 downto 0);  -- Shift amount for immediate shift (bits [11..7])
					   ShType     : out std_logic_vector(2 downto 0);  -- Shift type (bits 6,5 and 4 of instruction)
					   ShRotImm   : out std_logic;                     -- Rotate immediate 8-bit value
					   ShEn       : out std_logic;
					   ShCFlagEn  : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Bus A multiplexer control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   RegFileAOutSel    : out std_logic;
	                   MultiplierAOutSel : out std_logic;
					   CPSROutSel        : out  std_logic;
					   SPSROutSel        : out  std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Bus B multiplexer control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   RegFileBOutSel     : out std_logic;	-- Output of the register file
	                   MultiplierBOutSel  : out std_logic;	-- Output of the multiplier
					   MemDataRegOutSel   : out std_logic;	-- Output of the data in register
					   SExtOffset24BitSel : out std_logic;
                       Offset12BitSel     : out std_logic;
                       Offset8BitSel      : out std_logic;
                       Immediate8BitSel   : out std_logic;
			   		   AdrGenDataSel	  : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Address generator for Load/Store instructions control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   	RegisterList     : out std_logic_vector(15 downto 0);
	                    IncBeforeSel     : out std_logic;
	                    DecBeforeSel     : out std_logic;
						DecAfterSel      : out std_logic;
						MltAdrSel	     : out std_logic;
						SngMltSel	     : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Bit 0,1 clear/set control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
						ClrBitZero       : out std_logic;
                        ClrBitOne        : out std_logic;
					   	SetBitZero		 : out std_logic;

		               -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Thumb decoder control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   ThumbDecoderEn	 : out std_logic;
					   ThBLFP            : in std_logic;
                       ThBLSP            : in std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Rm[0] input for ARM/Thumb state detection during BX
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					    RmBitZero        : in std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                       -- AddrLow for DataRotator in IPDR
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        Addr             : in  std_logic_vector(31 downto 0);
                        DataAddrLow      : out std_logic_vector(1 downto 0);

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- External signals
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Interrupts
					   nIRQ       : in std_logic;
                       nFIQ       : in std_logic;
					   -- Memory interface
   					   ABORT      : in  std_logic;
					   WRITE      : out std_logic;
                       SIZE       : out std_logic_vector(1 downto 0);
                       PREEMPTABLE : out std_logic
					   );
end component;

attribute mark_debug : string;

-- Control signals
signal CLKEN        : std_logic := '0';


-- ALU signals
signal ALU_DataOut  : std_logic_vector(31 downto 0) := (others => '0');
signal ALU_InvA	    : std_logic := '0';
signal ALU_InvB	    : std_logic := '0';
signal ALU_PassA    : std_logic := '0';
signal ALU_PassB    : std_logic := '0';
signal ALU_AND_Op   : std_logic := '0';
signal ALU_ORR_Op   : std_logic := '0';
signal ALU_EOR_Op   : std_logic := '0';
signal ALU_CFlagIn	: std_logic := '0';
signal ALU_CFlagUse : std_logic := '0';
signal ALU_CFlagOut : std_logic := '0';
signal ALU_VFlagOut : std_logic := '0';
signal ALU_NFlagOut : std_logic := '0';
signal ALU_ZFlagOut : std_logic := '0';
signal ALU_ThADR    : std_logic := '0';


-- Shifter signals
signal	Shifter_ShBBusIn   : std_logic_vector(31 downto 0) := (others => '0');
signal	Shifter_ShOut      : std_logic_vector(31 downto 0) := (others => '0');

signal	Shifter_ShCFlagIn  : std_logic := '0';
signal	Shifter_ShCFlagOut : std_logic := '0';
signal	Shifter_ShLenRs    : std_logic_vector(7 downto 0) := (others => '0');
signal	Shifter_ShLenImm   : std_logic_vector(4 downto 0) := (others => '0');
signal	Shifter_ShType     : std_logic_vector(2 downto 0) := (others => '0');
signal	Shifter_ShRotImm   : std_logic := '0';
signal	Shifter_ShEn       : std_logic := '0';
signal	Shifter_ShCFlagEn  : std_logic := '0';

-- Register file signals
signal RegFile_ABusOut        : std_logic_vector(31 downto 0) := (others => '0');
signal RegFile_BBusOut        : std_logic_vector(31 downto 0) := (others => '0');
signal RegFile_ABusRdAdr      : std_logic_vector(3 downto 0) := (others => '0');
signal RegFile_BBusRdAdr      : std_logic_vector(3 downto 0) := (others => '0');
signal RegFile_WriteAdr       : std_logic_vector(3 downto 0) := (others => '0');
signal RegFile_WrEn	  	      : std_logic := '0';
signal RegFile_PCIn           : std_logic_vector(31 downto 0) := (others => '0');
signal RegFile_PCOut          : std_logic_vector(31 downto 0) := (others => '0');
attribute mark_debug of RegFile_PCOut : signal is "true";
signal RegFile_PCWrEn         : std_logic := '0';
signal RegFile_PCSrcSel       : std_logic := '0';
signal RegFile_RFMode         : std_logic_vector(4 downto 0) := (others => '0');
signal RegFile_SaveBaseReg    : std_logic := '0';
signal RegFile_RestoreBaseReg : std_logic := '0';

-- Multiplier signals
signal Mult_ADataOut    : std_logic_vector(31 downto 0) := (others => '0');
signal Mult_BDataOut    : std_logic_vector(31 downto 0) := (others => '0');
signal Mult_LoadRsRm    : std_logic := '0';
signal Mult_LoadPS      : std_logic := '0';
signal Mult_ClearPSC    : std_logic := '0';
signal Mult_UnsignedMul : std_logic := '0';
signal Mult_ReadLH	    : std_logic := '0';
signal Mult_MulResRdy   : std_logic := '0';

-- Program status registers signals
signal PSR_CPSRIn     : std_logic_vector(31 downto 0) := (others => '0');
signal PSR_CPSRWrEn   : std_logic_vector(31 downto 0) := (others => '0');
signal PSR_CPSROut    : std_logic_vector(31 downto 0) := (others => '0');
attribute mark_debug of PSR_CPSROut : signal is "true";
signal PSR_CFlForMul  : std_logic := '0';
signal PSR_SPSRIn     : std_logic_vector(31 downto 0) := (others => '0');
signal PSR_SPSRWrMsk  : std_logic_vector(3 downto 0)  := (others => '0');
signal PSR_SPSROut    : std_logic_vector(31 downto 0) := (others => '0');
signal PSR_PSRMode    : std_logic_vector(4 downto 0)  := (others => '0');
signal PSR_PSRDInSel  : std_logic := '0';
alias  PSR_CFlagOut   : std_logic is PSR_CPSROut(29);

-- Instruction pipeline signals
signal IPDR_InstForDecode       : std_logic_vector(31 downto 0) := (others => '0');
attribute mark_debug of IPDR_InstForDecode : signal is "true";
signal IPDR_StagnatePipeline    : std_logic := '0';
signal IPDR_StagnatePipelineDel	: std_logic := '0';
signal IPRD_FirstInstFetch		: std_logic := '0';
signal IPDR_InstFetchAbort      : std_logic := '0';
signal IPDR_DataOut             : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_SExtOffset24Bit     : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_Offset12Bit         : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_Offset8Bit          : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_Immediate8Bit       : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_EndianMode          : std_logic := '0';
signal IPDR_DataAddrLow         : std_logic_vector(1 downto 0) := (others => '0');

signal IPDR_SignExt			    : std_logic := '0';
signal IPDR_ZeroExt			    : std_logic := '0';
signal IPDR_nB_HW			    : std_logic := '0';

-- Thumb decoder interface
signal IPDR_ToThumbDecoder   : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_FromThumbDecoder : std_logic_vector(31 downto 0) := (others => '0');
signal IPDR_HalfWordAddress  : std_logic := '0';
signal ThDC_ThBLFP           : std_logic := '0';
signal ThDC_ThBLSP			 : std_logic := '0';


-- Address multiplexer and incrementer signals
signal AMI_FromPC		      : std_logic_vector(31 downto 0) := (others => '0');
signal AMI_ToPC			      : std_logic_vector(31 downto 0) := (others => '0');
signal AMI_FromALU		      : std_logic_vector(31 downto 0) := (others => '0');
signal AMI_ExceptionVector    : std_logic_vector(31 downto 0) := (others => '0');

signal AMI_PCInSel		      : std_logic := '0';
signal AMI_ALUInSel		      : std_logic := '0';
signal AMI_ExceptionVectorSel : std_logic := '0';
signal AMI_PCIncStep          : std_logic := '0';
signal AMI_AdrIncStep		  : std_logic := '0';
signal AMI_AdrToPCSel		  : std_logic := '0';
signal AMI_AdrCntEn			  : std_logic := '0';


-- Data out register signals
signal DOR_StoreHalfWord : std_logic := '0';
signal DOR_StoreByte	 : std_logic := '0';

-- Register for shift amount signals
signal RSA_ShLenRsOut : std_logic_vector(7 downto 0) := (others => '0');

-- A bus multiplexer signals
signal ABM_ABusOut            : std_logic_vector(31 downto 0) := (others => '0');
signal ABM_RegFileAOutSel     : std_logic := '0';
signal ABM_MultiplierAOutSel  : std_logic := '0';
signal ABM_CPSROutSel		  : std_logic := '0';
signal ABM_SPSROutSel		  : std_logic := '0';

-- B bus multiplexer signals
signal BBM_BBusOut            : std_logic_vector(31 downto 0) := (others => '0');
signal BBM_RegFileBOutSel	  : std_logic := '0';
signal BBM_MultiplierBOutSel  : std_logic := '0';
signal BBM_MemDataRegOutSel	  : std_logic := '0';
signal BBM_SExtOffset24BitSel : std_logic := '0';
signal BBM_Offset12BitSel	  : std_logic := '0';
signal BBM_Offset8BitSel	  : std_logic := '0';
signal BBM_Immediate8BitSel	  : std_logic := '0';
signal BBM_AdrGenDataSel      : std_logic := '0';

-- Address generator for load/store signals
signal LSAdrGen_BDataOut	  : std_logic_vector(31 downto 0) := (others => '0');
signal LSAdrGen_RegisterList  : std_logic_vector(15 downto 0) := (others => '0');
signal LSAdrGen_IncBeforeSel  : std_logic := '0';
signal LSAdrGen_DecBeforeSel  : std_logic := '0';
signal LSAdrGen_DecAfterSel   : std_logic := '0';
signal LSAdrGen_MltAdrSel	  : std_logic := '0';
signal LSAdrGen_SngMltSel	  : std_logic := '0';


-- Bit 0,1 clearer
signal RBM_DataOut    : std_logic_vector(31 downto 0) := (others => '0');
signal RBM_ClrBitZero : std_logic := '0';
signal RBM_ClrBitOne  : std_logic := '0';
signal RBM_SetBitZero : std_logic := '0';

-- Thumb decoder signals
signal ThDC_ThumbDecoderEn   : std_logic := '0';
attribute mark_debug of ThDC_ThumbDecoderEn : signal is "true";


-- Internal copies of some core outputs
signal ADDR_Int              : std_logic_vector(ADDR'range) := (others => '0');
signal SIZE_Int              : std_logic_vector(SIZE'range) := (others => '0');
signal PREEMPTABLE_Int        : std_logic := '0';

signal BigEndianMode : std_logic := '0';

begin


ALU_Inst:component ALU port map(
	                    ADataIn    => ABM_ABusOut,	 -- Output of A bus multiplexer
						BDataIn    => Shifter_ShOut, -- Output of the shifter
						DataOut    => ALU_DataOut,
						InvA	   => ALU_InvA,
						InvB	   => ALU_InvB,
						PassA	   => ALU_PassA,
						PassB	   => ALU_PassB,
						-- Logic operations
						AND_Op	   => ALU_AND_Op,
						ORR_Op	   => ALU_ORR_Op,
						EOR_Op	   => ALU_EOR_Op,
						-- Flag inputs
						CFlagIn	   => ALU_CFlagIn,
						CFlagUse   => ALU_CFlagUse,
                        ThADR      => ALU_ThADR,
						-- Flag outputs
						CFlagOut   => ALU_CFlagOut,
						VFlagOut   => ALU_VFlagOut,
						NFlagOut   => ALU_NFlagOut,
						ZFlagOut   => ALU_ZFlagOut
				    );

-- Shifter
Shifter_Inst:component Shifter port map(
	                    ShBBusIn   => BBM_BBusOut,       -- Output of B bus multiplexer
						ShOut      => Shifter_ShOut,     -- To ALU
	                    ShCFlagIn  => PSR_CFlagOut,
						ShCFlagOut => ALU_CFlagIn,       -- To ALU
						ShLenRs    => Shifter_ShLenRs,	 -- From shift amount register
						ShLenImm   => Shifter_ShLenImm,	 -- From control logic
						ShType     => Shifter_ShType,	 -- From control logic
						ShRotImm   => Shifter_ShRotImm,	 -- From control logic
						ShEn       => Shifter_ShEn,		 -- From control logic
						ShCFlagEn  => Shifter_ShCFlagEn	 -- From control logic
						);

-- Multiplier
Multiplier_Inst:component Multiplier port map(
						   -- Global signals
	                       nRESET      => nRESET,
						   CLK         => CLK,
						   CLKEN       => CLKEN,
	                       -- Data inputs
	                       ADataIn     => RegFile_ABusOut,
						   BDataIn     => RegFile_BBusOut,
						   -- Data outputs
						   ADataOut    => Mult_ADataOut,
						   BDataOut    => Mult_BDataOut,
						   -- Control inputs
						   LoadRsRm    => Mult_LoadRsRm,
						   LoadPS      => Mult_LoadPS,
						   ClearPSC    => Mult_ClearPSC,
						   UnsignedMul => Mult_UnsignedMul,
						   ReadLH	   => Mult_ReadLH,
						   -- Control outputs
						   MulResRdy   => Mult_MulResRdy
						   );


-- Register file
RegFile_Inst:component RegFile generic map(DebugMode => TRUE)
		               port map(
						-- Global control signals
	                    nRESET         => nRESET,
						CLK            => CLK,
						CLKEN          => CLKEN,
						-- Data buses
						ABusOut        => RegFile_ABusOut,
						BBusOut        => RegFile_BBusOut,
						DataIn         => RBM_DataOut, -- From ALU *
						-- Address an control
						ABusRdAdr      => RegFile_ABusRdAdr,
						BBusRdAdr      => RegFile_BBusRdAdr,
						WriteAdr       => RegFile_WriteAdr,
						WrEn	       => RegFile_WrEn,
						-- Program counter
						PCIn           => RegFile_PCIn,
						PCOut          => RegFile_PCOut,
						PCWrEn         => RegFile_PCWrEn,
						PCSrcSel       => RegFile_PCSrcSel,
						-- Global control
						RFMode         => RegFile_RFMode,
						SaveBaseReg    => RegFile_SaveBaseReg,
						RestoreBaseReg => RegFile_RestoreBaseReg
						);

-- Program status registers
PSR_Inst:component PSR port map(
						-- Global control signals
	                    nRESET    => nRESET,
						CLK       => CLK,
						CLKEN     => CLKEN,
						-- ALU Data in
						DataIn    => ALU_DataOut,
						PSRDInSel => PSR_PSRDInSel,
					    -- Current program state
						CPSRIn    => PSR_CPSRIn,
						CPSRWrEn  => PSR_CPSRWrEn,
						CPSROut   => PSR_CPSROut,
						CFlForMul => PSR_CFlForMul,
						-- Saved program state
						SPSRIn    => PSR_SPSRIn,
	                    SPSROut   => PSR_SPSROut,
						SPSRWrMsk => PSR_SPSRWrMsk,
						-- PSR mode control
						PSRMode   => PSR_PSRMode
						);



IPDR_Inst:component IPDR port map(
	                   -- Clock and reset
				       nRESET               => nRESET,
					   CLK                  => CLK,
					   CLKEN                => CLKEN,
					   -- Memory interface
	                   RDATA                => RDATA,
					   ABORT	            => ABORT,
					   -- Thumb decoder interface
					   ToThumbDecoder		=> IPDR_ToThumbDecoder,
					   FromThumbDecoder		=> IPDR_FromThumbDecoder,
					   HalfWordAddress		=> IPDR_HalfWordAddress,
					   -- Interfaces for the internal CPU modules
					   InstForDecode        => IPDR_InstForDecode,
					   InstFetchAbort       => IPDR_InstFetchAbort,
					   ADDRLow              => IPDR_DataAddrLow,
					   StagnatePipeline	    => IPDR_StagnatePipeline,
					   StagnatePipelineDel	=> IPDR_StagnatePipelineDel,
					   FirstInstFetch		=> IPRD_FirstInstFetch,
					   -- Data out register and control(sign/zero, byte/halfword  extension)
					   DataOut              => IPDR_DataOut,
					   SignExt				=> IPDR_SignExt,
					   ZeroExt				=> IPDR_ZeroExt,
					   nB_HW				=> IPDR_nB_HW,
					   -- Immediate fields out
					   SExtOffset24Bit      => IPDR_SExtOffset24Bit,
                       Offset12Bit          => IPDR_Offset12Bit,
                       Offset8Bit           => IPDR_Offset8Bit,
                       Immediate8Bit        => IPDR_Immediate8Bit,
					   -- Bus control
					   EndianMode           => IPDR_EndianMode
					   );



-- Address register and incrementer
AddressMUX_Incrementer_Inst:component AddressMux_Incrementer port map(
					   -- Clock and reset
				       nRESET            => nRESET,
					   CLK               => CLK,
					   CLKEN             => CLKEN,
	                   -- Address and control
					   ADDR              => ADDR_Int,
				 	   FromPC		     => RegFile_PCOut,	    -- From register file
					   ToPC			     => RegFile_PCIn,	    -- To register file
					   FromALU		     => RBM_DataOut,	-- From ALU *
					   ExceptionVector   => AMI_ExceptionVector,	-- From control logic
					   PCInSel		     => AMI_PCInSel,
					   ALUInSel		     => AMI_ALUInSel,
					   ExceptionVectorSel => AMI_ExceptionVectorSel,
					   PCIncStep         => AMI_PCIncStep,
					   AdrIncStep		 => AMI_AdrIncStep,
					   AdrToPCSel	     => AMI_AdrToPCSel,
					   AdrCntEn	         => AMI_AdrCntEn
					                 );



-- Data out register
DataOutMux_Inst:component DataOutMux port map(
						-- Control signals
						StoreHalfWord => DOR_StoreHalfWord,	 -- From control logic
						StoreByte	  => DOR_StoreByte,		 -- From control logic
						BigEndianMode => BigEndianMode,	     -- From control logic
						-- Data signals
						DataIn        => RegFile_BBusOut,	 -- From the register file
						WDATA         => WDATA               -- Output of the core
						                     );


-- Register for shift amount
ShiftAmountReg_Inst:component ShiftAmountReg port map(
	                   -- Clock and reset
				       nRESET     => nRESET,
					   CLK        => CLK,
					   CLKEN      => CLKEN,
					   -- Data signals
					   ShLenRsIn  => RegFile_ABusOut(7 downto 0), -- From register file
					   ShLenRsOut => Shifter_ShLenRs              -- To shifter
					   );


-- A bus multiplexer
ABusMultiplexer_Inst:component ABusMultiplexer port map(
					   -- Data input
	                   RegFileAOut       => RegFile_ABusOut,
	                   MultiplierAOut    => Mult_ADataOut,
					   CPSROut           => PSR_CPSROut,
					   SPSROut           => PSR_SPSROut,
					   -- Control
					   RegFileAOutSel    => ABM_RegFileAOutSel,
	                   MultiplierAOutSel => ABM_MultiplierAOutSel,
					   CPSROutSel        => ABM_CPSROutSel,
					   SPSROutSel        => ABM_SPSROutSel,
					   -- Data output
					   ABusOut		     => ABM_ABusOut
					          );


-- B bus multiplexer
BBusMultiplexer_Inst:component BBusMultiplexer port map(
					   -- Data input
	                   RegFileBOut       => RegFile_BBusOut,
	                   MultiplierBOut    => Mult_BDataOut,
					   MemDataRegOut     => IPDR_DataOut,         -- From zero or sign extender
					   AdrGenDataOut	 => LSAdrGen_BDataOut,	  -- From the addrerss generator
					   -- Immediate fields
					   SExtOffset24Bit   => IPDR_SExtOffset24Bit, -- From instruction pipeline
                       Offset12Bit       => IPDR_Offset12Bit,	  -- From instruction pipeline
                       Offset8Bit        => IPDR_Offset8Bit,	  -- From instruction pipeline
                       Immediate8Bit     => IPDR_Immediate8Bit,	  -- From instruction pipeline
					   -- Control
					   RegFileBOutSel     => BBM_RegFileBOutSel,     -- Conrol logic
	                   MultiplierBOutSel  => BBM_MultiplierBOutSel,	 -- Conrol logic
					   MemDataRegOutSel   => BBM_MemDataRegOutSel,	 -- Conrol logic
					   SExtOffset24BitSel => BBM_SExtOffset24BitSel, -- Conrol logic
                       Offset12BitSel     => BBM_Offset12BitSel,	 -- Conrol logic
                       Offset8BitSel      => BBM_Offset8BitSel,		 -- Conrol logic
                       Immediate8BitSel   => BBM_Immediate8BitSel,	 -- Conrol logic
					   AdrGenDataSel	  => BBM_AdrGenDataSel,
							   -- Data output
					   BBusOut		     => BBM_BBusOut
					          );



-- Address generator for load/store
LSAdrGen_Inst:component LSAdrGen port map (
						-- Global control signals
	                    nRESET           => nRESET,
						CLK              => CLK,
						CLKEN            => CLKEN,
	                    -- Control and data
						RmDataIn	     => RegFile_BBusOut,     --  !!! was BBM_BBusOut,
						BDataOut	     => LSAdrGen_BDataOut,
						RegisterList     => LSAdrGen_RegisterList,
	                    IncBeforeSel     => LSAdrGen_IncBeforeSel,
	                    DecBeforeSel     => LSAdrGen_DecBeforeSel,
						DecAfterSel      => LSAdrGen_DecAfterSel,
						MltAdrSel	     => LSAdrGen_MltAdrSel,
						SngMltSel	     => LSAdrGen_SngMltSel
						    				);

ResltBitMask_Inst:component ResltBitMask port map(
					   -- Data
	                   DataIn     => ALU_DataOut,
	                   DataOut    => RBM_DataOut,
					   -- Control
					   ClrBitZero => RBM_ClrBitZero,
					   ClrBitOne  => RBM_ClrBitOne,
					   SetBitZero => RBM_SetBitZero
	                                              );


ThumbDecoder_Inst:component ThumbDecoder
	                   port map(
					   InstForDecode   => IPDR_ToThumbDecoder,
					   ExpandedInst	   => IPDR_FromThumbDecoder,
					   HalfWordAddress => IPDR_HalfWordAddress,
					   ThumbDecoderEn  => ThDC_ThumbDecoderEn,
                       StagnatePipeline=> IPDR_StagnatePipeline,
					   ThBLFP          => ThDC_ThBLFP,
                       ThBLSP          => ThDC_ThBLSP,
                       ThADR           => ALU_ThADR,
                       CLK             => CLK,
                       nRESET          => nRESET,
                       CLKEN           => CLKEN
					       );


-- Control logic
ControlLogic_Inst:component ControlLogic port map(
	                   -- Clock and reset
				       nRESET               => nRESET,
					   CLK                  => CLK,
					   CLKEN                => CLKEN,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Control signals commom for several modules
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   BigEndianMode        => BigEndianMode,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Instruction pipeline and data in registers control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Interfaces for the internal CPU modules
					   InstForDecode        => IPDR_InstForDecode,
					   InstFetchAbort       => IPDR_InstFetchAbort,
					   StagnatePipeline	    => IPDR_StagnatePipeline,
					   StagnatePipelineDel	=> IPDR_StagnatePipelineDel,
					   FirstInstFetch		=> IPRD_FirstInstFetch,
					   -- Data out register and control(sign/zero, byte/halfword  extension)
					   SignExt				=> IPDR_SignExt,
					   ZeroExt				=> IPDR_ZeroExt,
					   nB_HW				=> IPDR_nB_HW,
					   -- Bus control
					   EndianMode           => IPDR_EndianMode,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Data output register control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
						StoreHalfWord => DOR_StoreHalfWord,
						StoreByte	  => DOR_StoreByte,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Address multiplexer and incrementer control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   ExceptionVector      => AMI_ExceptionVector,
					   PCInSel		        => AMI_PCInSel,
					   ALUInSel		        => AMI_ALUInSel,
					   ExceptionVectorSel   => AMI_ExceptionVectorSel,
					   PCIncStep            => AMI_PCIncStep,
					   AdrIncStep		    => AMI_AdrIncStep,
					   AdrToPCSel	        => AMI_AdrToPCSel,
					   AdrCntEn             => AMI_AdrCntEn,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- ALU control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					    InvA	   => ALU_InvA,
						InvB	   => ALU_InvB,
						PassA	   => ALU_PassA,
						PassB	   => ALU_PassB,
						-- Logic operations
						AND_Op	   => ALU_AND_Op,
						ORR_Op	   => ALU_ORR_Op,
						EOR_Op	   => ALU_EOR_Op,
						-- Flag inputs
						CFlagUse   => ALU_CFlagUse,
						-- Flag outputs
						CFlagOut    => ALU_CFlagOut,
						VFlagOut    => ALU_VFlagOut,
						NFlagOut    => ALU_NFlagOut,
						ZFlagOut    => ALU_ZFlagOut,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Multiplier control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   LoadRsRm    => Mult_LoadRsRm,
					   LoadPS      => Mult_LoadPS,
					   ClearPSC    => Mult_ClearPSC,
					   UnsignedMul => Mult_UnsignedMul,
					   ReadLH	   => Mult_ReadLH,
					   MulResRdy   => Mult_MulResRdy,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Register file control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					    ABusRdAdr      => RegFile_ABusRdAdr,
						BBusRdAdr      => RegFile_BBusRdAdr,
						WriteAdr       => RegFile_WriteAdr,
						WrEn	       => RegFile_WrEn,
						-- Program counter
						PCWrEn         => RegFile_PCWrEn,
						PCSrcSel       => RegFile_PCSrcSel,
						-- Mode control signals
						RFMode         => RegFile_RFMode,
					   	SaveBaseReg    => RegFile_SaveBaseReg,
                        RestoreBaseReg => RegFile_RestoreBaseReg,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Programm Status Registers control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- ALU bus input control
					   PSRDInSel => PSR_PSRDInSel,
					   -- Current program state
					   CPSRIn    => PSR_CPSRIn,
					   CPSRWrEn  => PSR_CPSRWrEn,
					   CPSROut   => PSR_CPSROut,
					   CFlForMul => PSR_CFlForMul,
					   -- Saved program state
					   SPSRIn    => PSR_SPSRIn,
					   SPSROut   => PSR_SPSROut,
	                   SPSRWrMsk => PSR_SPSRWrMsk,
					   -- PSR mode control
					   PSRMode   => PSR_PSRMode,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Shifter control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--	                   ShCFlagIn  => ,
--					   ShCFlagOut => ,
                       ShLenImm   => Shifter_ShLenImm,
					   ShType     => Shifter_ShType,
					   ShRotImm   => Shifter_ShRotImm,
					   ShEn       => Shifter_ShEn,
					   ShCFlagEn  => Shifter_ShCFlagEn,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Bus A multiplexer control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   RegFileAOutSel    => ABM_RegFileAOutSel,
	                   MultiplierAOutSel => ABM_MultiplierAOutSel,
					   CPSROutSel        => ABM_CPSROutSel,
					   SPSROutSel        => ABM_SPSROutSel,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Bus B multiplexer control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   RegFileBOutSel     => BBM_RegFileBOutSel,
	                   MultiplierBOutSel  => BBM_MultiplierBOutSel,
					   MemDataRegOutSel   => BBM_MemDataRegOutSel,
					   SExtOffset24BitSel => BBM_SExtOffset24BitSel,
                       Offset12BitSel     => BBM_Offset12BitSel,
                       Offset8BitSel      => BBM_Offset8BitSel,
                       Immediate8BitSel   => BBM_Immediate8BitSel,
					   AdrGenDataSel	  => BBM_AdrGenDataSel,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Address generator for Load/Store instructions control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   	RegisterList     => LSAdrGen_RegisterList,
	                    IncBeforeSel     => LSAdrGen_IncBeforeSel,
	                    DecBeforeSel     => LSAdrGen_DecBeforeSel,
						DecAfterSel      => LSAdrGen_DecAfterSel,
						MltAdrSel	     => LSAdrGen_MltAdrSel,
						SngMltSel	     => LSAdrGen_SngMltSel,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Bit 0,1 clear/set control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					    ClrBitZero       => RBM_ClrBitZero,
					    ClrBitOne        => RBM_ClrBitOne,
					   	SetBitZero       => RBM_SetBitZero,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Thumb decoder control
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   ThumbDecoderEn  => ThDC_ThumbDecoderEn,
					   ThBLFP          => ThDC_ThBLFP,
                       ThBLSP          => ThDC_ThBLSP,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Rm[0] input for ARM/Thumb state detection during BX
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   RmBitZero  => RegFile_BBusOut(0),  -- !!! Check A or B bus

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                       -- AddrLow for DataRotator in IPDR
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        Addr        => ADDR_Int,
                        DataAddrLow => IPDR_DataAddrLow,

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- External signals
					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Interrupts
					   nIRQ       => nIRQ,
                       nFIQ       => nFIQ,
					   -- Memory interface
					   ABORT      => ABORT,
   					   WRITE      => WRITE,
                       SIZE       => SIZE_Int,
                       PREEMPTABLE => PREEMPTABLE_Int
					   );


-- Generate CLKEN signal
CLKEN <= not PAUSE;


ADDR <= ADDR_Int;
SIZE <= SIZE_Int;
MODE <= PSR_CPSROut(4 downto 0);
PREEMPTABLE <= PREEMPTABLE_Int;



end Struct;

