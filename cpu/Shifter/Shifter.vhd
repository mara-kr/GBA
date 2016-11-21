--**************************************************************************************************** 
-- Shifter for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 23.01.2003 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use WORK.ARMPackage.all; 
 
entity Shifter is port ( 
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
end Shifter; 
 
-- ******************************************************************************************** 
-- Operation priority: 0 -> ShRotImm  
--					   1 -> others types of shift 
-- 
--  ShType[0]  
--         0 -> immediate shift 
--		   1 ->	register shift	(takes additional cycle) 
-- 
--  ShType[2..1] 
--           00 -> LSL   
--           01	-> LSR 
--			 10	-> ASR 
--			 11	-> ROR/RRX(when ShType[0]='0' and ShLen[4..0]="00000") 
-- 
-- 
-- ******************************************************************************************** 
 
architecture RTL of Shifter is 
type ShifterType is array (31 downto 0) of std_logic_vector(31 downto 0); 
 
signal LeftShifter      : ShifterType := (others => x"00000000"); 
signal RightShifter     : ShifterType := (others => x"00000000"); 
signal LeftShifterMUX   : ShifterType := (others => x"00000000"); 
signal RightShifterMUX  : ShifterType := (others => x"00000000"); 
signal LeftShifterLen   : std_logic_vector(4 downto 0) := (others => '0'); 
signal RightShifterLen  : std_logic_vector(4 downto 0) := (others => '0'); 
signal VacatedBitsR     : std_logic_vector(31 downto 0) := (others => '0'); -- Vacated bits for right shift 
signal RightShiftLenLSB : std_logic := '0'; 
 
signal RightCarryMUX : std_logic_vector(31 downto 0) := (others => '0'); 
signal LeftCarryMUX  : std_logic_vector(31 downto 0) := (others => '0'); 
 
signal ShOutInt : std_logic_vector(ShOut'range) := (others => '0'); 
signal ShCFlagOutInt : std_logic := '0'; 
 
begin 
							    
RightShiftLenLSB <= '0' when ShRotImm='1' else        -- Rotate 8-bit immediate 
                    ShLenImm(ShLenImm'low); 
 
LeftShifterLen  <= ShLenImm when ShType(0)='0' else  --  Left immediate shift 
	               ShLenRs(LeftShifterLen'range);	 --  Left register shift 
	 
RightShifterLen <= ShLenImm(ShLenImm'high downto ShLenImm'low+1)&RightShiftLenLSB when ShType(0)='0' or ShRotImm='1' else  --  Right immediate shift 
	               ShLenRs(LeftShifterLen'range);	  --  Right register shift 
					 
RightShifter(0) <= "000000000000000000000000"&ShBBusIn(7 downto 0) when ShRotImm='1' else -- Rotate 8-bit immediate 
                   ShBBusIn; 
 
LeftShifter(0) <= ShBBusIn;	 
LeftShifterMUX(0)  <= LeftShifter(0); 
RightShifterMUX(0) <= RightShifter(0); 
 
LeftCarryMUX(0) <= ShCFlagIn; 
RightCarryMUX(0) <= ShCFlagIn; 
 
ShifterLogic:for i in 1 to 31 generate	 
-- Left shift logic 
LeftShifter(i) <= LeftShifter(i-1)(30 downto 0)&'0'; 
 
-- Right shift logic 
RightShifter(i) <= VacatedBitsR(i)&RightShifter(i-1)(31 downto 1); 
 
VacatedBitsR(i) <= RightShifter(i-1)(0) when ShType(2 downto 1)="11" or ShRotImm='1' else  -- Rotate right ROR 
				   ShBBusIn(ShBBusIn'high) when ShType(2 downto 1)="10" else               -- Arithmetical shift right (MSB) ASR 
				   '0' when ShType(2)='0' else                                             -- Logical shift right LSR 
				   CDnCr;   
 
-- Left shift output MUX				    
LeftShifterMUX(i) <= LeftShifter(i) when  i=LeftShifterLen else 						   -- LSL 
	                 LeftShifterMUX(i-1); 
						  
-- Right shift output MUX				   					  
RightShifterMUX(i) <= RightShifter(i) when  i=RightShifterLen else  
	                  RightShifterMUX(i-1); 
 
-- Carry bit logic 
LeftCarryMUX(i)  <= LeftShifter(i-1)(31) when i=LeftShifterLen else  -- Rm[32-shift_imm]/Rm[32-Rs[7:0]] 
				    LeftCarryMUX(i-1);                   					   
 
RightCarryMUX(i) <= RightShifter(i-1)(0) when i=RightShifterLen else  -- Rm[shift_imm-1]/Rm[Rs[7:0]-1] 
				    RightCarryMUX(i-1); 
					   
end generate;	 
 
ShOutInt <= RightShifterMUX(RightShifterMUX'high) when ShRotImm='1' else -- Immediate rotate 
	                (others => '0') when ((ShType="001" or ShType="011") and ShLenRs(7 downto 5)/="000")or -- (LSL(R) + LSR(R)) & Rm[7:0]>31 
                                          (ShType="010" and ShLenImm="00000") else                         -- LSR(I) & shift_imm==0            
					(others => ShBBusIn(ShBBusIn'high)) when (ShType="100" and ShLenImm="00000")or 		   -- ASR(I) & shift_imm==0)+(ASR(R) & Rs[7:0]>31 
															 (ShType="101" and ShLenRs(7 downto 5)/="000")else -- ASR(R) & Rs[7:0]>31 
                    (ShCFlagIn&ShBBusIn(31 downto 1)) when ShType="110" and ShLenImm="00000" else  -- RRX             
					RightShifterMUX(RightShifterMUX'high) when (ShType(2) or ShType(1))='1' else   -- LSR/ASR/ROR 
					LeftShifterMUX(LeftShifterMUX'high) when ShType(2 downto 1)="00" else          -- LSL 
					(others => CDnCr);	 
 
-- Output of C Flag 
ShCFlagOutInt <= RightCarryMUX(RightCarryMUX'high) when ShRotImm='1' and ShLenImm(ShLenImm'high downto 1)="0000" else -- Immediate rotate and rotate_imm==0 
			     ShOutInt(ShOutInt'high) when ShRotImm='1' and ShLenImm(ShLenImm'high downto 1)/="0000" else -- Immediate rotate and rotate_imm!=0		 
			     ShBBusIn(ShBBusIn'low) when  (ShType="001" and ShLenRs=32)or(ShType="110" and ShLenRs=x"00")  else -- (LSL(R) & Rs[7:0]==32)+(ROR(I)&shift_&imm==0) 
			     ShBBusIn(ShBBusIn'high) when ((ShType="010" or ShType="100") and ShLenImm="00000") or -- (LSR(I)+ASR(I))&shift_imm==0 
			                                   (ShType="101" and ShLenRs(7 downto 5)/="000") or 		-- ASR(R)&Rs[7:0]>=32 
			                                   (ShType="111" and ShLenRs(7 downto 5)/="000" and ShLenRs(4 downto 0)="00000") else -- ROR(R)&Rs[7:5]!=0&Rs[4:0]==0 
			     '0' when (ShType="001" or ShType="011")and ShLenRs>32 else -- (LSL(R) + LSR(R)) & Rs[7:0]>32                      
			     RightCarryMUX(RightCarryMUX'high) when (ShType(2) or ShType(1))='1' else -- LSR/ASR/ROR 
				 LeftCarryMUX(LeftShifterMUX'high) when ShType(2 downto 1)="00" else -- LSL 
				 CDnCr;	   
					 
ShOut <= ShOutInt when ShEn='1' else ShBBusIn; 
ShCFlagOut <= ShCFlagOutInt when ShCFlagEn='1' else ShCFlagIn; 
	 
end RTL; 
