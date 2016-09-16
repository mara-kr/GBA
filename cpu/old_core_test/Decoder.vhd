--**************************************************************************************************** 
-- Address decoder and write enable logic for ARM core simualtion 
-- Designed by Ruslan Lepetenok 
-- Modified 11.01.2003 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
use Work.ARMSMSSPackage.all; 
use WORK.ARMPackage.all; 
 
entity Decoder is 	 generic(AddressA : std_logic_vector(DecoderAdrWidth-1 downto 0); 
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
end Decoder; 
 
architecture RTL of Decoder is 
begin 
 
-- SIZE[1:0]  Transfer Width 
--   00           Byte	 
--	 01			  Halfword 
--	 10			  Word 
--   11			  Reserved 
	 
 
ByteWE(0) <= '1' when WRITE_In= '1' and ((ADDR_In(1 downto 0)="00" and SIZE_In=CTS_B)or 
                      (ADDR_In(1)='0'and SIZE_In=CTS_HW)or 
					   SIZE_In=CTS_W) else '0'; 
 
ByteWE(1) <= '1' when WRITE_In= '1' and ((ADDR_In(1 downto 0)="01" and SIZE_In=CTS_B)or 
                      (ADDR_In(1)='0'and SIZE_In=CTS_HW)or 
					   SIZE_In=CTS_W) else '0'; 
 
ByteWE(2) <= '1' when WRITE_In= '1' and ((ADDR_In(1 downto 0)="10" and SIZE_In=CTS_B)or 
                      (ADDR_In(1)='1'and SIZE_In=CTS_HW)or 
					   SIZE_In=CTS_W) else '0';						    
						    
ByteWE(3) <= '1' when WRITE_In= '1' and ((ADDR_In(1 downto 0)="11" and SIZE_In=CTS_B)or 
                      (ADDR_In(1)='1'and SIZE_In=CTS_HW)or 
					   SIZE_In=CTS_W) else '0'; 
						    
						    
SelDevA <= '1' when AddressA=ADDR_In(ADDR_In'high downto ADDR_In'length-DecoderAdrWidth) else '0';  
SelDevB <= '1' when AddressB=ADDR_In(ADDR_In'high downto ADDR_In'length-DecoderAdrWidth) else '0';  
SelDevC <= '1' when AddressC=ADDR_In(ADDR_In'high downto ADDR_In'length-DecoderAdrWidth) else '0'; 
SelDevD <= '1' when AddressD=ADDR_In(ADDR_In'high downto ADDR_In'length-DecoderAdrWidth) else '0'; 	 
	 
end RTL; 
