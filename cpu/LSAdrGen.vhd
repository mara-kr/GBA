--**************************************************************************************************** 
-- Address generator for Load/Store instructions 
-- Designed by Ruslan Lepetenok 
-- Modified 15.12.2002 
--**************************************************************************************************** 
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
entity LSAdrGen is port ( 
						-- Global control signals 
	                    nRESET           : in  std_logic; 
						CLK              : in  std_logic; 
						CLKEN            : in  std_logic; 
	                    -- Control and data 
						RmDataIn	     : in  std_logic_vector(31 downto 0); 
						BDataOut	     : out std_logic_vector(31 downto 0); 
						RegisterList     : in  std_logic_vector(15 downto 0); 
	                    IncBeforeSel     : in  std_logic; -- May be used for branches for LR correction !!! 
	                    DecBeforeSel     : in  std_logic; 
						DecAfterSel      : in  std_logic; 
						MltAdrSel	     : in  std_logic; -- 0 -> Start address, 1-> Base reg. update (only for LDM/STM) 
						SngMltSel	     : in  std_logic -- 0 -> LDM/STM, 1 -> LDR/STR 
						); 
end LSAdrGen; 
 
architecture RTL of LSAdrGen is 
type RegListToOffsetConvType is array(0 to 15) of std_logic_vector(31 downto 0); 
signal RegListToOffsetConv : RegListToOffsetConvType := (others => (31 downto 0 => '0')); 
signal OffsetForMlt        : std_logic_vector(31 downto 0) := (others => '0'); 
signal BaseRegUpdOffset    : std_logic_vector(31 downto 0) := (others => '0'); 
signal MltSngMux           : std_logic_vector(31 downto 0) := (others => '0'); 
signal OffsetUpdateMux     : std_logic_vector(31 downto 0) := (others => '0'); 
 
begin 
 
RegListToOffsetConv(RegListToOffsetConv'low) <=  
                          x"00000004" when RegisterList(RegisterList'low)='1'  
                          else (others => '0'); 
	 
ConverterLogic:for i in 1 to RegListToOffsetConv'high generate	 
RegListToOffsetConv(i) <= RegListToOffsetConv(i-1)+4 when RegisterList(i)='1'  
                          else RegListToOffsetConv(i-1);	 
end generate;	 
	 
OffsetForMlt <= x"00000004" when IncBeforeSel='1' else -- Have the highest priority (for LR correction during branches) 
                RegListToOffsetConv(RegListToOffsetConv'high) when DecBeforeSel='1' else 
 		        RegListToOffsetConv(RegListToOffsetConv'high)-4 when DecAfterSel='1' else   
				(others => '0');					   -- Increment after 
 
OffsetUpdateMux <= OffsetForMlt when MltAdrSel='0' else        -- Start address for LDM/STM 
				   BaseRegUpdOffset;						   -- Base register update for LDM/STM 
				 
AdrOffsetRegs:process(nRESET,CLK) 
begin 
 if nRESET='0' then                             -- Reset 
    BaseRegUpdOffset <= (others => '0');  
   elsif CLK='1' and CLK'event then             -- Clock 
    if CLKEN='1' then                           -- Clock enable 
     BaseRegUpdOffset <= RegListToOffsetConv(RegListToOffsetConv'high);  
    end if;		 
 end if;	 
end process;	 
 
OutputReg:process(nRESET,CLK) 
begin 
 if nRESET='0' then                       -- Reset 
    BDataOut <= (others => '0'); 
   elsif CLK='1' and CLK'event then       -- Clock 
    if CLKEN='1' then                     -- Clock enable 
     BDataOut <= MltSngMux; 
    end if;		 
 end if;	 
end process;	 
 
 
MltSngMux <= RmDataIn when SngMltSel='1' else -- LDR/STR (the second cycle - base update) 
             OffsetUpdateMux;				  -- LDM/STM and LR update ?? 		            
													    
													    
end RTL;
