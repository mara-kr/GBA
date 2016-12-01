--****************************************************************************************************
-- Control logic for ARM7TDMI-S processor
-- Designed by Ruslan Lepetenok
-- Modified 11.02.2003
-- Version 0.2A
-- LDM/STM state machines have been significantly changed (not tested yet)
--****************************************************************************************************

library	IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use WORK.ARMPackage.all;

entity ControlLogic is port(
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
					   EndianMode           : out std_logic;

					   -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					   -- Data output register control
					   --^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
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
					   AdrIncStep		    : out  std_logic;
					   AdrToPCSel	        : out  std_logic;
					   AdrCntEn				: out std_logic;

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
					   CFlForMul : out  std_logic;
					   -- Saved program state
					   SPSRIn    : out std_logic_vector(31 downto 0);
					   SPSROut   : in  std_logic_vector(31 downto 0);
					   SPSRWrMsk : out std_logic_vector(3 downto 0);
					   -- PSR mode control
					   PSRMode   : out  std_logic_vector(4 downto 0);

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
					   CPSROutSel        : out std_logic;
					   SPSROutSel        : out std_logic;

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
                       SIZE       : out std_logic_vector(1 downto 0)
					   );

end ControlLogic;

architecture RTL of ControlLogic is
attribute mark_debug : string;
attribute mark_debug of InstForDecode : signal is "true";


signal LastAddr     : std_logic_vector(31 downto 0);

-- Saved value of InstForDecode input(valid for the whole time of instruction execution)
signal InstForDecodeLatched  : std_logic_vector(InstForDecode'range) := (others =>'0');
attribute mark_debug of InstForDecodeLatched : signal is "true";

-- Saved abort flag
signal IFAbtStored : std_logic := '0';

alias opcode        : std_logic_vector(3 downto 0) is InstForDecode(24 downto 21);
alias shift_amount  : std_logic_vector(4 downto 0) is InstForDecode(11 downto 7);
alias shift         : std_logic_vector(1 downto 0) is InstForDecode(6 downto 5);
alias rotate        : std_logic_vector(3 downto 0) is InstForDecode(11 downto 8);

alias register_list : std_logic_vector(15 downto 0) is InstForDecode(15 downto 0);

--alias offset24b     : std_logic_vector(23 downto 0) is InstForDecode(23 downto 0);
alias swi_number    : std_logic_vector(23 downto 0) is InstForDecode(23 downto 0);

alias cond          : std_logic_vector(3 downto 0) is InstForDecodeLatched(31 downto 28);
alias Mask          : std_logic_vector(3 downto 0) is InstForDecodeLatched(19 downto 16);

-- Load/store fields !!! TBD
alias U             : std_logic is InstForDecode(23);
alias P             : std_logic is InstForDecode(24);
alias W             : std_logic is InstForDecode(21);

-- Latched 	load/store fields
alias U_Latched     : std_logic is InstForDecodeLatched(23);
alias P_Latched     : std_logic is InstForDecodeLatched(24);
alias W_Latched     : std_logic is InstForDecodeLatched(21);

alias S_Latched     : std_logic is InstForDecodeLatched(20);
alias R_Latched     : std_logic is InstForDecodeLatched(22);

alias L_Latched     : std_logic is InstForDecodeLatched(20); -- '1' - Load / '0' - Store

-- Rgisters
alias Rn  : std_logic_vector(3 downto 0) is InstForDecodeLatched(19 downto 16);
alias Rd  : std_logic_vector(3 downto 0) is InstForDecodeLatched(15 downto 12);
alias Rs  : std_logic_vector(3 downto 0) is InstForDecodeLatched(11 downto 8);
alias Rm  : std_logic_vector(3 downto 0) is InstForDecodeLatched(3 downto 0);
-- Multiplication
alias RdM : std_logic_vector(3 downto 0) is InstForDecodeLatched(19 downto 16);
alias RnM : std_logic_vector(3 downto 0) is InstForDecodeLatched(15 downto 12);
alias RdHi : std_logic_vector(3 downto 0) is InstForDecodeLatched(19 downto 16);
alias RdLo : std_logic_vector(3 downto 0) is InstForDecodeLatched(15 downto 12);

constant SBO : std_logic_vector(3 downto 0) := (others => '1');
constant SBZ : std_logic_vector(3 downto 0) := (others => '0');

signal WriteToPC   : std_logic := '0'; -- Write to R15
signal WriteToHiFl : std_logic := '0'; -- Data processing instruction writes to N,Z,C,V flags of CPSR
signal RestCPSR    : std_logic := '0'; -- Restore CPSR from the appropriate SPSR
signal WriteToCPSR : std_logic := '0'; -- Write to CPSR
signal MulFlWr     : std_logic := '0'; -- Write to Z and C flag by multiplications

-- Instructions

-- Data processing instructions
signal IDC_AND   : std_logic := '0';
signal IDC_EOR   : std_logic := '0';
signal IDC_ORR   : std_logic := '0';
signal IDC_BIC   : std_logic := '0';
signal IDC_TST   : std_logic := '0';
signal IDC_TEQ   : std_logic := '0';
signal IDC_ADD   : std_logic := '0';
signal IDC_ADC   : std_logic := '0';
signal IDC_SUB   : std_logic := '0';
signal IDC_SBC   : std_logic := '0';
signal IDC_RSB   : std_logic := '0';
signal IDC_RSC   : std_logic := '0';
signal IDC_CMP   : std_logic := '0';
signal IDC_CMN   : std_logic := '0';
signal IDC_MOV   : std_logic := '0';
signal IDC_MVN   : std_logic := '0';

-- Multiplications
signal IDC_MUL   : std_logic := '0';
signal IDC_MLA   : std_logic := '0';
signal IDC_UMULL : std_logic := '0';
signal IDC_UMLAL : std_logic := '0';
signal IDC_SMULL : std_logic := '0';
signal IDC_SMLAL : std_logic := '0';

--SPSR Move
signal IDC_MSR_R   : std_logic := '0';   -- Register operand
signal IDC_MSR_I   : std_logic := '0';	 -- Immediate operand
signal IDC_MRS     : std_logic := '0';

-- Branch
signal IDC_B     : std_logic := '0';
signal IDC_BL    : std_logic := '0';
signal IDC_BX    : std_logic := '0';


-- Load
signal IDC_LDR   : std_logic := '0';
signal IDC_LDRT  : std_logic := '0';
signal IDC_LDRB  : std_logic := '0';
signal IDC_LDRBT : std_logic := '0';
signal IDC_LDRSB : std_logic := '0';
signal IDC_LDRH  : std_logic := '0';
signal IDC_LDRSH : std_logic := '0';

signal IDC_LDM    : std_logic := '0'; -- ?? Variants

-- Store
signal IDC_STR   : std_logic := '0';
signal IDC_STRT  : std_logic := '0';
signal IDC_STRB  : std_logic := '0';
signal IDC_STRBT : std_logic := '0';
signal IDC_STRH  : std_logic := '0';

signal IDC_STM    : std_logic := '0'; -- ?? Variants

-- Swap
signal IDC_SWP  : std_logic := '0';
signal IDC_SWPB : std_logic := '0';

signal IDC_SWI  : std_logic := '0';

-- Coprocessor communication instructions
signal IDC_MRC  : std_logic := '0';
signal IDC_MCR  : std_logic := '0';
signal IDC_LDC  : std_logic := '0';
signal IDC_CDP  : std_logic := '0';
signal IDC_STC  : std_logic := '0';

-- Undefined instruction
signal IDC_Undef : std_logic := '0';

-- End of instruction decoder signals


-- Registeres instruction decoder outputs
-- Data processing instructions
signal IDR_AND   : std_logic := '0';
signal IDR_EOR   : std_logic := '0';
signal IDR_ORR   : std_logic := '0';
signal IDR_BIC   : std_logic := '0';
signal IDR_TST   : std_logic := '0';
signal IDR_TEQ   : std_logic := '0';
signal IDR_ADD   : std_logic := '0';
signal IDR_ADC   : std_logic := '0';
signal IDR_SUB   : std_logic := '0';
signal IDR_SBC   : std_logic := '0';
signal IDR_RSB   : std_logic := '0';
signal IDR_RSC   : std_logic := '0';
signal IDR_CMP   : std_logic := '0';
signal IDR_CMN   : std_logic := '0';
signal IDR_MOV   : std_logic := '0';
signal IDR_MVN   : std_logic := '0';

-- Multiplications
signal IDR_MUL   : std_logic := '0';
signal IDR_MLA   : std_logic := '0';
signal IDR_UMULL : std_logic := '0';
signal IDR_UMLAL : std_logic := '0';
signal IDR_SMULL : std_logic := '0';
signal IDR_SMLAL : std_logic := '0';

--SPSR Move
signal IDR_MSR_R   : std_logic := '0';   -- Register operand
signal IDR_MSR_I   : std_logic := '0';	 -- Immediate operand
signal IDR_MRS     : std_logic := '0';

-- Branch
signal IDR_B     : std_logic := '0';
attribute mark_debug of IDR_B : signal is "true";
signal IDR_BL    : std_logic := '0';
attribute mark_debug of IDR_BL : signal is "true";
signal IDR_BX    : std_logic := '0';
attribute mark_debug of IDR_BX : signal is "true";


-- Load
signal IDR_LDR   : std_logic := '0';
signal IDR_LDRT  : std_logic := '0';
signal IDR_LDRB  : std_logic := '0';
signal IDR_LDRBT : std_logic := '0';
signal IDR_LDRSB : std_logic := '0';
signal IDR_LDRH  : std_logic := '0';
signal IDR_LDRSH : std_logic := '0';

signal IDR_LDM    : std_logic := '0'; -- ?? Variants

-- Store
signal IDR_STR   : std_logic := '0';
signal IDR_STRT  : std_logic := '0';
signal IDR_STRB  : std_logic := '0';
signal IDR_STRBT : std_logic := '0';
signal IDR_STRH  : std_logic := '0';

signal IDR_STM    : std_logic := '0'; -- ?? Variants

-- Swap
signal IDR_SWP  : std_logic := '0';
signal IDR_SWPB : std_logic := '0';

signal IDR_SWI  : std_logic := '0';

-- Coprocessor communication instructions
signal IDR_MRC  : std_logic := '0';
signal IDR_MCR  : std_logic := '0';
signal IDR_LDC  : std_logic := '0';
signal IDR_CDP  : std_logic := '0';
signal IDR_STC  : std_logic := '0';

-- Undefined instruction
signal IDR_Undef : std_logic := '0';

-- Thumb branch with link support
signal IDR_ThBLFP   : std_logic := '0'; -- Can appear only in Thumb mode
signal IDR_ThBLSP   : std_logic := '0';	-- Can appear only in Thumb mode

-- End of registeres instruction decoder outputs

-- Instructions groops
-- Arithmetic instructions extension space
signal IDC_ArInstExtSp    :	std_logic := '0'; -- Bit[25](I)='0' and Bit[7](I)='1' and Bit[4](I)='1'

signal IDC_DPIRegSh       :	std_logic := '0'; -- Data processing register shift
signal IDC_DPIImmSh	      :	std_logic := '0'; -- Data processing immediate shift
signal IDC_DPIImmRot      :	std_logic := '0'; -- Data processing immediate(rotate)

signal IDC_LSRegOffset    :	std_logic := '0'; -- Load/store(word/byte) register offset
signal IDC_LSImmOffset    :	std_logic := '0'; -- Load/store(word/byte) immediate offset

signal IDC_LSHWImmOffset  :	std_logic := '0'; -- Load/store(halfword) immediate offset
signal IDC_LSHWRegOffset  :	std_logic := '0'; -- Load/store(halfword) register offset
signal IDC_LHWBSImmOffset :	std_logic := '0'; -- Load signed (halfword/byte) immediate offset
signal IDC_LHWBSRegOffset :	std_logic := '0'; -- Load signed (halfword/byte) register offset

signal IDC_LdStInst       : std_logic := '0';  -- Load/strore single or multiple

signal IDC_Branch         :	std_logic := '0';

signal IDC_Compare        :	std_logic := '0';

signal IDC_DPIArith       :	std_logic := '0'; -- Data processing instructions writing V flag

-- Registered signals

signal IDR_DPIRegSh       :	std_logic := '0';
signal IDR_DPIImmSh	      :	std_logic := '0';
signal IDR_DPIImmRot      :	std_logic := '0';

signal IDR_LSRegOffset    :	std_logic := '0';
signal IDR_LSImmOffset    :	std_logic := '0';

signal IDR_LSHWImmOffset  :	std_logic := '0';
signal IDR_LSHWRegOffset  :	std_logic := '0';
signal IDR_LHWBSImmOffset :	std_logic := '0';
signal IDR_LHWBSRegOffset :	std_logic := '0';

signal IDR_LdStInst       : std_logic := '0';  -- Load/strore single or multiple

signal IDR_Branch         :	std_logic := '0';

signal IDR_Compare        :	std_logic := '0';

signal IDR_DPIArith       :	std_logic := '0';

-- Single cycle data processing instruction
signal IDR_SingleCycleDPI : std_logic := '0';

-- Instruction state machines (cycle count ??)

-- Data processing instruction with shift by Rs (2 cycles - additional cycle for simple DPI)
signal DPIRegSh_St  : std_logic := '0';

-- Data processing/load instruction writes to PC
signal nWrPCSM_St0 : std_logic := '0';
signal WrPCSM_St1  : std_logic := '0';
signal WrPCSM_St2  : std_logic := '0';

-- Load register (3 cycle)
signal nLDR_St0 : std_logic := '0';
signal LDR_St1 : std_logic := '0';
signal LDR_St2 : std_logic := '0';

-- Load multiple registers (up to ? cycle)
signal nLDM_St0 : std_logic := '0';
signal LDM_St1 : std_logic := '0';
signal LDM_St2 : std_logic := '0';

-- Store register (2 cycle)
signal STR_St : std_logic := '0';

-- Load multiple registers (up to ? cycle)
signal STM_St : std_logic := '0';

-- Access to User Mode Registers during LDM/STM (special form - ^)
signal UMRAccess_St : std_logic := '0';
signal LSMUMR    : std_logic := '0'; -- Load/store multiple User Mode Registers

signal UpDBaseRSng : std_logic := '0'; -- Update base register for single load/store

-- TBD

-- Multiplications

-- MUL
signal MUL_St  : std_logic := '0';

-- MLA
signal nMLA_St0 : std_logic := '0';
signal MLA_St1  : std_logic := '0';
signal MLA_St2  : std_logic := '0';

-- SMULL/UMULL
signal nMULL_St0 : std_logic := '0';
signal MULL_St1  : std_logic := '0';
signal MULL_St2  : std_logic := '0';

-- SMLAL/UMLAL
signal nMLAL_St0 : std_logic := '0';
signal MLAL_St1  : std_logic := '0';
signal MLAL_St2  : std_logic := '0';
signal MLAL_St3  : std_logic := '0';

signal BaseRegUdate_St  : std_logic := '0';
signal BaseRegWasUdated_St : std_logic := '0';
signal LSMCycleCnt  : std_logic_vector(4 downto 0) := (others => '0');
type   RegNumCntType is array (0 to 15) of std_logic_vector(4 downto 0);
signal RegNumCnt : RegNumCntType := (others => "00000");

signal LSMStop      : std_logic := '0';
signal LSMStopDel   : std_logic := '0';

-- Next	register address calculation
signal CurrentRgAdr : std_logic_vector (3 downto 0) := (others => '0');
signal FirstRgAdr   : std_logic_vector (3 downto 0) := (others => '0');
type NextRgAdrType is array (0 to 15) of std_logic_vector(3 downto 0);
signal NextRgAdr    : NextRgAdrType := (others => "0000");
signal RgAdr        : NextRgAdrType := (others => "0000");

-- Swap	(4 cycle)
signal nSWP_St0 : std_logic := '0';
signal SWP_St1 : std_logic := '0';
signal SWP_St2 : std_logic := '0';
signal SWP_St3 : std_logic := '0';

-- Branch (3 cycle)
signal nBranch_St0 : std_logic := '0';
signal Branch_St1  : std_logic := '0';
attribute mark_debug of Branch_St1 : signal is "true";
signal Branch_St2  : std_logic := '0';
attribute mark_debug of Branch_St2 : signal is "true";

signal BLink       : std_logic := '0'; -- Link indicator for branch with link

-- Exception state machine
signal ExceptSMStart  : std_logic := '0';
signal nExceptSM_St0  : std_logic := '0';
signal ExceptSM_St1   : std_logic := '0';
signal ExceptSM_St2   : std_logic := '0';

signal ExceptFC		  : std_logic := '0'; -- The first cycle of exception


-- Individual exception start signals
signal DAbtExcStart      : std_logic := '0'; -- Data abort exception start
signal FIQExcStart       : std_logic := '0'; -- FIQ exception start
signal IRQExcStart       : std_logic := '0'; -- IRQ exception start
signal PAbtExcStart      : std_logic := '0'; -- Prefetch abort exception start
signal SWI_UndefExcStart : std_logic := '0'; -- SWI or undefined instruction exception start


-- Latched interrupt request
signal FIQLatched    : std_logic := '0';
signal IRQLatched    : std_logic := '0';

-- Various data aborts
signal DAbtFlag : std_logic := '0';
signal LSAbtOccurred  : std_logic := '0';
signal DAbtStored   : std_logic := '0';

-- New CPSR mode
signal NewMode   : std_logic_vector(4 downto 0) := (others => '0');
signal NewFFlag  : std_logic := '0';
signal NewIFlag  : std_logic := '0';
signal NewTFlag  : std_logic := '0';

-- Pipeline stagnation
signal StagnatePipeline_Int : std_logic := '0';
attribute mark_debug of StagnatePipeline_Int : signal is "true";


-- StagnatePipeline signal delayed by one clock cycle
signal StagnatePipelineDel_Int : std_logic := '0';
attribute mark_debug of StagnatePipelineDel_Int : signal is "true";


-- First instruction fetch after reset
signal FirstInstFetch_Int : std_logic := '0';

-- Pipeline refilling
signal PipelineRefilling :	std_logic := '0';

-- Conditional execution
signal ConditionIsTrue : std_logic := '0';

signal ExecuteInst : std_logic := '0';

alias CPSRNFlag   : std_logic is CPSROut(31);
alias CPSRZFlag   : std_logic is CPSROut(30);
alias CPSRCFlag   : std_logic is CPSROut(29);
alias CPSRVFlag   : std_logic is CPSROut(28);

alias CPSRIFlag   : std_logic is CPSROut(7);
alias CPSRFFlag   : std_logic is CPSROut(6);
alias CPSRTFlag   : std_logic is CPSROut(5);
alias CPSRMode    :	std_logic_vector(4 downto 0) is CPSROut(4 downto 0);

-- CPSR write enable signals
--alias CPSRNFlWE   : std_logic is CPSRWrEn(31);
--alias CPSRZFlWE   : std_logic is CPSRWrEn(30);
--alias CPSRCFlWE   : std_logic is CPSRWrEn(29);
--alias CPSRVFlWE   : std_logic is CPSRWrEn(28);
--alias CPSRTFlWE   : std_logic is CPSRWrEn(5);

signal CPSRNFlWE   : std_logic := '0';
signal CPSRZFlWE   : std_logic := '0';
signal CPSRCFlWE   : std_logic := '0';
signal CPSRVFlWE   : std_logic := '0';
signal CPSRIFlWE   : std_logic := '0';
signal CPSRFFlWE   : std_logic := '0';
signal CPSRTFlWE   : std_logic := '0';

signal CPSRModeWE  : std_logic := '0'; -- Permits write to CPSR[4:0]

-- Internal signals for the flags which can be generated in different ways
signal NewZFlag  : std_logic := '0';

-- Register file control signals(internal copies of outputs)
signal WriteAdr_Int : std_logic_vector(WriteAdr'range);
signal WrEn_Int	    : std_logic := '0';

-- Additional control signals for ALU and A-Bus multiplexer (for exceptions)
signal PassA_Reg             : std_logic := '0';
signal PassB_Reg             : std_logic := '0';

signal RegFileAOutSel_Reg    : std_logic := '0';
signal MultiplierAOutSel_Reg : std_logic := '0';
signal CPSROutSel_Reg        : std_logic := '0';
signal SPSROutSel_Reg        : std_logic := '0';

signal	ClrBitZero_Reg       : std_logic := '0';
signal  ClrBitOne_Reg        : std_logic := '0';
signal	SetBitZero_Reg       : std_logic := '0';

begin

-- *******************************************************************************************
-- Instruction decoder
-- *******************************************************************************************

-- Arithmetic instruction extension space
IDC_ArInstExtSp <= '1' when InstForDecode(25)='0' and InstForDecode(7)='1' and
							InstForDecode(4)='1' else '0';

-- Data processing instructions

IDC_AND <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0000" and
					IDC_ArInstExtSp='0' else '0';

IDC_EOR <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0001" and
					IDC_ArInstExtSp='0' else '0';

IDC_ORR <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="1100" and
					IDC_ArInstExtSp='0' else '0';

IDC_BIC <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="1110" and
					IDC_ArInstExtSp='0' else '0';

IDC_ADD <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0100" and
					IDC_ArInstExtSp='0' else '0';

IDC_ADC <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0101" and
					IDC_ArInstExtSp='0' else '0';

IDC_SUB <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0010" and
					IDC_ArInstExtSp='0' else '0';

IDC_SBC <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0110" and
					IDC_ArInstExtSp='0' else '0';

IDC_RSB <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0011" and
					IDC_ArInstExtSp='0' else '0';

IDC_RSC <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="0111" and
					IDC_ArInstExtSp='0' else '0';

-- Move
IDC_MOV <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="1101" and
					IDC_ArInstExtSp='0' else '0';

IDC_MVN <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 21)="1111" and
					IDC_ArInstExtSp='0' else '0';

-- Instructions which only can change CPSR flags (compare)
IDC_CMP <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 20)="10101" and
					IDC_ArInstExtSp='0' else '0';

