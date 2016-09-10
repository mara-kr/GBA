
--**************************************************************************************************** 
-- Data multiplexer for ARM memory sybsistem 
-- Designed by Ruslan Lepetenok 
-- Modified 07.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity DataMux is port ( 
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
end DataMux; 
 
architecture RTL of DataMux is 
begin 
	 
DataOutMultiplexer:for i in DataOut'range	generate 
  DataOut(i) <= (DataAIn(i) and SelDevA)or 
                (DataBIn(i) and SelDevB)or 
                (DataCIn(i) and SelDevC)or 
                (DataDIn(i) and SelDevD); 
end generate;	 
	 
end RTL; 
