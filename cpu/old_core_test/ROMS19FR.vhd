-- *********************************************************************************************				   
-- ROM initialized by .S19 (S-record) file 
-- Modified 01.02.2003 
-- Designed by Ruslan Lepetenok 
-- *********************************************************************************************				   
 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
use IEEE.std_logic_arith.all; 
 
use STD.textio.all; 
 
use WORK.S19FRPackage.all; 
 
entity ROMS19FR is generic( 
								ROMWidth   : positive  := 32; 
                                ROMSize    : positive  := 4096;  
	                            InFileName : string    := "test.s19"; 
	                            BaseAdr    : natural   := 16#300000#; 
                                BigEndian  : boolean   := FALSE; 
	                           	ROMBlank   : std_logic := '0'; 
							    DisChSTest : boolean   := FALSE    
						  ); 
		                port( 
					         Address   : in  std_logic_vector(LOG2(ROMSize/(ROMWidth/8))-1 downto 0); 
		                     DataOut   : out std_logic_vector(ROMWidth-1 downto 0) 
					        ); 
end ROMS19FR; 
 
architecture Beh of ROMS19FR is 
type MemFileType is array(0 to ROMSize/(ROMWidth/8)-1) of std_logic_vector(ROMWidth-1 downto 0); 
signal ROMFile : MemFileType := (others => (ROMWidth-1 downto 0 => '0')); 
 
begin 
 
assert not DisChSTest  
 report"Check-Sum test is disabled" 
  severity WARNING;	 
	 
InitMemory:process 
 
procedure ReadS19ToMem(MemFile : inout MemFileType; FileName : in string;  
                       BaseAdr : natural; BigEndian : boolean)is 
 
file InputTextFile   : text open read_mode is FileName; 
variable L           : line; 
variable ch          : character; 
variable j           : natural := 0; 
variable k           : natural range 0 to 1 :=0; 
variable LT          : character; 
variable Address     : integer := 0; 
variable LineAdrSize : positive := 1; 
variable DataByte    : natural range 0 to 16#FF# := 0; 
variable LineLength  : natural range 0 to 16#FF# := 0; 
variable CheckSum    : std_logic_vector(7 downto 0) := x"00"; -- Checksum which was calculated  
variable CheckSumRd  : std_logic_vector(7 downto 0) := x"00"; -- Checksum which was read 
 
begin 
 
while not endfile(InputTextFile) loop 
readline(InputTextFile,L); 
 
-- Searching for 'S' 
for i in L'range loop 
read(L,ch); 
if ch/=' ' then 
 if ch/='S' then  
   report "Not a S-record string" severity FAILURE;	  
 else exit; 
  end if; 
  end if;	  
end loop;	 
 
-- Reading of line type   
read(L,LT); 
if LT<'0' or LT>'9' then  
 report "Not a S-record string" severity FAILURE;	  
end if; 
 
-- Read line length (in bytes) 
read(L,ch); 
LineLength := CharToNatural(ch)*16; 
read(L,ch); 
LineLength := LineLength + CharToNatural(ch); 
 
CheckSum := CONV_STD_LOGIC_VECTOR(LineLength,8); 
 
if LT='1' or LT='2' or LT='3' then   
-- Calculate base address for the line 
Address := 0; 
k:=1; 
 ReadStrAdr:for j in (CharToNatural(LT)+1)*2-1 downto 0 loop 
  read(L,ch); 
   Address := Address + CharToNatural(ch)*(16**j); 
   CheckSum := CheckSum + CONV_STD_LOGIC_VECTOR(CharToNatural(ch)*(16**k),8); 
 
 if k=1 then k:=0;  
  else k:=1; 
   end if;	  
 
 end loop;	 
 
-- Calculates real address 
assert BaseAdr<=Address 
 report"Wrong base address" 
  severity FAILURE; 
 
 Address := Address - BaseAdr; 
 
assert Address<=ROMSize-1 
 report"ROM size is not enough  to fit source S-record file" 
  severity FAILURE;    
       
for j in 1 to LineLength-(CharToNatural(LT)+2) loop -- Number of data bytes to read 
 
-- Read byte of data  
read(L,ch); 
 DataByte := CharToNatural(ch)*16; 
  read(L,ch); 
   DataByte := DataByte + CharToNatural(ch); 
 
CheckSum := CheckSum + CONV_STD_LOGIC_VECTOR(DataByte,8); 
 
--ROMWidth 8/16/32 
if ROMWidth=32 then  
 -- 32-bit memory system 
 
 if not BigEndian then  
 -- Little endian 
 
if CONV_STD_LOGIC_VECTOR(Address,2)="00" then  
 -- A[1..0]=00 
 
 MemFile(Address/4) := MemFile(Address/4)(31 downto 8)& 
                       CONV_STD_LOGIC_VECTOR(DataByte,8);  
  
elsif CONV_STD_LOGIC_VECTOR(Address,2)="01" then  
 -- A[1..0]=01 
 MemFile(Address/4) := MemFile(Address/4)(31 downto 16)& 
	                   CONV_STD_LOGIC_VECTOR(DataByte,8)& 
	  				   MemFile(Address/4)(7 downto 0);   
 