IDC_CMN <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 20)="10111" and
					IDC_ArInstExtSp='0' else '0';

IDC_TST <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 20)="10001" and
					IDC_ArInstExtSp='0' else '0';

IDC_TEQ <= '1' when InstForDecode(27 downto 26)="00" and
                    InstForDecode(24 downto 20)="10011" and
					IDC_ArInstExtSp='0' else '0';

-- End of data processing instructions

-- Multiplications
IDC_MUL <= '1' when InstForDecode(27 downto 21)="0000000" and
                    InstForDecode(7 downto 4)="1001" else '0';

IDC_MLA <= '1' when InstForDecode(27 downto 21)="0000001" and
                    InstForDecode(7 downto 4)="1001" else '0';

IDC_UMULL <= '1' when InstForDecode(27 downto 21)="0000100" and
                      InstForDecode(7 downto 4)="1001" else '0';

IDC_UMLAL <= '1' when InstForDecode(27 downto 21)="0000101" and
                      InstForDecode(7 downto 4)="1001" else '0';

IDC_SMULL <= '1' when InstForDecode(27 downto 21)="0000110" and
                      InstForDecode(7 downto 4)="1001" else '0';

IDC_SMLAL <= '1' when InstForDecode(27 downto 21)="0000111" and
                      InstForDecode(7 downto 4)="1001" else '0';

-- Move immediate value to status register(CPSR/SPSR)
-- (works like data processing instruction with immediate)
IDC_MSR_I  <= '1' when InstForDecode(27 downto 23)="00110" and
					   InstForDecode(21 downto 20)="10" else '0';

