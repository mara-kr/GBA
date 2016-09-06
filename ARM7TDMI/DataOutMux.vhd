--**************************************************************************************************** 
-- Data out register for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 04.12.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity DataOutMux is port( 
						-- Control signals 
						StoreHalfWord : in  std_logic; 
						StoreByte	  : in  std_logic; 
						BigEndianMode : in  std_logic;  
						-- Data signals  
						DataIn        : in  std_logic_vector(31 downto 0); 
						WDATA         : out std_logic_vector(31 downto 0) 
						       ); 
 
end DataOutMux; 
 
architecture RTL of DataOutMux is 
 
 
signal ByteReplication     : std_logic_vector(DataIn'range) := (others => '0'); 
signal HalfWordReplication : std_logic_vector(DataIn'range) := (others => '0'); 
signal WrDataMux           : std_logic_vector(WDATA'range) := (others => '0'); 
 
begin 
 
ByteReplication <= DataIn(7 downto 0)&DataIn(7 downto 0)&DataIn(7 downto 0)&DataIn(7 downto 0);	 
HalfWordReplication <= DataIn(15 downto 0)&DataIn(15 downto 0); 
 
WriteDataMultiplexer:for i in WrDataMux'range generate  
WrDataMux(i) <= (ByteReplication(i) and StoreByte)or              -- Store byte 
                (HalfWordReplication(i) and StoreHalfWord)or	  -- Store halfword 
				(DataIn(i) and not(StoreByte or StoreHalfWord));  -- Store word 
end generate; 
 
-- Little endian to Big endian convertion ?? 
WDATA <= WrDataMux when BigEndianMode='0' else                                                          -- Little endian mode 
		 WrDataMux(7 downto 0)&WrDataMux(15 downto 8)&WrDataMux(23 downto 16)&WrDataMux(31 downto 24);	-- Big endian mode 
 
end RTL;
