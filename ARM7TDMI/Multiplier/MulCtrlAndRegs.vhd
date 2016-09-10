--**************************************************************************************************** 
-- Multiplier control and Partial Sum/Carry registers for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 12.02.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity MulCtrlAndRegs is generic(EarlyTermination : boolean); 
	                     port( 
						   -- Global signals 
	                       nRESET          : in  std_logic; 
						   CLK             : in  std_logic; 
						   CLKEN		   : in  std_logic; 
	                       -- Interface for the 32x8 combinatorial multiplier  
	                       Rs9Out          : out std_logic_vector(8 downto 0); 
	                       PartialSumOut   : out std_logic_vector(63 downto 0);  
						   PartialCarryOut : out std_logic_vector(63 downto 0);  
						   PartialSumIn    : in  std_logic_vector(63 downto 0);  
						   PartialCarryIn  : in  std_logic_vector(63 downto 0);  
						   PP4P            : out std_logic; 
		                   PP4M            : out std_logic; 
		                   -- Data inputs 
	                       ADataIn         : in  std_logic_vector(31 downto 0); -- RdHi(Rn)/Rs data path  
						   BDataIn         : in  std_logic_vector(31 downto 0); -- RdLo(Rd)/Rm data path 
						   -- Control inputs 
						   LoadRsRm        : in  std_logic;  -- Load Rs and Rm and start 
						   LoadPS          : in  std_logic;  -- Load partial sum register with RHi:RLo    
						   ClearPSC        : in  std_logic;  -- Clear prtial sum and carry register 
						   UnsignedMul     : in  std_logic;  -- Unsigned multiplication 
						   ReadLH	       : in  std_logic;	 -- 0 - Read PS/PC low,1 - Read PS/PC high 
						   -- Control outputs 
						   MulResRdy       : out std_logic; -- Multiplication result is ready 
						   -- Result 
						   ResPartSum      : out std_logic_vector(31 downto 0); 
						   ResPartCarry    : out std_logic_vector(31 downto 0) 
						      ); 
end MulCtrlAndRegs; 
 
architecture RTL of MulCtrlAndRegs is 
 