-- Move register value to status register(CPSR/SPSR)
-- (works like data processing instruction with immediate)
IDC_MSR_R  <= '1' when InstForDecode(27 downto 23)="00010" and
                       InstForDecode(21 downto 20)="10" and
					   InstForDecode(7 downto 4)="0000" else '0';

-- Move status register(CPSR/SPSR) to general purpose register
IDC_MRS  <= '1' when InstForDecode(27 downto 23)="00010" and
                     InstForDecode(21 downto 20)="00" and
                     InstForDecode(7 downto 4)="0000" else '0';

-- Branch
IDC_B    <= '1' when InstForDecode(27 downto 24)="1010" else '0';  -- ?? Merge
IDC_BL   <= '1' when InstForDecode(27 downto 24)="1011" else '0';  -- ?? Merge

IDC_BX   <= '1' when InstForDecode(27 downto 20)="00010010" and
                     InstForDecode(7 downto 4)="0001" else '0';

-- Load
IDC_LDR  <= '1' when InstForDecode(27 downto 26)="01" and
                     InstForDecode(22)='0' and InstForDecode(20)='1' else '0';

-- Load byte !!! TBD
IDC_LDRB  <= '1' when InstForDecode(27 downto 26)="01" and
                      InstForDecode(22)='1' and InstForDecode(20)='1' else '0';

-- Load byte with translation !!! TBD
IDC_LDRBT <= '1' when InstForDecode(27 downto 26)="01" and
                      InstForDecode(24)='0' and
					  InstForDecode(22 downto 20)="111" else '0';

-- Load halfword  !!! TBD
IDC_LDRH <= '1' when InstForDecode(27 downto 25)="000" and
                     InstForDecode(20)='1' and
					 InstForDecode(7 downto 4)="1011" else '0';

-- Load signed byte	!!! TBD
IDC_LDRSB <= '1' when InstForDecode(27 downto 25)="000" and
                      InstForDecode(20)='1' and
			          InstForDecode(7 downto 4)="1101" else '0';

-- Load signed halfword	!!! TBD
IDC_LDRSH <= '1' when InstForDecode(27 downto 25)="000" and
                      InstForDecode(20)='1' and
			          InstForDecode(7 downto 4)="1111" else '0';

-- Load word with translation !!! TBD
IDC_LDRT  <= '1' when InstForDecode(27 downto 26)="01" and
                      InstForDecode(24)='0' and
					  InstForDecode(22 downto 20)="011" else '0';

-- All the types of load multiple registers
IDC_LDM  <= '1' when InstForDecode(27 downto 25)="100" and
                     InstForDecode(20)='1' else '0';

-- Store
IDC_STR <= '1' when InstForDecode(27 downto 26)="01" and
                     InstForDecode(22)='0' and InstForDecode(20)='0' else '0';

-- Store byte !!! TBD
IDC_STRB <= '1' when InstForDecode(27 downto 26)="01" and
                     InstForDecode(22)='1' and InstForDecode(20)='0' else '0';

-- Store byte with translation !!! TBD
IDC_STRBT <= '1' when InstForDecode(27 downto 26)="01" and
                      InstForDecode(24)='0' and
					  InstForDecode(22 downto 20)="110" else '0';

-- Store halfword !!! TBD
IDC_STRH <= '1' when InstForDecode(27 downto 25)="000" and
                     InstForDecode(20)='0' and
					 InstForDecode(7 downto 4)="1011" else '0';

-- Store word with translation !!! TBD
IDC_STRT <= '1' when InstForDecode(27 downto 26)="01" and
                     InstForDecode(24)='0' and
					 InstForDecode(22 downto 20)="010" else '0';

-- All the types of store multiple registers
IDC_STM <= '1' when InstForDecode(27 downto 25)="100" and
                    InstForDecode(20)='0' else '0';

-- Swap word
IDC_SWP <= '1' when InstForDecode(27 downto 20)="00010000" and
                    InstForDecode(7 downto 4)="1001" else '0';
-- Swap byte
IDC_SWPB <= '1' when InstForDecode(27 downto 20)="00010100" and
                     InstForDecode(7 downto 4)="1001" else '0';

-- Software interrupt
IDC_SWI <= '1' when InstForDecode(27 downto 24)="1111" else '0';

-- Coprocessor instructions

IDC_MRC <= '1' when InstForDecode(27 downto 24)="1110" and
                    InstForDecode(20)='1' and InstForDecode(4)='1' else '0';

IDC_MCR <= '1' when InstForDecode(27 downto 24)="1110" and
                    InstForDecode(20)='0' and InstForDecode(4)='1' else '0';

IDC_LDC <= '1' when InstForDecode(27 downto 25)="110" and
                    InstForDecode(20)='1' else '0';

IDC_CDP <= '1' when InstForDecode(27 downto 24)="1110" and
                    InstForDecode(4)='0' else '0';

IDC_STC <= '1' when InstForDecode(27 downto 25)="110" and
                    InstForDecode(20)='0' else '0';


IDC_Undef <= '1' when InstForDecode(27 downto 25)="011" and	  -- TBD
                      InstForDecode(4)='1' else '0';


-- Instruction groops

-- Data processing immediate shift (shift)
IDC_DPIImmSh <= '1' when InstForDecode(27 downto 25)="000" and InstForDecode(4)='0' and
					    not(InstForDecode(24 downto 23)="10" and InstForDecode(20)='0') else '0';

-- Data processing register shift
IDC_DPIRegSh   <= '1' when InstForDecode(27 downto 25)="000" and InstForDecode(7)='0' and InstForDecode(4)='1' and
                  not((InstForDecode(24 downto 23)="10" and InstForDecode(20)='0')or
                      (InstForDecode(7)='1' and InstForDecode(4)='1')) else '0';

-- Data processing immediate (rotate)
IDC_DPIImmRot	<= '1' when InstForDecode(27 downto 25)="001" and
                    not(InstForDecode(24 downto 23)="10" and InstForDecode(20)='0')
				    else '0';

-- Load/store register offset(shift)
IDC_LSRegOffset  <= '1' when InstForDecode(27 downto 25)="011" and
						     InstForDecode(4)='0' else '0';

-- Load/store immediate offset
IDC_LSImmOffset <= '1' when InstForDecode(27 downto 25)="010" else '0';


-- Load/store(halfword) register offset
IDC_LSHWRegOffset <= '1' when InstForDecode(27 downto 25)="000" and
                              InstForDecode(22)='0' and InstForDecode(7 downto 4)="1011"
                              else '0';

-- Load/store(halfword) immediate offset
IDC_LSHWImmOffset <= '1' when InstForDecode(27 downto 25)="000" and
                              InstForDecode(22)='1' and InstForDecode(7 downto 4)="1011"
                              else '0';

-- Load signed (halfword/byte) register offset
IDC_LHWBSRegOffset <= '1' when InstForDecode(27 downto 25)="000" and
                               InstForDecode(22)='0' and
							   InstForDecode(20)='1' and
							   InstForDecode(7 downto 6)="11" and
							   InstForDecode(4)='1'
                               else '0';

-- Load signed (halfword/byte) immediate offset
IDC_LHWBSImmOffset <= '1' when InstForDecode(27 downto 25)="000" and
                               InstForDecode(22)='1' and
							   InstForDecode(20)='1' and
							   InstForDecode(7 downto 6)="11" and
							   InstForDecode(4)='1'
                               else '0';

-- All of the load/store(multiple)
IDC_LdStInst <= IDC_LDR or IDC_LDRT or IDC_LDRB or IDC_LDRBT or IDC_LDRSB or
           IDC_LDRH or IDC_LDRSH or IDC_LDM or IDC_STR or IDC_STRT or
           IDC_STRB or IDC_STRBT or IDC_STRH or IDC_STM;

IDC_Branch <= IDC_B or IDC_BL or IDC_BX;

IDC_Compare <= IDC_TST or IDC_TEQ or IDC_CMP or IDC_CMN;

IDC_DPIArith <= IDC_ADD or IDC_ADC or IDC_SUB or IDC_SBC or
                IDC_RSB or IDC_RSC or IDC_CMP or IDC_CMN;

-- *******************************************************************************************
-- End of the instruction decoder
-- *******************************************************************************************

-- Instruction decoder register
InstrDecoderRegs:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset

 IDR_AND   <= '0';
 IDR_EOR   <= '0';
 IDR_ORR   <= '0';
 IDR_BIC   <= '0';
 IDR_TST   <= '0';
 IDR_TEQ   <= '0';
 IDR_ADD   <= '0';
 IDR_ADC   <= '0';
 IDR_SUB   <= '0';
 IDR_SBC   <= '0';
 IDR_RSB   <= '0';
 IDR_RSC   <= '0';
 IDR_CMP   <= '0';
 IDR_CMN   <= '0';
 IDR_MOV   <= '0';
 IDR_MVN   <= '0';

 IDR_MUL   <= '0';
 IDR_MLA   <= '0';
 IDR_UMULL <= '0';
 IDR_UMLAL <= '0';
 IDR_SMULL <= '0';
 IDR_SMLAL <= '0';

 IDR_MSR_R <= '0';
 IDR_MSR_I <= '0';
 IDR_MRS   <= '0';

 IDR_B     <= '0';
 IDR_BL    <= '0';
 IDR_BX    <= '0';

 IDR_LDR   <= '0';
 IDR_LDRT  <= '0';
 IDR_LDRB  <= '0';
 IDR_LDRBT <= '0';
 IDR_LDRSB <= '0';
 IDR_LDRH  <= '0';
 IDR_LDRSH <= '0';

 IDR_LDM   <= '0';

 IDR_STR   <= '0';
 IDR_STRT  <= '0';
 IDR_STRB  <= '0';
 IDR_STRBT <= '0';
 IDR_STRH  <= '0';

 IDR_STM   <= '0';

 IDR_SWP   <= '0';
 IDR_SWPB  <= '0';

 IDR_SWI   <= '0';

 IDR_MRC   <= '0';
 IDR_MCR   <= '0';
 IDR_LDC   <= '0';
 IDR_CDP   <= '0';
 IDR_STC   <= '0';

 -- Thumb branch with link support
 IDR_ThBLFP <= '0';
 IDR_ThBLSP <= '0';

 IDR_Undef <= '0';

 -- Instruction groops
 IDR_DPIRegSh    <= '0';
 IDR_DPIImmSh	 <= '0';
 IDR_DPIImmRot   <= '0';
 IDR_LSRegOffset <= '0';
 IDR_LSImmOffset <= '0';
 IDR_LSHWImmOffset <= '0';
 IDR_LSHWRegOffset <= '0';
 IDR_LHWBSImmOffset <= '0';
 IDR_LHWBSRegOffset <= '0';
 IDR_LdStInst <= '0';
 IDR_SingleCycleDPI  <=	'0';
 IDR_Branch <= '0';
 IDR_Compare <= '0';
 IDR_DPIArith <= '0';

-- Stored instruction and it's abort indicator
 InstForDecodeLatched <= ( others => '0');
 IFAbtStored <= '0';

-- External interrupt requests syncronization with instruction execution
 FIQLatched <= '0';
 IRQLatched <= '0';

