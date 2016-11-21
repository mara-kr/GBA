--**************************************************************************************************** 
-- Programm Status Registers for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 23.01.2003 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
use WORK.ARMPackage.all; 
 
entity PSR is port( 
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
end PSR; 
 
architecture RTL of PSR is 
 
signal CPSR       : std_logic_vector(31 downto 0) := (others => '0'); 
signal SPSR_FIQ   : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSR_SVC   : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSR_Abort : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSR_IRQ   : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSR_Undef : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSRWrEn   : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSROutMUX : std_logic_vector(CPSR'range) := (others => '0'); 
 
 
-- Modes  
signal UserMode  : std_logic := '0';  
signal FIQMode   : std_logic := '0';  
signal IRQMode   : std_logic := '0';  
signal SVCMode   : std_logic := '0';  
signal AbortMode : std_logic := '0';  
signal UndefMode : std_logic := '0';  
 
signal CPSRRegIn  : std_logic_vector(CPSR'range) := (others => '0'); 
signal SPSRRegIn  : std_logic_vector(CPSR'range) := (others => '0'); 
 
-- Long multiplication(accumulation support) 
signal CFlForLMul : std_logic := '0';  
 
begin 
 
-- Mode decode logic 
UserMode <= '1' when PSRMode=CUserMode or PSRMode=CSystemMode else '0';  
FIQMode  <= '1' when PSRMode=CFIQMode else '0';   
IRQMode  <= '1' when PSRMode=CIRQMode else '0';   
SVCMode  <= '1' when PSRMode=CSVCMode else '0';   
AbortMode <= '1' when PSRMode=CAbortMode else '0';  
UndefMode <= '1' when PSRMode=CUndefMode else '0'; 		 
 
-- Masks for write into SPSR	 
SPSRWriteEnable:for i in SPSRWrMsk'range generate	 
SPSRWrEn(i*8+7 downto i*8) <= (others => SPSRWrMsk(i));	 
end generate; 	 
 
-- CPSR/SPSR input multiplexer 
CPSRRegIn <= DataIn when PSRDInSel='1' else CPSRIn; 
SPSRRegIn <= DataIn when PSRDInSel='1' else SPSRIn; 
 
-- Current program status 
CurrentPSR:process(nRESET,CLK) 
begin 
if nRESET='0' then                       -- Reset 
 CPSR <= CPSRInitVal;	 
elsif CLK='1' and CLK'event then         -- Clock 
 for i in CPSR'range loop 
  if CPSRWrEn(i)='1' and CLKEN='1' then  -- Clock enable 
   CPSR(i) <= CPSRRegIn(i);  
  end if;		 
  end loop; 
end if;	 
end process; 
 
-- Saved program statuses 
FIQ_PSR:process(nRESET,CLK) 
begin 
if nRESET='0' then                                         -- Reset 
 SPSR_FIQ <= (others => '0');	 
elsif CLK='1' and CLK'event then                           -- Clock 
 for i in SPSR_FIQ'range loop 
  if FIQMode = '1' and SPSRWrEn(i)='1' and CLKEN='1' then  -- Clock enable 
   SPSR_FIQ(i) <= SPSRRegIn(i);  
  end if;		 
 end loop; 
end if;	 
end process; 
 
IRQ_PSR:process(nRESET,CLK) 
begin 
if nRESET='0' then                                         -- Reset 
 SPSR_IRQ <= (others => '0');	 
elsif CLK='1' and CLK'event then                           -- Clock 
 for i in SPSR_IRQ'range loop 
  if IRQMode = '1' and SPSRWrEn(i)='1' and CLKEN='1' then  -- Clock enable 
   SPSR_IRQ(i) <= SPSRRegIn(i);  
  end if;		 
 end loop; 
end if;	 
end process; 
 
SVC_PSR:process(nRESET,CLK) 
begin 
if nRESET='0' then                                         -- Reset 
 SPSR_SVC <= (others => '0');	 
elsif CLK='1' and CLK'event then                           -- Clock 
 for i in SPSR_SVC'range loop 
  if SVCMode = '1' and SPSRWrEn(i)='1' and CLKEN='1' then  -- Clock enable 
   SPSR_SVC(i) <= SPSRRegIn(i);  
  end if;		 
 end loop; 
end if;	 
end process; 
 
Abort_PSR:process(nRESET,CLK) 
begin 
if nRESET='0' then                                           -- Reset 
 SPSR_Abort <= (others => '0');	 
elsif CLK='1' and CLK'event then                             -- Clock 
 for i in SPSR_Abort'range loop 
  if AbortMode = '1' and SPSRWrEn(i)='1' and CLKEN='1' then  -- Clock enable 
   SPSR_Abort(i) <= SPSRRegIn(i);  
  end if;		 
 end loop; 
end if;	 
end process; 
 
Undef_PSR:process(nRESET,CLK) 
begin 
if nRESET='0' then                                           -- Reset 
 SPSR_Undef <= (others => '0');	 
elsif CLK='1' and CLK'event then                             -- Clock 
 for i in SPSR_Undef'range loop 
  if UndefMode = '1' and SPSRWrEn(i)='1' and CLKEN='1' then  -- Clock enable 
   SPSR_Undef(i) <= SPSRRegIn(i);  
  end if;		 
 end loop; 
end if;	 
end process; 
 
-- Output multiplexers 
SPSROutMUX <=  SPSR_FIQ   when CPSR(4 downto 0) = CFIQMode else   
	           SPSR_IRQ   when CPSR(4 downto 0) = CIRQMode else   
               SPSR_SVC   when CPSR(4 downto 0) = CSVCMode else   
               SPSR_Abort when CPSR(4 downto 0) = CAbortMode else   
	           SPSR_Undef when CPSR(4 downto 0) = CUndefMode else   
			   (others => CDnCr); 
 
SPSROut <= SPSROutMUX; 
            
CPSROut <= CPSR(CPSR'high downto 30)&CFlForLMul&CPSR(28 downto 0) when CFlForMul='1' -- Long multiplication 
           else CPSR;	 
 
CarryForLongMul:process(nRESET,CLK) 
begin 
if nRESET='0' then                -- Reset 
 CFlForLMul <= '0';  
elsif CLK='1' and CLK'event then  -- Clock 
 if CLKEN='1' then                -- Clock enable 
   CFlForLMul <= CPSRIn(29); 
 end if;		 
end if;	 
end process;		 
 
end RTL; 