-- Partial sum and partial carry registers signals 
signal PartialSumReg     : std_logic_vector(63 downto 0) := (others => '0'); 
signal PartialSumRegIn   : std_logic_vector(PartialSumReg'range) := (others => '0'); 
signal PartialCarryReg   : std_logic_vector(63 downto 0) := (others => '0'); 
signal PartialCarryRegIn : std_logic_vector(PartialCarryReg'range) := (others => '0'); 
 
signal PartialSumMasked  : std_logic_vector(PartialSumReg'range) := (others => '0'); 
signal PartialCarryMasked  : std_logic_vector(PartialCarryReg'range) := (others => '0'); 
 
signal PartialSumRealing   : std_logic_vector(PartialSumReg'range) := (others => '0'); 
signal PartialCarryRealing : std_logic_vector(PartialCarryReg'range) := (others => '0'); 
 
-- Control state machine 
signal nMulSt0       : std_logic := '0'; 
signal MulSt1        : std_logic := '0'; 
signal MulSt2        : std_logic := '0'; 
signal MulSt3        : std_logic := '0'; 
signal MulSt4        : std_logic := '0'; 
 
-- Early termination signals 
signal EarlyTerm1C   : std_logic := '0'; -- Early termination after the first cycle 
signal EarlyTerm2C   : std_logic := '0'; -- Early termination after the second cycle 
signal EarlyTerm3C   : std_logic := '0'; -- Early termination after the third cycle 
 
signal MulResRdyInt  : std_logic := '0'; 
 
-- Realignment circuit 
signal	RealignCnt   : std_logic_vector(1 downto 0) := (others => '0'); 
signal	RealignCntIn : std_logic_vector(RealignCnt'range) := (others => '0'); 
 
signal UMulLastCycle : std_logic := '0'; 
 
begin 
	 
Rs9Out <= ADataIn(7 downto 0)&'0' when LoadRsRm='1' else -- First cycle of the multiplication  
		  ADataIn(15 downto 7) when MulSt1='1' else 	 -- Second cycle of the multiplication  
		  ADataIn(23 downto 15) when MulSt2='1' else 	 -- Third cycle of the multiplication  
		  ADataIn(31 downto 23) when MulSt3='1' else 	 -- Forth cycle of the multiplication  
		  (others => CDnCr); 
			   
MainControlSm:process(nRESET,CLK) 
begin 
if nRESET='0' then               -- Reset 
 nMulSt0 <= '0'; 
  MulSt1 <= '0'; 
  MulSt2 <= '0'; 
  MulSt3 <= '0'; 
  MulSt4 <= '0'; 
  MulResRdyInt <= '0'; 
  UMulLastCycle <= '0'; 
  
elsif CLK='1' and CLK'event then -- Clock 
  if CLKEN='1' then              -- Clock enable 
  nMulSt0 <= (not nMulSt0 and LoadRsRm and not EarlyTerm1C) or (nMulSt0 and not( 
  		     (MulSt1 and EarlyTerm2C)or 
             (MulSt2 and EarlyTerm3C)or 
			  MulSt3)); 
   
  MulSt1 <= not MulSt1 and not nMulSt0 and LoadRsRm and not EarlyTerm1C; 
  MulSt2 <= not MulSt2 and MulSt1 and not EarlyTerm2C; 
  MulSt3 <= not MulSt3 and MulSt2 and not EarlyTerm3C; 
  MulResRdyInt <= (not MulResRdyInt and  
  				 ((LoadRsRm and EarlyTerm1C)or 
                  (MulSt1 and EarlyTerm2C)or 
  		          (MulSt2 and EarlyTerm3C)or 
				   MulSt3))or  
				  (MulResRdyInt and not ClearPSC);   -- Clear ready flag after multiplication 
 
UMulLastCycle <= not MulSt3 and MulSt2 and not EarlyTerm3C and  
                  UnsignedMul and ADataIn(ADataIn'high); -- The last cycle of unsigned multiplication and Rs[31]='1' -> +X 
 
  end if; 
end if;	  
end process; 
 
MulResRdy <= MulResRdyInt; 
 
-- +X 
PP4P <= '1' when (nMulSt0='0' and EarlyTerm1C='1' and ADataIn(8 downto 7)="01")or 
                 (MulSt1='1' and EarlyTerm2C='1' and ADataIn(16 downto 15)="01")or  
                 (MulSt2='1' and EarlyTerm3C='1' and ADataIn(24 downto 23)="01")or  
                  UMulLastCycle='1' else '0'; 
 
-- -X					   
PP4M <= '1' when (nMulSt0='0' and EarlyTerm1C='1' and ADataIn(8 downto 7)="10")or 
                 (MulSt1='1' and EarlyTerm2C='1' and ADataIn(16 downto 15)="10")or  
                 (MulSt2='1' and EarlyTerm3C='1' and ADataIn(24 downto 23)="10") 
                  else '0'; 
 
-- Early termination conditions 
-- Cycle                              1               2                3          
-- Signed multiplication        [31:8]='0'/'1'	[31:16]='0'/'1'	 [31:24]='0'/'1' 
-- Unsigned multiplication      [31:8]='0'	    [31:16]='0' 	 [31:24]='0' 
 
-- Early termination logic 
EarlyTerm1C <= '1' when((UnsignedMul='1' and ADataIn(31 downto 8)="0000000000000000000000000")or  
                        (UnsignedMul='0' and(ADataIn(31 downto 8)="0000000000000000000000000" or  
						ADataIn(31 downto 8)="1111111111111111111111111")))and  
                        EarlyTermination else '0'; 
 
EarlyTerm2C <= '1' when((UnsignedMul='1' and ADataIn(31 downto 16)="00000000000000000")or  
                        (UnsignedMul='0' and(ADataIn(31 downto 16)="00000000000000000" or  
						ADataIn(31 downto 16)="11111111111111111")))and  
					    EarlyTermination else '0'; 
 
EarlyTerm3C <= '1' when((UnsignedMul='1' and ADataIn(31 downto 24)="000000000")or  
                        (UnsignedMul='0' and(ADataIn(31 downto 24)="000000000" or  
						ADataIn(31 downto 24)="111111111")))and  
						EarlyTermination else '0'; 
 
			    
RealignmentCounter:process(nRESET,CLK) 
begin 
if nRESET='0' then                                -- Reset 
 RealignCnt  <= (others => '0'); 
elsif CLK='1' and CLK'event then                  -- Clock 
 if (LoadRsRm or nMulSt0)='1' and CLKEN='1' then  -- Clock enable 
 RealignCnt  <= RealignCntIn; 
 end if;	  
end if;	  
end process;			    
 
RealignCntIn <= (others => '0') when  LoadRsRm='1' else 
				 RealignCnt + 1;  
				  
-- Partial sum and partial carry registers 
PartialSum_Load_Rotate:process(nRESET,CLK) 
begin 
if nRESET='0' then                                        -- Reset 
 PartialSumReg  <= (others => '0'); 
elsif CLK='1' and CLK'event then                          -- Clock 
 if (LoadPS or LoadRsRm or nMulSt0 or ClearPSC)='1' and CLKEN='1' then -- Clock enable 
 PartialSumReg  <= PartialSumRegIn; 
 end if;	  
end if;	  
end process; 
 
PartialCarry_Clear_Rotate:process(nRESET,CLK) 
begin 
if nRESET='0' then                                -- Reset 
  PartialCarryReg <= (others => '0');	 
elsif CLK='1' and CLK'event then                  -- Clock 
 if (LoadRsRm or nMulSt0 or ClearPSC)='1' and CLKEN='1' then  -- Clock enable 
  PartialCarryReg <= PartialCarryRegIn;	 
 end if;	  
end if;	  
end process; 
 
PartialSumRegIn <= (others => '0') when ClearPSC='1' else  -- Clear (after multiplication) 
				   ADataIn&BDataIn  when LoadPS='1' else  -- Load (for accumulation) 
                   PartialSumMasked;                      -- Rotate  
 
PartialSumMasked<= PartialSumIn(7 downto 0)&PartialSumIn(63 downto 8) when LoadRsRm='1' else 
                   PartialSumIn(7 downto 0)&PartialSumReg(63 downto 56)&PartialSumIn(55 downto 8) when MulSt1='1' else 
				   PartialSumIn(7 downto 0)&PartialSumReg(63 downto 48)&PartialSumIn(47 downto 8) when MulSt2='1' else 
				   PartialSumIn(7 downto 0)&PartialSumReg(63 downto 40)&PartialSumIn(39 downto 8) when MulSt3='1' else 
				   (others => CDnCr); 
					    
PartialCarryRegIn  <= (others => '0') when ClearPSC='1' else  -- Clear (after multiplication) 
                      PartialCarryMasked;                    -- Rotate  
 
PartialCarryMasked <= PartialCarryIn(7 downto 0)&PartialCarryIn(63 downto 8) when LoadRsRm='1' else 
                      PartialCarryIn(7 downto 0)&PartialCarryReg(63 downto 56)&PartialCarryIn(55 downto 8) when MulSt1='1' else 
				      PartialCarryIn(7 downto 0)&PartialCarryReg(63 downto 48)&PartialCarryIn(47 downto 8) when MulSt2='1' else 
				      PartialCarryIn(7 downto 0)&PartialCarryReg(63 downto 40)&PartialCarryIn(39 downto 8) when MulSt3='1' else 
				      (others => CDnCr); 
 
PartialSumOut <= PartialSumReg; 
PartialCarryOut	<= PartialCarryReg; 
 
-- Result : partial sum and partial carry (64 bits) 
PartialSumRealing <= PartialSumReg(55 downto 0)&PartialSumReg(63 downto 56) when RealignCnt="00" else -- Terminated after the second cycle ?? 
					 PartialSumReg(47 downto 0)&PartialSumReg(63 downto 48) when RealignCnt="01" else -- Terminated after the second cycle ?? 
                     PartialSumReg(39 downto 0)&PartialSumReg(63 downto 40) when RealignCnt="10" else -- Terminated after the third cycle ?? 
                     PartialSumReg(31 downto 0)&PartialSumReg(63 downto 32) when RealignCnt="11" else  
			         (others => CDnCr);	    
 
PartialCarryRealing <= PartialCarryReg(55 downto 0)&PartialCarryReg(63 downto 56) when RealignCnt="00" else -- Terminated after the second cycle ?? 
					   PartialCarryReg(47 downto 0)&PartialCarryReg(63 downto 48) when RealignCnt="01" else -- Terminated after the second cycle ?? 
                       PartialCarryReg(39 downto 0)&PartialCarryReg(63 downto 40) when RealignCnt="10" else -- Terminated after the third cycle	?? 
                       PartialCarryReg(31 downto 0)&PartialCarryReg(63 downto 32) when RealignCnt="11" else  
			           (others => CDnCr);	     
 
ResPartSum   <= PartialSumRealing(63 downto 32) when ReadLH='1' else 
	            PartialSumRealing(31 downto 0); 
 
-- Shift left partial carry by 1  
ResPartCarry <= PartialCarryRealing(62 downto 31) when ReadLH='1' else 
	            PartialCarryRealing(30 downto 0)&'0'; 
 
end RTL; 