elsif CLK='1' and CLK'event then  -- Clock
 if StagnatePipeline_Int='0' and CLKEN='1' then   -- Clock enable

 IDR_AND   <= IDC_AND;
 IDR_EOR   <= IDC_EOR;
 IDR_ORR   <= IDC_ORR;
 IDR_BIC   <= IDC_BIC;
 IDR_TST   <= IDC_TST;
 IDR_TEQ   <= IDC_TEQ;
 IDR_ADD   <= IDC_ADD;
 IDR_ADC   <= IDC_ADC;
 IDR_SUB   <= IDC_SUB;
 IDR_SBC   <= IDC_SBC;
 IDR_RSB   <= IDC_RSB;
 IDR_RSC   <= IDC_RSC;
 IDR_CMP   <= IDC_CMP;
 IDR_CMN   <= IDC_CMN;
 IDR_MOV   <= IDC_MOV;
 IDR_MVN   <= IDC_MVN;

 IDR_MUL   <= IDC_MUL;
 IDR_MLA   <= IDC_MLA;
 IDR_UMULL <= IDC_UMULL;
 IDR_UMLAL <= IDC_UMLAL;
 IDR_SMULL <= IDC_SMULL;
 IDR_SMLAL <= IDC_SMLAL;

 IDR_MSR_R <= IDC_MSR_R;
 IDR_MSR_I <= IDC_MSR_I;
 IDR_MRS   <= IDC_MRS;

 IDR_B     <= IDC_B;
 IDR_BL    <= IDC_BL;
 IDR_BX    <= IDC_BX;

 IDR_LDR   <= IDC_LDR;
 IDR_LDRT  <= IDC_LDRT;
 IDR_LDRB  <= IDC_LDRB;
 IDR_LDRBT <= IDC_LDRBT;
 IDR_LDRSB <= IDC_LDRSB;
 IDR_LDRH  <= IDC_LDRH;
 IDR_LDRSH <= IDC_LDRSH;

 IDR_LDM   <= IDC_LDM;

 IDR_STR   <= IDC_STR;
 IDR_STRT  <= IDC_STRT;
 IDR_STRB  <= IDC_STRB;
 IDR_STRBT <= IDC_STRBT;
 IDR_STRH  <= IDC_STRH;

 IDR_STM   <= IDC_STM;

 IDR_SWP   <= IDC_SWP;
 IDR_SWPB  <= IDC_SWPB;

 IDR_SWI   <= IDC_SWI;

 IDR_MRC   <= IDC_MRC;
 IDR_MCR   <= IDC_MCR;
 IDR_LDC   <= IDC_LDC;
 IDR_CDP   <= IDC_CDP;
 IDR_STC   <= IDC_STC;

 -- Thumb branch with link support
 IDR_ThBLFP <= ThBLFP;
 IDR_ThBLSP <= ThBLSP;

 IDR_Undef <= IDC_Undef;

 -- Instruction groops
 IDR_DPIRegSh    <= IDC_DPIRegSh;
 IDR_DPIImmSh	 <= IDC_DPIImmSh;
 IDR_DPIImmRot   <= IDC_DPIImmRot;
 IDR_LSRegOffset <= IDC_LSRegOffset;
 IDR_LSImmOffset <= IDC_LSImmOffset;

 IDR_LSHWImmOffset <= IDC_LSHWImmOffset;
 IDR_LSHWRegOffset <= IDC_LSHWRegOffset;
 IDR_LHWBSRegOffset <= IDC_LHWBSRegOffset;
 IDR_LHWBSImmOffset <= IDC_LHWBSImmOffset;

 IDR_LdStInst <= IDC_LdStInst;

 IDR_SingleCycleDPI  <=  IDC_DPIImmSh or IDC_DPIImmRot;

 IDR_Branch <= IDC_Branch;
 IDR_Compare <= IDC_Compare;

 IDR_DPIArith <= IDC_DPIArith;

 -- Stored instruction and it's abort indicator
 InstForDecodeLatched <= InstForDecode;
 IFAbtStored <= InstFetchAbort;

-- External interrupt requests syncronization with instruction execution
 FIQLatched <= not nFIQ;
 IRQLatched <= not nIRQ;

 end if;
end if;
end process;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Shifter control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


ShifterCtrl:process(nRESET,CLK)
begin
if nRESET='0' then             -- Reset

ShLenImm   <= (others => '0');
ShType     <= (others => '0');
ShRotImm   <= '0';
ShEn       <= '0';
ShCFlagEn  <= '0';

elsif CLK='1' and CLK'event then            -- Clock
 if CLKEN='1' then                          -- Clock enable

case StagnatePipeline_Int is
 -- Beginning of the new instruction
 when '0' =>

  if ExceptFC='1' then  -- First cycle of exception

   if CPSRTFlag='0' or           -- CPU in ARM mode
 	  DAbtExcStart ='1' then     -- Data abort
 	  -- Shifter is disabled
	  ShEn       <= '0';
      ShCFlagEn  <= '0';
    else
      -- LSR by 1 (4>>1=2)
	  ShType     <= "010";
      ShRotImm   <= '0';
      ShEn       <= '1';
      ShCFlagEn  <= '0';
      ShLenImm <= "00001";
	end if;

	else              -- No exception

   if Branch_St1='1' then
	-- LR=LR-4(ARM)/LR=LR-2(Thumb)
      if CPSRTFlag='1' then  -- Thumb mode
	  ShType     <= "010"; -- LSR by immediate
      ShRotImm   <= '0';
      ShEn       <= '1';
      ShCFlagEn  <= '0';
      ShLenImm <= "00001"; -- Shift right by one
	  else
      -- ARM mode - disable shifter
	  ShEn       <= '0';
      ShCFlagEn  <= '0';
	  end if;

  elsif ThBLFP='1' and CPSRTFlag='1' then
      -- Thumb BL the first part LR<=PC+(SignExtend(offset_11)<<12)
	  ShType     <= "000"; -- LSL by immediate
      ShRotImm   <= '0';
      ShEn       <= '1';
      ShCFlagEn  <= '0';
      ShLenImm <= "01100";  -- Shift amount=12

  elsif ThBLSP='1' and CPSRTFlag='1' then
      -- Thumb BL the second part PC<=LR+(SignExtend(offset_11)<<1)|1
	  ShType     <= "000"; -- LSL by immediate
      ShRotImm   <= '0';
      ShEn       <= '1';
      ShCFlagEn  <= '0';
      ShLenImm <= "00001";  -- Shift amount=1

  elsif IDC_B = '1' or (IDC_BL = '1' and CPSRTFlag='0') then
      -- Branch or branch with link (destination address calculation)
	  ShType     <= "000"; -- LSL by immediate
      ShRotImm   <= '0';
      ShEn       <= '1';
      ShCFlagEn  <= '0';
      -- Shift amount depends on mode(ARM/Thumb)
     if CPSRTFlag='0' then ShLenImm <= "00010"; -- ARM mode
      else ShLenImm <= "00001";				    -- Thumb mode
     end if;

  elsif (IDC_SWP or IDC_SWPB)='1' then  -- Swap/Swap byte
    ShEn       <= '0';  -- Disable shifter
    ShCFlagEn  <= '0';

  else
  -- All other cases: data processing instructions, address calculations
  ShLenImm   <= shift_amount;
  ShType     <= shift&InstForDecode(4);
  ShRotImm   <= IDC_DPIImmRot or IDC_MSR_I; -- Data processing immediate or move immediate to status register
  ShEn       <= IDC_DPIImmSh or IDC_DPIImmRot or IDC_DPIRegSh or
                IDC_LSRegOffset or IDC_MSR_I;
  ShCFlagEn  <= IDC_MOV or IDC_MVN or IDC_TST or IDC_TEQ or IDC_ORR or IDC_EOR or
                IDC_ORR or IDC_BIC or IDC_LSRegOffset; -- Instructions which produce shifter carry out
  end if;
 end if;

 -- Changes of data path control within the instruction
 when '1' =>
   if LDR_St1='1' or LDM_St1='1' then -- The third cycle of load instruction
     ShEn <= '0';
   end if;

 when others => null;
 end case;

  end if;
end if;
end process;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Multiplier control (combinatorial)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

LoadRsRm <= (IDR_MUL and ExecuteInst and not MUL_St)or                      -- Start for MUL
            ((IDR_SMULL or IDR_UMULL)  and ExecuteInst and not nMULL_St0)or	-- Start for SMULL/UMULL
            MLA_St1 or MLAL_St1;											-- Start for MLA/SMLAL/UMLAL

UnsignedMul <= IDR_UMULL or IDR_UMLAL;
ReadLH <= MULL_St2 or MLAL_St3;                         -- Read bits 63:32 of Partial Sum/Carry

LoadPS <= (IDR_MLA and ExecuteInst and not nMLA_St0)or 	-- Load Partial Sum (for accumulation)
	      ((IDR_SMLAL or IDR_UMLAL) and ExecuteInst and not nMLAL_St0);

ClearPSC <= ((MUL_St or MLA_St2)and MulResRdy)or MULL_St2 or MLAL_St3; -- Clear Partial Sum/Carry after any multiplication

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- ALU control register	(Only data processing instructions are implemented now)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ALUCtrl:process(nRESET,CLK)
begin
if nRESET='0' then             -- Reset
 InvA <= '0';
 InvB <= '0';
 PassA_Reg <= '0';
 PassB_Reg <= '0';

 AND_Op <= '0';
 ORR_Op <= '0';
 EOR_Op <= '0';

 CFlagUse <= '0';

elsif CLK='1' and CLK'event then  -- Clock
 if  CLKEN='1' then                -- Clock enable

 case StagnatePipeline_Int is
  when '0' =>

 if ExceptFC='1' then  -- First cycle of exception

  if CPSRTFlag='0' or            -- Start of any exception when CPU is in ARM mode
     (SWI_UndefExcStart='1' and  -- Undefined instruction or SWI
	  CPSRTFlag='1') then	     -- CPU is in Thumb mode

   -- LR<=LR-4 / LR<=LR-2
   InvA <= '0';
   InvB <= '1';
   PassA_Reg <= '0';
   PassB_Reg <= '0';
   AND_Op <= '0';
   ORR_Op <= '0';
   EOR_Op <= '0';
   CFlagUse <= '0';

 elsif (PAbtExcStart='1' or          -- Prefetch abort
        FIQExcStart='1' or           -- FIQ
        IRQExcStart='1')and          -- IRQ
	      CPSRTFlag='1' then 	     -- CPU is in Thumb mode

  -- LR <= LR
   InvA <= '0';
   InvB <= '0';
   PassA_Reg <= '1';
   PassB_Reg <= '0';
   AND_Op <= '0';
   ORR_Op <= '0';
   EOR_Op <= '0';
   CFlagUse <= '0';

   elsif DAbtExcStart ='1' and        -- Data abort
  		 CPSRTFlag='1' then           -- CPU is in Thumb mode

  -- LR <= LR+2
   InvA <= '0';
   InvB <= '0';
   PassA_Reg <= '0';
   PassB_Reg <= '0';
   AND_Op <= '0';
   ORR_Op <= '0';
   EOR_Op <= '0';
   CFlagUse <= '0';

   end if;

  else  -- No exception

  if Branch_St1='1' then
  -- LR=LR-4(ARM)/LR=LR-2(Thumb)
  PassA_Reg <= '0';
  InvB <= '1';

  elsif ((IDR_B or IDR_BL or (IDR_ThBLFP and CPSRTFlag)) and ExecuteInst)='1' then
  -- LR=PC
   PassA_Reg <= '1';

  elsif IDC_BX='1' then
   -- Branch with exchange
   InvA <= '0';
   InvB <= '0';
   PassA_Reg <= '0';
   PassB_Reg <= '1'; -- Rm !!!
   AND_Op <= '0';
   ORR_Op <= '0';
   EOR_Op <= '0';
   CFlagUse <= '0';

   -- Load/store memory address calculation (post-indexed mode : ADDR=Rm)
   elsif (IDC_SWP or IDC_SWPB)='1' or                      -- Swap/Swap byte
   (IDC_LDRT or IDC_LDRBT or IDC_STRT or IDC_STRBT)='1' or -- Instructions which are always post-index
   ((IDC_LDR or IDC_LDRB or IDC_LDRH or IDC_LDRSB or IDC_LDRSH or IDC_LDM or
    IDC_STR or IDC_STRB or IDC_STRH or IDC_STM)='1' and P='0') then  -- Post-indexed

   InvA <= '0';
   InvB <= '0';
   PassA_Reg <= '1'; --
   PassB_Reg <= '0';
   AND_Op <= '0';
   ORR_Op <= '0';
   EOR_Op <= '0';
   CFlagUse <= '0';

   elsif
    ((IDC_LDR or IDC_LDRB or IDC_LDRH or IDC_LDRSB or IDC_LDRSH or IDC_LDM or
      IDC_STR or IDC_STRB or IDC_STRH or IDC_STM)='1' and P='1') then  -- Pre-indexed
   -- Load/store memory address calculation (pre-indexed mode  ADDR=Rm+/- offset)
   InvA <= '0';
   InvB <= not U; -- U=1 - add, U=0 subtract
   PassA_Reg <= '0';
   PassB_Reg <= '0';
   AND_Op <= '0';
   ORR_Op <= '0';
   EOR_Op <= '0';
   CFlagUse <= '0';

   else
	-- Data processing instructions with /multiplications and branches/ !!! Check
     InvA <= IDC_RSB or IDC_RSC;
     InvB <= IDC_SUB or IDC_SBC or IDC_MVN or IDC_BIC or IDC_CMP;
     PassA_Reg <= '0'; -- !!!!
     PassB_Reg <= IDC_MOV or IDC_MVN or IDC_MSR_I or IDC_MSR_R;
     AND_Op <= IDC_TST or IDC_AND or IDC_BIC;
     ORR_Op <= IDC_ORR ;
     EOR_Op <= IDC_TEQ or IDC_EOR;
     CFlagUse <= IDC_ADC or IDC_SBC or IDC_RSC;
   end if;
   end if;

  when '1' =>
    -- Changes of data path control within the instruction

 if ((MULL_St1 or MLAL_St2) and MulResRdy)='1' then
  -- The last cycle of long multiplication/accumulation(high part of 64-bit)
	 CFlagUse <= '1';

   elsif IDR_LdStInst='1' and (nLDR_St0='0' and nLDM_St0='0' and STR_St='0' and STM_St='0') then
   	-- Base update(second cycle of any load/store)
    InvB <= not U_Latched; -- U=1 - add, U=0 subtract
    PassA_Reg <= '0';

   elsif LDR_St1='1' or LDM_St1='1' or SWP_St1='1' then -- The second cycle of load instruction
    -- Write data from data in register to general purpose register
	PassA_Reg <= '0'; -- !!!!
	InvB <= '0';
	PassB_Reg <= '1';

 end if;

  when others => null;
 end case;

  end if;