elsif CONV_STD_LOGIC_VECTOR(Address,2)="10" then 						  
 -- A[1..0]=10 
   MemFile(Address/4) := MemFile(Address/4)(31 downto 24)& 
    	                 CONV_STD_LOGIC_VECTOR(DataByte,8)& 
                         MemFile(Address/4)(15 downto 0);    
  
elsif CONV_STD_LOGIC_VECTOR(Address,2)="11" then 						  
 -- A[1..0]=11 
 MemFile(Address/4) := CONV_STD_LOGIC_VECTOR(DataByte,8)& 
	                   MemFile(Address/4)(23 downto 0); 
 end if; 
  
 else                   
  -- Big endian 	 
 
if CONV_STD_LOGIC_VECTOR(Address,2)="11" then  
 -- A[1..0]=11 
 
 MemFile(Address/4) := MemFile(Address/4)(31 downto 8)& 
                       CONV_STD_LOGIC_VECTOR(DataByte,8);  
  
elsif CONV_STD_LOGIC_VECTOR(Address,2)="10" then  
 -- A[1..0]=10 
 MemFile(Address/4) := MemFile(Address/4)(31 downto 16)& 
	                   CONV_STD_LOGIC_VECTOR(DataByte,8)& 
	  				   MemFile(Address/4)(7 downto 0);   
 
elsif CONV_STD_LOGIC_VECTOR(Address,2)="01" then 						  
 -- A[1..0]=01 
   MemFile(Address/4) := MemFile(Address/4)(31 downto 24)& 
    	                 CONV_STD_LOGIC_VECTOR(DataByte,8)& 
                         MemFile(Address/4)(15 downto 0);    
  
elsif CONV_STD_LOGIC_VECTOR(Address,2)="00" then 						  
 -- A[1..0]=00 
 MemFile(Address/4) := CONV_STD_LOGIC_VECTOR(DataByte,8)& 
	                   MemFile(Address/4)(23 downto 0); 
 end if; 
 end if;  
 
 elsif ROMWidth=16 then  
 -- 16-bit memory system 
  
 if not BigEndian then  
 -- Little endian 
 
if CONV_STD_LOGIC_VECTOR(Address,1)="0" then  
 -- A[0]=0 
 
 MemFile(Address/2) := MemFile(Address/2)(16 downto 8)& 
                       CONV_STD_LOGIC_VECTOR(DataByte,8);  
  
 elsif CONV_STD_LOGIC_VECTOR(Address,1)="1" then 						  
  -- A[0]=1 
  MemFile(Address/2) := CONV_STD_LOGIC_VECTOR(DataByte,8)& 
    	                MemFile(Address/2)(7 downto 0); 
 end if; 
  
 else                   
  -- Big endian 	 
  
 if CONV_STD_LOGIC_VECTOR(Address,1)="1" then  
 -- A[0]=1 
 
 MemFile(Address/2) := MemFile(Address/2)(16 downto 8)& 
                       CONV_STD_LOGIC_VECTOR(DataByte,8);  
  
 elsif CONV_STD_LOGIC_VECTOR(Address,1)="0" then 						  
  -- A[0]=0 
  MemFile(Address/2) := CONV_STD_LOGIC_VECTOR(DataByte,8)& 
    	                MemFile(Address/2)(7 downto 0); 
  
 end if; 
 end if;  
   
elsif ROMWidth=8 then  
 -- 8-bit memory system	 
 MemFile(Address) := CONV_STD_LOGIC_VECTOR(DataByte,8); 
end if;	 
 
Address := Address + 1; 
 
end loop;  -- Data bytes reading is finished for current string 
 
else      -- Not a data line (S0,S4-S9) 
 
 -- Dummy read 	 
 for j in 1 to LineLength-1 loop -- Number of data bytes to read	 
  -- Read byte of data  
   read(L,ch); 
    DataByte := CharToNatural(ch)*16; 
     read(L,ch); 
      DataByte := DataByte + CharToNatural(ch); 
	   -- Checksum 
        CheckSum := CheckSum + CONV_STD_LOGIC_VECTOR(DataByte,8);	 
 end loop;	 
end if; 
 
-- Checksum comparison 
-- Read byte of checksum 
read(L,ch); 
DataByte := CharToNatural(ch)*16; 
read(L,ch); 
DataByte := DataByte + CharToNatural(ch); 
 
CheckSum := not CheckSum; 
 
if not DisChSTest then 
assert CheckSum = CONV_STD_LOGIC_VECTOR(DataByte,8) 
 report "Error in checksum"	  
  severity FAILURE; 
end if; 
   
end loop; -- Reading of the file is finished	 
 
report "S19 file read is done"	  
  severity NOTE; 
 
end ReadS19ToMem;					    
-- End of procedures 
 
variable MemoryFile : MemFileType := (others => (ROMWidth-1 downto 0 => ROMBlank)); 
 begin 
  ReadS19ToMem(MemoryFile,InFileName,BaseAdr,BigEndian); 
   ROMFile <= MemoryFile; 
    wait; 
end process; 
 
DataOut <= ROMFile(CONV_INTEGER(Address)); 
	 
end Beh; 