end if;
end process;

PassA <= '1' when ExceptFC='1' else PassA_Reg; -- First cycle of exception (LR<=PC)
PassB <= '0' when ExceptFC='1' else PassB_Reg;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Bus A multiplexer control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

BusAMUXCtrl:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 RegFileAOutSel_Reg <= '0';
 MultiplierAOutSel_Reg <= '0';
 CPSROutSel_Reg <= '0';
 SPSROutSel_Reg <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable

case StagnatePipeline_Int is
	-- Beginning of the new instruction or pipeline refilling(branch/exception)
	when '0' =>

	if ((IDR_B or IDR_BL or (IDR_ThBLFP and CPSRTFlag)) and ExecuteInst)='1' or
		Branch_St1='1' then

	  -- Branch (the first and the second cycle)
	 RegFileAOutSel_Reg <= '1';
    else

	RegFileAOutSel_Reg <= IDC_DPIImmSh or IDC_DPIRegSh or IDC_DPIImmRot or
	                      IDC_LSImmOffset or IDC_LSRegOffset or
	                      IDC_LSHWImmOffset or IDC_LSHWRegOffset or
					      IDC_LHWBSImmOffset or IDC_LHWBSRegOffset or
					      IDC_LDM or IDC_STM or
					      IDC_Branch or         -- B/BL/BX
						  IDC_SWP or IDC_SWPB;	-- SWP/SWPB

    MultiplierAOutSel_Reg <= (IDC_MUL or IDC_MLA or IDC_UMULL or IDC_UMLAL or IDC_SMULL or IDC_SMLAL);
    CPSROutSel_Reg <= IDC_MRS and not InstForDecode(22); -- Move CPSR to GPR
    SPSROutSel_Reg <= IDC_MRS and InstForDecode(22); 	 -- Move SPSR to GPR

	end if;

	-- Changes of data path control within the instruction
	when '1' => null;

	when others => null;
end case;

 end if;
end if;
end process;

 RegFileAOutSel <= '1' when ExceptFC='1' else RegFileAOutSel_Reg; -- First cycle of exception (LR<=PC)
 MultiplierAOutSel <= '0' when ExceptFC='1' else MultiplierAOutSel_Reg;
 CPSROutSel <= '0' when ExceptFC='1' else CPSROutSel_Reg;
 SPSROutSel <= '0' when ExceptFC='1' else SPSROutSel_Reg;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Bus B multiplexer control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

BusBMUXCtrl:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset

 RegFileBOutSel     <= '0';
 MultiplierBOutSel  <= '0';
 MemDataRegOutSel   <= '0';
 SExtOffset24BitSel <= '0';
 Offset12BitSel     <= '0';
 Offset8BitSel      <= '0';
 Immediate8BitSel   <= '0';
 AdrGenDataSel      <= '0';

elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable

case StagnatePipeline_Int is
	-- Beginning of the new instruction or pipeline refilling(branch/exception)
	when '0' =>

 if ExceptFC='1' or Branch_St1='1' then -- TBD??
   -- LR correction
   RegFileBOutSel     <= '0';
   MultiplierBOutSel  <= '0';
   MemDataRegOutSel   <= '0';
   SExtOffset24BitSel <= '0';
   Offset12BitSel     <= '0';
   Offset8BitSel      <= '0';
   Immediate8BitSel   <= '0';
   AdrGenDataSel      <= '1';

 else

    RegFileBOutSel     <= IDC_DPIImmSh or IDC_DPIRegSh or
	                      IDC_LSRegOffset or IDC_LSHWRegOffset or IDC_LHWBSRegOffset or
	                      IDC_MSR_R or IDC_BX; -- !!! TBD

	MultiplierBOutSel  <= IDC_MUL or IDC_MLA or IDC_UMULL or IDC_UMLAL or IDC_SMULL or IDC_SMLAL;
    MemDataRegOutSel   <= '0';
    SExtOffset24BitSel <= IDC_B or IDC_BL;
    Offset12BitSel     <= IDC_LSImmOffset;
    Offset8BitSel      <= IDC_LHWBSImmOffset or IDC_LSHWImmOffset;
    Immediate8BitSel   <= IDC_DPIImmRot or IDC_MSR_I;
    AdrGenDataSel      <= IDC_LDM or IDC_STM;

  end if;

   -- Changes of data path control within the instruction
	when '1' =>

 if LDR_St1='1' or LDM_St1='1' then
   -- The third cycle of load instruction (write to GPR)
   RegFileBOutSel     <= '0';
   MultiplierBOutSel  <= '0';
   MemDataRegOutSel   <= '1';
   SExtOffset24BitSel <= '0';
   Offset12BitSel     <= '0';
   Offset8BitSel      <= '0';
   Immediate8BitSel   <= '0';
   AdrGenDataSel      <= '0';

elsif (((IDR_LSRegOffset or IDR_LSHWRegOffset) and not L_Latched and not STR_St)or
      (IDR_STM and not STM_St))='1' then
-- Store instruction with register offset or store multiple (second cycle - base update)

   RegFileBOutSel     <= '0';
   MultiplierBOutSel  <= '0';
   MemDataRegOutSel   <= '0';
   SExtOffset24BitSel <= '0';
   Offset12BitSel     <= '0';
   Offset8BitSel      <= '0';
   Immediate8BitSel   <= '0';
   AdrGenDataSel      <= '1';
 end if;

	when others => null;
end case;

 end if;
end if;
end process;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- -- Bit 0,1 clear/set control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ResultBitMask:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 ClrBitZero_Reg <= '0';
 ClrBitOne_Reg <= '0';
 SetBitZero_Reg <='0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable

case StagnatePipeline_Int is
	-- Beginning of the new instruction or pipeline refilling(branch/exception)
	when '0' =>

	if ExceptFC='1' or Branch_St1='1' then -- TBD (Thumb BL?)
	ClrBitZero_Reg <= '0';
    ClrBitOne_Reg <= '0';
	SetBitZero_Reg <= '0';
     else
	-- Clears bits[1..0] during address phase of LDM/STM/STR !!! TBD
   ClrBitZero_Reg <= IDC_STR or IDC_STM or IDC_LDM;
   ClrBitOne_Reg <= (IDC_STR or IDC_STM or IDC_LDM) and not (IDR_BL and CPSRTFlag and ExecuteInst);
   SetBitZero_Reg <= (IDR_BL and CPSRTFlag and ExecuteInst); -- Thumb BL support added(the second part of instruction)
    end if;

	when '1' => null;
    -- Changes of data path control within the instruction
	ClrBitZero_Reg <= '0';
    ClrBitOne_Reg <= '0';
	SetBitZero_Reg <= '0';

	when others => null;
end case;

 end if;
end if;
end process;

ClrBitZero <= '0' when ExceptFC='1' else ClrBitZero_Reg;
ClrBitOne  <= '0' when ExceptFC='1' else ClrBitOne_Reg;
SetBitZero <= '0' when ExceptFC='1' else SetBitZero_Reg;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Address multiplexer and incrementer control (combinatorial) !!! TBD
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- TBD
PCInSel	<= LDR_St1 or(LDR_St2 and not WriteToPC) or -- LDR last two cycles (merged IS cycle)
		   STR_St or                -- STR
		   (STM_St and LSMStop)or   -- STM last cycle
--		   (LDM_St1 and LSMStop)or(LDM_St2 and LSMStopDel and not WriteToPC)or  -- LDM last cycle  !!! Modify !!!
		   (nLDM_St0 and (LSMStop or (LSMStopDel and not WriteToPC)))or -- LDM (merged IS cycle)
           SWP_St2 or SWP_St3;		-- SWP/SWPB last two cycles (merged IS cycle) ???

ALUInSel <= WriteToPC or                                 -- Write to PC
			((IDR_Branch or(IDR_ThBLFP and CPSRTFlag))and ExecuteInst and not nBranch_St0)or -- First cycle of B,BL,BX
            (IDR_LdStInst and ExecuteInst and not(STR_St or nLDR_St0 or nLDM_St0 or STM_St))or -- First cycle of any load/store
			((IDR_SWP or IDR_SWPB) and ExecuteInst and not nSWP_St0)or -- SWP/SWPB (Load)
			SWP_St1;												   -- SWP/SWPB (Store)

AdrCntEn <= not StagnatePipeline_Int or  -- Address counter is enabled during load/store multiple
            IDR_STM or STM_St or
            IDR_LDM or nLDM_St0;

ExceptionVectorSel <= ExceptFC;  -- First cycle of exception handling


-- TBD  '0'- ARM(+4) / '1'- Thumb(+2)
PCIncStep  <= (CPSRTFlag or (IDR_BX and RmBitZero and (not CPSRTFlag)));
-- TBD  '0'- ARM(+4) or STM/LDM / '1'- Thumb(+2)
AdrIncStep <= ((CPSRTFlag and (not (IDR_BX and (not RmBitZero) and -- THUMB & ~(Transfer to ARM)
                                    (not Branch_St1) and (not Branch_St2)))) or
              (IDR_BX and RmBitZero)) and                            -- Transfer to THUMB
              (not (IDR_STM and StagnatePipeline_Int and ExecuteInst)) and
              (not (IDR_LDM and StagnatePipeline_Int and ExecuteInst));

-- Switch ADDR register to the input of PC
AdrToPCSel <=  ExceptFC or -- First cycle of interrupt entering
 			   Branch_St1;                            -- Second cycle of branch

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Register file control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Combinatorial rgister address control (controled from the execution stage of the pipeline)!!! TBD !!!
ABusRdAdr <= CR_PC	when ((IDR_B or IDR_BL or (IDR_ThBLFP and CPSRTFlag)) and ExecuteInst)='1' or Branch_St1='1' or ExceptFC='1' else -- *
	         CR_LR	when Branch_St2='1' or ExceptSM_St1='1' else -- LR correction (BL/Exception)
             Rs when (IDR_DPIRegSh='1' and DPIRegSh_St='0')or(IDR_MUL or IDR_SMULL or IDR_UMULL or nMLA_St0 or nMLAL_St0)='1' else -- Rs ( The first cycle of "Data processing register shift")
			 Rn;                           -- Rn

-- * Note PC(R15) (target address calculation for B/BL) or store PC to LR (BL/Exception)
-- Thumb BL support added (the first part)

BBusRdAdr <= CurrentRgAdr when STM_St ='1' else	 -- Store multiple
             RnM when ((IDR_MLA and not nMLA_St0)or((IDR_UMLAL or IDR_SMLAL)and not nMLAL_St0))='1' or STR_St='1' else -- Rn/RdLo only for accumulation (MLA/SMLAL/UMLAL), Rd - for STR
             Rm;           -- Rm

WriteAdr_Int <= CurrentRgAdr when LDM_St2 ='1' else	 -- Load multiple
	            CR_LR when nBranch_St0='1' or ExceptFC='1' or ExceptSM_St1='1' or (IDR_ThBLFP='1' and CPSRTFlag='1' and ExecuteInst='1') else  -- *
				RdM when (MUL_St or MLA_St2 or MULL_St2 or MLAL_St3)='1' or (LDM_St1 or STM_St or LDR_St1 or STR_St)='1' else -- Rd for	32-bit/RdHi for 64-bit multiplications / Base Register for LDM/STM
				RnM	when (MULL_St1 or MLAL_St2)='1' else                      -- RdLo for 64-bit multiplications
				Rd;            -- Rd

-- * Note: 	   !!! check if presence of nExceptSM_St0='0' is necessary for this equation
--                       Branch                     Exception
-- Store  LR		   Second cycle					First cycle
-- Modify LR		   Third cycle                  Second cycle
--
-- Thumb BL support added (the first part)

-- Write enable for the general purpose register file
WrEn_Int <= '1' when (((IDR_SingleCycleDPI and ExecuteInst)or DPIRegSh_St)and not IDR_Compare)='1' or
					 ((((MUL_St or MLA_St2 or MULL_St1 or MLAL_St2)and MulResRdy) or MULL_St2 or MLAL_St3))='1' or -- Multiplications results
					 (IDR_MRS and ExecuteInst)='1' or  -- Move PSR to GPR
					 (ExceptFC or ExceptSM_St1)='1' or -- Exception : LR<=PC, LR correction
					 BLink='1' or				       -- BL : LR<=PC, LR correction
                     (BaseRegUdate_St='1' and ABORT='0') or --  Base register update for load/store
                     (LDR_St2='1' and DAbtStored='0')or                 -- LDR
					 (LDM_St2='1' and DAbtStored='0' and LSAbtOccurred='0')or	-- LDM
					 SWP_St2='1' -- SWP/SWPB
					 else '0';

-- PC control
PCSrcSel <= WriteToPC; -- 0 -> the incrementer, 1 -> external input bus !!! TBD
PCWrEn <= '0' when FirstInstFetch_Int='0' or -- First instruction fetch after reset
                   StagnatePipelineDel_Int='1' or   -- Stop PC for multicycle instructions ??? TBD
				  (IDR_BL='1' and ExecuteInst='1')or -- First cycle of branch with link (ARM mode) TBD??
                  (IDR_ThBLSP='1' and CPSRTFlag='1' and ExecuteInst='1') -- First cycle of branch with link (Thumb mode) TBD??
				   else '1';

-- Base register save/restore for load/store multiple
SaveBaseReg    <= BaseRegUdate_St;
RestoreBaseReg <= ((LDM_St2 and LSMStopDel)or(STM_St and LSMStop))and
                  LSAbtOccurred and BaseRegWasUdated_St;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Address generator for Load/Store instructions control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Load/Store multiple registers(LDM/STM) start address and base register update calculation TBD
RegisterList <= InstForDecode(15 downto 0);
IncBeforeSel <= '1' when (U='1' and P='1') or  --  Selects 4 for : Load/store
                         ExceptFC='1' or  -- Start of exceptions (for LR correction)
						 Branch_St1='1' else '0'; -- Branch with link (for LR correction)

DecBeforeSel <=	'1' when U='0' and P='1' else '0';
DecAfterSel  <= '1' when U='0' and P='0' else '0';
MltAdrSel <= (IDR_LDM or IDR_STM) and ExecuteInst;  -- Base register update for LDM/STM
SngMltSel <= (IDR_LDR or IDR_LDRT or IDR_LDRB or IDR_LDRBT or
              IDR_LDRSB or IDR_LDRH or IDR_LDRSH or
			  IDR_STR or IDR_STRT or IDR_STRB or IDR_STRBT or IDR_STRH)
              and ExecuteInst and (not IDC_STM); -- ??? TBD '0' -> LDM/STM and LR corrections

-- Notes:
-- IncBeforeSel has the highest priority
-- DecAfterSel  has the lowest priority

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Instruction pipeline and data in registers control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Pipeline stagnation control for multicycle instructions
-- All the instructions that stagnates pipeline - all there cycles except last one

StagnatePipeline_Int <= (((IDR_DPIRegSh and not DPIRegSh_St)or
						 ((IDR_STR or IDR_STRT or IDR_STRB or IDR_STRBT or IDR_STRH)and not STR_St)or
                         ((IDR_LDR or IDR_LDRT or IDR_LDRB or IDR_LDRBT or IDR_LDRSB or IDR_LDRH or IDR_LDRSH)and not nLDR_St0)or
						  (IDR_STM and not STM_St)or
						  (IDR_LDM and not nLDM_St0)or
                         ((IDR_SWP or IDR_SWPB)and not nSWP_St0)or
						  (IDR_MUL and not MUL_St)or
						  (IDR_MLA and not nMLA_St0)or
					     ((IDR_UMULL or IDR_SMULL)and not nMULL_St0)or
		                 ((IDR_UMLAL or IDR_SMLAL)and not nMLAL_St0)
	                	 )and ExecuteInst)or
 						 (LDR_St1 or 								 -- LDR
						  (STM_St and not LSMStop) or	             -- STM Check???
						  (LDM_St1 or (LDM_St2 and not LSMStopDel))or	 -- LDM	Check???
						  SWP_St1 or SWP_St2 or                      -- SWAP/SWAPB
						  ((MUL_St or MLA_St2)and not MulResRdy)or MLA_St1 or -- MUL/MLA
						    MULL_St1 or MLAL_St1 or MLAL_St2 -- SMULL/UMULL/SMLAL/UMLAL
						  );                                 -- TBD Other cycles should be included


PipelineStagnateDelayed:process(nRESET,CLK)
begin
if nRESET='0' then                          -- Reset
  StagnatePipelineDel_Int <= '0';
 elsif CLK='1' and CLK'event then           -- Clock
 if CLKEN='1' then                          -- Clock enable
  StagnatePipelineDel_Int <= StagnatePipeline_Int;
 end if;
end if;
end process;

-- Fetch of the first instruction after reset
FirstInstructionFetch:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 FirstInstFetch_Int <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
  FirstInstFetch_Int <= '1';
  end if;
end if;
end process;

-- Data in register and control(sign/zero, byte/halfword  extension)
DInRegCtrl:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 SignExt <= '0';
 ZeroExt <= '0';
 nB_HW <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if StagnatePipeline_Int='0' and CLKEN='1' then                -- Clock enable
 SignExt <= IDC_LDRSB or IDC_LDRSH;
 ZeroExt <= IDC_LDRB or IDC_LDRBT or IDC_LDRH or IDC_SWPB;
 nB_HW   <= IDC_LDRH or IDC_LDRSH;
  end if;
end if;
end process;

-- Bus control
EndianMode <= '0';                 -- Little endian (default)

-- Global endianness control!!!TBD!!!
BigEndianMode <= '0';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Data output multiplexer control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DOutMuxCtrl:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 StoreHalfWord <= '0';
 StoreByte <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if StagnatePipeline_Int='0' and CLKEN='1' then                -- Clock enable
  StoreHalfWord <= IDC_STRH;
  StoreByte <= IDC_STRB or IDC_STRBT or IDC_SWPB;
  end if;
end if;
end process;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Conditional execution control
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ConditionIsTrue <= '1' when (cond="0000" and CPSRZFlag='1')or -- EQ
							(cond="0001" and CPSRZFlag='0')or -- NE
							(cond="0010" and CPSRCFlag='1')or -- CS/HS
							(cond="0011" and CPSRCFlag='0')or -- CC/LO
							(cond="0100" and CPSRNFlag='1')or -- MI
							(cond="0101" and CPSRNFlag='0')or -- PL
							(cond="0110" and CPSRVFlag='1')or -- VS
							(cond="0111" and CPSRVFlag='0')or -- VC
                            (cond="1000" and CPSRCFlag='1' and CPSRZFlag='0')or -- HI
							(cond="1001" and (CPSRCFlag='0' or CPSRZFlag='1'))or -- LS
							(cond="1010" and CPSRNFlag=CPSRVFlag)or -- GE
							(cond="1011" and CPSRNFlag/=CPSRVFlag)or -- LT
							(cond="1100" and CPSRZFlag='0'and CPSRNFlag=CPSRVFlag )or -- GT
							(cond="1101" and (CPSRZFlag='1' or (CPSRNFlag/=CPSRVFlag)))or -- LE
							 cond="1110" else -- AL
							 '0';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exception handling
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Data abort exception start -> the highest priority
DAbtExcStart <= DAbtFlag;

-- FIQ exception start
FIQExcStart <= (FIQLatched and not CPSRFFlag) and not DAbtExcStart;

-- IRQ exception start
IRQExcStart <= (IRQLatched and not CPSRIFlag) and
                not(DAbtExcStart or FIQExcStart);

-- Prefetch abort exception start
PAbtExcStart  <= (IFAbtStored and ConditionIsTrue) and
                    not(DAbtExcStart or FIQExcStart or IRQExcStart);

-- SWI or undefined instruction exception start	 -> the lowest priority
SWI_UndefExcStart <= ((IDR_Undef or IDR_SWI) and ConditionIsTrue) and
                     not(DAbtExcStart or FIQExcStart or IRQExcStart or PAbtExcStart);


-- The first cycle of exception
ExceptFC <= ExceptSMStart and not PipelineRefilling;

AbortForData:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
  LSAbtOccurred <= '0';
  DAbtStored  <= '0';
  DAbtFlag       <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
   LSAbtOccurred <= (not LSAbtOccurred and(                            -- Set
                     (LDR_St1 and ABORT)or                 -- Data abort during LDR
   					 (LDM_St1 and ABORT)or			       -- Data abort during LDM(first load)
					 (LDM_St2 and not LSMStopDel and ABORT)or -- Data abort during LDM(except fist and last)
   					 ((SWP_St1 or SWP_St2) and ABORT)or    -- Data abort during SWP/SWPB
					 (STM_St and not LSMStop and ABORT)))or -- Data abort during STM(except last)
					 (LSAbtOccurred and StagnatePipeline_Int);  -- Clear : end of instruction*

   DAbtFlag <=  not DAbtFlag and
                not StagnatePipeline_Int and
                (LSAbtOccurred or ((STR_St or STM_St) and ABORT));

   DAbtStored  <= ABORT;
 end if;
end if;
end process;

-- * Note: as far as PC writing is impossible after data abort there is no need to include
-- "write to PC recognition" in this equation

-- Exception address generator for exceptions
ExceptionVector <= CExcAdrDtAbt when DAbtFlag='1' else -- Data abort (highest priority)
				   CExcAdrFIQ when (FIQLatched and not CPSRFFlag)='1' else -- Fast interrupt
				   CExcAdrIRQ when (IRQLatched and not CPSRIFlag)='1' else -- Normal interrupt
                   CExcAdrPrfAbt when IFAbtStored='1' else -- Prefetch abort
				   CExcAdrUndefined when IDR_Undef='1' else -- Undefined instruction (lowest priority)*
				   CExcAdrSWI when IDR_SWI='1' else -- Software interrupt(lowest priority)*
				   (others => CDnCr);

-- New mode generator for exceptions
NewMode <= CAbortMode when DAbtFlag='1' else -- Data abort address(highest priority)
		   CFIQMode when (FIQLatched and not CPSRFFlag)='1' else -- Fast interrupt
		   CIRQMode when (IRQLatched and not CPSRIFlag)='1' else -- Normal interrupt
           CAbortMode when IFAbtStored='1' else -- Prefetch abort
		   CUndefMode when IDR_Undef='1' else -- Undefined instruction (lowest priority)*
		   CSVCMode when IDR_SWI='1' else -- Software interrupt(lowest priority)*
		   (others => CDnCr);

-- * Note: These two exceptions are mutually exclusive so they have an equal priority

-- Mode for register file control ??? TBD !!!
RFMode <= NewMode when ExceptFC ='1' else         -- First cycle of the exception
		  CUserMode when UMRAccess_St='1' else    -- User mode registers read/write
	      CPSRMode;                               -- TBD

-- Start of exception state machine (TBD)
ExceptSMStart <= ((IDR_Undef or IDR_SWI or IFAbtStored)and ConditionIsTrue)or -- Undefined instruction/software interrupt/instruction prefetch abort
				  DAbtFlag or                                               -- Data abort
                 (FIQLatched and not CPSRFFlag) or (IRQLatched and not CPSRIFlag); -- External interrupts

ExceptionStateMachine:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 nExceptSM_St0 <= '0';
 ExceptSM_St1  <= '0';
 ExceptSM_St2  <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable

 nExceptSM_St0 <= (not nExceptSM_St0 and ExceptSMStart and not(nWrPCSM_St0 or nBranch_St0))or
 				  (nExceptSM_St0 and not ExceptSM_St2);
 ExceptSM_St1 <= not ExceptSM_St1 and not nExceptSM_St0 and
                 ExceptSMStart and not(nWrPCSM_St0 or nBranch_St0);
 ExceptSM_St2  <= ExceptSM_St1;

 end if;
end if;
end process;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Instruction state machines
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PipelineRefilling <= nBranch_St0 or nWrPCSM_St0 or nExceptSM_St0;

--PipelineRefilingDFF:process(nRESET,CLK)
--begin
--if nRESET='0' then                -- Reset
-- PipelineRefilling <= '0';
--elsif CLK='1' and CLK'event then  -- Clock
-- if CLKEN='1' then                -- Clock enable
--  PipelineRefilling <= (not PipelineRefilling and(
--                       (not nExceptSM_St0 and ExceptSMStart)or
--  					   (nBranch_St0 and((IDR_Branch or (IDR_ThBLSP and CPSRTFlag)) and ExecuteInst))or
--					   (not nWrPCSM_St0 and WriteToPC)))or
--                       (PipelineRefilling and not(Branch_St2 or ExceptSM_St2 or WrPCSM_St2));
-- end if;
--end if;
--end process;

ExecuteInst <= ConditionIsTrue and not(ExceptSMStart or PipelineRefilling); -- Instruction must be executed

-- Data processing instructions which take two cycles(with register shift)
DPIShiftByReg:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
    DPIRegSh_St <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
    DPIRegSh_St <= not DPIRegSh_St and
	               IDR_DPIRegSh and ExecuteInst;
 end if;
end if;
end process;

-- Branch state machine (B,BL,BX)- TBD 3 cycle
BranchSM:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
    nBranch_St0 <= '0';
    Branch_St1  <= '0';
    Branch_St2  <= '0';

elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
 nBranch_St0 <= (not nBranch_St0 and((IDR_Branch or (IDR_ThBLSP and CPSRTFlag)) and
                 ExecuteInst))or  -- Thumb BL support added(the second part of instruction)
				 (nBranch_St0 and not Branch_St2);

 Branch_St1  <= not Branch_St1 and
                not nBranch_St0 and ((IDR_Branch or(IDR_ThBLSP and CPSRTFlag)) and ExecuteInst); -- Thumb support is added

 Branch_St2  <= Branch_St1;
 end if;
end if;
end process;


-- Link bit for branch instruction !!! TBD
LinkBitStore:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
    BLink <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
    BLink <= (not BLink and IDR_BL and ExecuteInst) or -- Thumb BL support added(the second part of instruction)
             (BLink and not Branch_St2);
 end if;
end if;
end process;


-- Swap (word/byte)  4 cycles
SwapSM:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset

  nSWP_St0 <= '0';
  SWP_St1 <= '0';
  SWP_St2 <= '0';
  SWP_St3 <= '0';

elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable

nSWP_St0 <= (not nSWP_St0 and (IDR_SWP or IDR_SWPB) and
                 ExecuteInst)or
                (nSWP_St0 and not SWP_St3);

 SWP_St1  <= not SWP_St1 and
                not nSWP_St0 and (IDR_SWP or IDR_SWPB) and
                ExecuteInst;

 SWP_St2  <= SWP_St1;

 SWP_St3  <= SWP_St2;

 end if;
end if;
end process;

-- STR 2 cycles
StoreOneRegister:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
    STR_St <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
    STR_St <=  not STR_St and (IDR_STR or IDR_STRT or IDR_STRB or IDR_STRBT or IDR_STRH)and              -- TBD
	           ExecuteInst;
 end if;
end if;
end process;


-- LDR 3 cycles
LoadOneRegister:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
    nLDR_St0 <= '0';
	 LDR_St1 <= '0';
	 LDR_St2 <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
  nLDR_St0 <= (not nLDR_St0 and
              (IDR_LDR or IDR_LDRT or IDR_LDRB or IDR_LDRBT or
               IDR_LDRSB or IDR_LDRH or IDR_LDRSH)and ExecuteInst)or
  			  (nLDR_St0 and not LDR_St2);

   LDR_St1 <= not LDR_St1 and not nLDR_St0 and
              (IDR_LDR or IDR_LDRT or IDR_LDRB or IDR_LDRBT or
               IDR_LDRSB or IDR_LDRH or IDR_LDRSH)and ExecuteInst;

   LDR_St2 <= LDR_St1;
 end if;
end if;
end process;

-- Load/Store multiple (LDM/STM) cycle counter
LoadStoreMultipleCnt:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 LSMCycleCnt <= (others => '0');
 LSMStop <= '0';
 LSMStopDel <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
  if StagnatePipeline_Int='0' then  --or (IDR_LDM='1' and nLDM_St0='0') then
   LSMCycleCnt <= "00001";          -- Clear
   else
	LSMCycleCnt <= LSMCycleCnt+1;
  end if;
  if  LSMCycleCnt=RegNumCnt(RegNumCnt'high) then
   LSMStop <= '1';
    else
     LSMStop <= '0';
   end if;

   LSMStopDel <= (not LSMStopDel and LSMStop and nLDM_St0); -- LSMStopDel is used in LDM only

  end if;
end if;
end process;

-- Calculate number of registers to load or to store
RegNumCnt(RegNumCnt'low) <= "00001" when InstForDecodeLatched(0)='1' else "00000";
MultRegNumCounter :for i in 1 to RegNumCnt'high generate
RegNumCnt(i) <= RegNumCnt(i-1)+1 when InstForDecodeLatched(i)='1' else RegNumCnt(i-1);
end generate;


LSMRegAdr:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 CurrentRgAdr <= (others => '0');
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
  if (IDR_STM='1' and STM_St='0') or LDM_St1='1' then
   CurrentRgAdr <= FirstRgAdr;    -- Load first address
   else
    CurrentRgAdr <=	NextRgAdr(NextRgAdr'high); -- Calculate next address
  end if;

  end if;
end if;
end process;


-- Calculate address of the next register for load/store multiple
FirstRgAdr <= "0000" when InstForDecodeLatched(0)='1' else
              "0001" when InstForDecodeLatched(1)='1' else
			  "0010" when InstForDecodeLatched(2)='1' else
			  "0011" when InstForDecodeLatched(3)='1' else
              "0100" when InstForDecodeLatched(4)='1' else
			  "0101" when InstForDecodeLatched(5)='1' else
			  "0110" when InstForDecodeLatched(6)='1' else
              "0111" when InstForDecodeLatched(7)='1' else
              "1000" when InstForDecodeLatched(8)='1' else
              "1001" when InstForDecodeLatched(9)='1' else
			  "1010" when InstForDecodeLatched(10)='1' else
			  "1011" when InstForDecodeLatched(11)='1' else
              "1100" when InstForDecodeLatched(12)='1' else
			  "1101" when InstForDecodeLatched(13)='1' else
			  "1110" when InstForDecodeLatched(14)='1' else
              "1111" when InstForDecodeLatched(15)='1' else
			  (others => CDnCr);


NextRgAdr(NextRgAdr'low) <= "0000";
RgAdr(RgAdr'low) <= "0000";
NextRegAdrGen:for i in 1 to NextRgAdr'high generate
 RgAdr(i) <= RgAdr(i-1)+1;
 NextRgAdr(i) <= RgAdr(i) when InstForDecodeLatched(i)='1' and i>CurrentRgAdr  and NextRgAdr(i-1)="0000"
                 else NextRgAdr(i-1);
end generate;



-- STM/LDM
StoreMultipleRegisters:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
    STM_St <= '0';
   nLDM_St0 <= '0';
    LDM_St1	<= '0';
   	LDM_St2	<= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
    STM_St <= (not STM_St and IDR_STM and
	           ExecuteInst)or
			  (STM_St and not LSMStop);

   nLDM_St0 <= (not nLDM_St0 and IDR_LDM and ExecuteInst)or
               (nLDM_St0 and not(LDM_St2 and LSMStopDel));

    LDM_St1	<= not LDM_St1 and not nLDM_St0 and IDR_LDM and ExecuteInst;

	LDM_St2	<= (not LDM_St2 and LDM_St1)or(LDM_St2 and not LSMStopDel);

 end if;
end if;
end process;


-- Update base register for single load/store
UpDBaseRSng <= not P_Latched or	(P_Latched and W_Latched); -- P=0 (post-indexed) / P=1 && W=1 (pre-indexed)

BaseUpdate:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
  BaseRegUdate_St <= '0';
  BaseRegWasUdated_St <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
  	-- Second cycle of all load/store instructions TBD
	BaseRegUdate_St <= not BaseRegUdate_St and ExecuteInst and(
	   (((not STM_St and IDR_STM)or(not nLDM_St0 and IDR_LDM))and W_Latched)or -- W='1'
       (((not nLDR_St0 and (IDR_LDR or IDR_LDRB or IDR_LDRSB or IDR_LDRH or IDR_LDRSH))or
  	     (not STR_St and (IDR_STR or IDR_STRB or IDR_STRH)))and UpDBaseRSng)or  -- P='0' or (P='1' and W='1')
      	((not nLDR_St0 and (IDR_LDRT or IDR_LDRBT))or         					-- Instructions which always use post-index
    	(not STR_St and (IDR_STRT or IDR_STRBT))));

    -- Flag which indicates that base register was updated (for LDM/STM)
    BaseRegWasUdated_St <= (not BaseRegWasUdated_St and BaseRegUdate_St and
	                     (LDM_St1 or (STM_St and not LSMStop)))or
	                     (BaseRegWasUdated_St and not((LDM_St2 and LSMStopDel)or -- End of LDM
													  (STM_St and LSMStop)));	 -- End of STM

 end if;
end if;
end process;

-- Note: For Load/Store multiple base update is conrolled only by W bit(bit[21])
-- For Load/Store single base update is controlled by P bit(bit[24]) and W bit(bit[21]),
-- Update takes place if P=0 (post-indexed) or P=1 && W=1 (pre-indexed)
-- P=0 && W=1 -> instructions with translation (and base update!!!)


-- Access to the user mode register during LDM/STM instructions
LSMUMR <= '1' when InstForDecodeLatched(22 downto 21)="10" else '0'; -- TBD

UserModeRegAccess:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
 UMRAccess_St <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
   UMRAccess_St <= (not UMRAccess_St and(((IDR_STM or IDR_LDM) and ExecuteInst) and LSMUMR))or
                    (UMRAccess_St and not((LDM_St2 and LSMStopDel)or -- End of LDM
										 (STM_St and LSMStop)));	 -- End of STM
 end if;
end if;
end process;


-- Multiplications

-- MUL/MLAL/SMULL/UMULL/SMLAL/UMLAL
Multiplications:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
MUL_St <= '0';

nMLA_St0 <= '0';
MLA_St1  <= '0';
MLA_St2  <= '0';

nMULL_St0 <= '0';
MULL_St1  <= '0';
MULL_St2  <= '0';

nMLAL_St0 <= '0';
MLAL_St1  <= '0';
MLAL_St2  <= '0';
MLAL_St3  <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable

-- MUL  m*I+S
MUL_St <= (not MUL_St and IDR_MUL and ExecuteInst)or
          (MUL_St and not MulResRdy);
-- MLA	I+m*I+S
nMLA_St0 <= (not nMLA_St0 and IDR_MLA and ExecuteInst)or
            (nMLA_St0 and not(MLA_St2 and MulResRdy));

MLA_St1  <= not MLA_St1 and not nMLA_St0 and IDR_MLA and ExecuteInst;

MLA_St2  <= (not MLA_St2 and MLA_St1)or
            (MLA_St2 and not MulResRdy);

-- SMULL/UMULL m*I+I+S
nMULL_St0 <= (not nMULL_St0 and (IDR_SMULL or IDR_UMULL) and ExecuteInst)or
             (nMULL_St0 and not MULL_St2);

MULL_St1  <= (not MULL_St1 and not nMULL_St0 and (IDR_SMULL or IDR_UMULL) and ExecuteInst)or
             (MULL_St1 and not MulResRdy);

MULL_St2  <= not MULL_St2 and MULL_St1 and MulResRdy;

-- SMLAL/UMLAL I+m*I+I+S
nMLAL_St0 <= (not nMLAL_St0 and (IDR_SMLAL or IDR_UMLAL) and ExecuteInst)or
             (nMLAL_St0 and not MLAL_St3);

MLAL_St1  <= not MLAL_St1 and not nMLAL_St0 and (IDR_SMLAL or IDR_UMLAL) and ExecuteInst;

MLAL_St2  <= (not MLAL_St2 and MLAL_St1)or
             (MLAL_St2 and not MulResRdy);

MLAL_St3  <= not MLAL_St3 and MLAL_St2 and MulResRdy;

 end if;
end if;
end process;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Write to PC handling
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Write to PC indicator
WriteToPC <= '1' when WriteAdr_Int=CR_PC and  WrEn_Int='1' else '0';

-- Change of PC because of write to it(branch) is a part of instruction
-- so it can't be separated from this instruction in any manner (interrupt and etc.)
WriteToPCStateMachine:process(nRESET,CLK)
begin
if nRESET='0' then                -- Reset
  nWrPCSM_St0 <= '0';
  WrPCSM_St1  <= '0';
  WrPCSM_St2  <= '0';
elsif CLK='1' and CLK'event then  -- Clock
 if CLKEN='1' then                -- Clock enable
  nWrPCSM_St0 <= (not nWrPCSM_St0 and WriteToPC)or
  				 (nWrPCSM_St0 and not WrPCSM_St2);
  WrPCSM_St1  <= not WrPCSM_St1 and not nWrPCSM_St0 and WriteToPC;
  WrPCSM_St2  <= WrPCSM_St1;

 end if;
end if;
end process;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- SPSR/CPSR control and data
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Write to CPSR
WriteToCPSR <= (IDR_MSR_R or IDR_MSR_I)and ExecuteInst and not R_Latched; -- MSR (Immediate/Register) writes to CPSR

-- Restore CPSR from current SPSR
RestCPSR <= (((IDR_SingleCycleDPI and ExecuteInst)or DPIRegSh_St) and S_Latched and WriteToPC)or -- Data processing instruction writes to PC
			(LDM_ST2 and InstForDecodeLatched(22) and WriteToPC);							     -- Load multiple instruction writes to PC

-- ALU bus input control
PSRDInSel <= (IDR_MSR_R or IDR_MSR_I) and ExecuteInst; -- Value will be written to CPSR/SPSR from the ALU Result Bus

-- Current program state register input
CPSRIn <= SPSROut when RestCPSR='1' else  -- Restore CPSR from SPSR
	                   NFlagOut&NewZFlag&CFlagOut&VFlagOut&
	                   (27 downto 8 => '0')&
	                   NewIFlag&NewFFlag&NewTFlag&NewMode;

-- New values of F,I and T flags
NewFFlag <= '1' when ExceptFC='1' and FIQExcStart='1' else '0'; -- Fast interrupt
NewIFlag <= '1' when ExceptFC='1' else '0'; -- Exceptions
NewTFlag <= '0' when ExceptFC='1' else RmBitZero; -- Change of CPU state

-- C flag control for long multiplications
CFlForMul <= MULL_St2 or MLAL_St3; -- Last cycle of long multiplication

-- Z flag (is generated in a special way during long mutliplications)
NewZFlag <= (ZFlagOut and CPSRZFlag) when  MULL_St2='1' or MLAL_St3='1' else -- Last cycle of long multiplications
            ZFlagOut;

-- Write to N,Z,C and V flags
WriteToHiFl <= ((IDR_SingleCycleDPI and ExecuteInst)or DPIRegSh_St) and S_Latched; -- Data processing instructions

-- Write to C and Z flags by multiplication instructions
MulFlWr <= (MUL_St or nMLA_St0 or nMULL_St0 or nMLAL_St0) and S_Latched;

-- N flag write enable
CPSRNFlWE <= '1' when WriteToHiFl ='1' or
                      RestCPSR ='1' or
                      (WriteToCPSR = '1' and Mask(Mask'high)='1') or
					  MulFlWr ='1' -- Multiplications
                      else '0';

-- Z flag write enable
CPSRZFlWE <= '1' when WriteToHiFl ='1' or
                      RestCPSR ='1' or
                      (WriteToCPSR = '1' and Mask(Mask'high)='1') or
					  MulFlWr ='1' -- Multiplications
					  else '0';

-- C flag write enable
CPSRCFlWE <= '1' when WriteToHiFl = '1' or
                      RestCPSR = '1' or
                      (WriteToCPSR = '1' and Mask(Mask'high)='1')
					  else '0';

-- V flag write enable
CPSRVFlWE <= '1' when (IDR_DPIArith = '1' and WriteToHiFl = '1')or
                       RestCPSR = '1' or
                      (WriteToCPSR = '1' and Mask(Mask'high)='1')
					   else '0';

-- I flag write enable
CPSRIFlWE <= '1' when RestCPSR='1' or
             (WriteToCPSR='1' and CPSRMode /= CUserMode and Mask(0)='1') -- Write to CPSR (ignored in User Mode)
			 else '0';

-- F flag write enable
CPSRFFlWE <= '1' when RestCPSR='1' or
             (WriteToCPSR='1' and CPSRMode /= CUserMode and Mask(0)='1') -- Write to CPSR (ignored in User Mode)
			 else '0';

-- T flag write enable
CPSRTFlWE <= '1' when RestCPSR='1' or
			 (IDR_BX='1' and ExecuteInst='1' and nBranch_St0='0') or -- Branch with exchange (First cycle)
             (WriteToCPSR='1' and CPSRMode /= CUserMode and Mask(0)='1') or -- Write to CPSR (ignored in User Mode)
             (ExceptFC='1')
			 else '0';

-- Was done in order to avoid some Aldec(4.2) bug
CPSRWrEn <= CPSRNFlWE&CPSRZFlWE&CPSRCFlWE&CPSRVFlWE&(27 downto 8 => '0')&
            CPSRIFlWE&CPSRFFlWE&CPSRTFlWE&(4 downto 0 => CPSRModeWE);

-- Write to CPSR by MSR !!
-- CPSRWrEn <= (31 downto 24 => Mask(3))&
--			   (23 downto 16 => Mask(2))&
--			   (15 downto 8 => Mask(1))&
--			   (15 downto 8 => Mask(0))&

-- Changing of CPU mode
CPSRModeWE <= '1' when ExceptFC='1' or  -- First cycle of exception !!!TBD
                       RestCPSR='1' or  -- Restore CPSR from SPSR
					  (WriteToCPSR='1' and CPSRMode /= CUserMode and Mask(0)='1') -- Write to CPSR (ignored in User Mode)
                   else '0';

-- Saved program state (Move CPSR to SPSR of the new mode)
SPSRIn <= CPSROut; -- TBD

-- Write enable (mask) for SPSR
SPSRWrMsk <= (others => '1') when ExceptFC='1' else -- First cycle of exception
	          Mask when (IDR_MSR_I or IDR_MSR_R)='1' and ExecuteInst='1' and R_Latched='1' else  -- Write to SPSR
	 		 (others => '0');                       -- No write

-- PSR mode control
PSRMode <= NewMode when ExceptFC='1' else -- First cycle of the exception
	       CPSRMode;                      -- TBD

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Outputs
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Thumb decoder enable
ThumbDecoderEn <= CPSRTFlag; -- TBD

-- TBD
WRITE <= ((IDR_STR or IDR_STRB or IDR_STRBT or IDR_STRT or IDR_STRH)and
          ExecuteInst and not STR_St)or
		  ((IDR_STM and ExecuteInst and not STM_St)or(STM_St and not LSMStop))or -- Store multiple
		  SWP_St1; -- ???

-- Outputs which have internal copies
WrEn <= WrEn_Int;
StagnatePipeline <= StagnatePipeline_Int;
StagnatePipelineDel <= StagnatePipelineDel_Int;
FirstInstFetch <= FirstInstFetch_Int;
WriteAdr <= WriteAdr_Int;

-- TBD (Thumb mode suppport should be added)
SIZE  <= CTS_B when (IDR_LDRB or IDR_LDRBT or IDR_STRB or IDR_STRBT or IDR_LDRSB)='1' and
                     ExecuteInst='1' and nLDR_St0='0' and STR_St='0' else
    	 CTS_HW when ((IDR_LDRH or IDR_STRH or IDR_LDRSH)='1' and
                      ExecuteInst='1' and nLDR_St0='0' and STR_St='0') else
         CTS_W;

AddrReg:process(nRESET,CLK)
begin
if nRESET='0' then
    LastAddr <= (others => '0');
elsif CLK='1' and CLK'event then
    if CLKEN='1' then
        LastAddr <= Addr;
    end if;
end if;
end process;

DataAddrLow <= LastAddr(1 downto 0) when (Branch_St1='1' or Branch_St2='1') else
              "00" when ((IDR_LDR='1' or IDR_LDRT='1') and (LDR_St1='1')) else
               LastAddr(1) & '0' when ((IDR_LDRH='1' or IDR_LDRSH='1') and (LDR_St1='0')) else
               "00" when (nLDM_St0='1') else
               LastAddr(1 downto 0);

end RTL;
