--**************************************************************************************************** 
-- Multiplier tester top entity for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 27.01.2003 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity ARMMultiplierTestTop is 
end ARMMultiplierTestTop; 
 
architecture Struct of ARMMultiplierTestTop is 
 
component ClockAndResetGenerator is port ( 
	                                      nRESET  : out std_logic; 
						                  CLK     : out std_logic 
						                  ); 
end component;							 
 
component MultiplierTesterSim is port (  
						   -- Global signals 
	                       nRESET      : in  std_logic; 
						   CLK         : in  std_logic; 
						   CLKEN       : out std_logic; 
	                       -- Data outputs 
	                       ADataOut    : out std_logic_vector(31 downto 0); -- RdHi(Rn)/Rs data path  
						   BDataOut    : out std_logic_vector(31 downto 0); -- RdLo(Rd)/Rm data path 
						   -- Control outputs 
						   LoadRsRm    : out std_logic; -- Load Rs and Rm and start 
						   LoadPS      : out std_logic; -- Load partial sum register with RHi:RLo    
						   ClearPSC    : out std_logic; -- Clear prtial sum register 
						   UnsignedMul : out std_logic; -- Unsigned multiplication 
						   ReadLH	   : out std_logic;	-- 0 - Read PS/PC low,1 - Read PS/PC high 
						   -- Control inputs 
						   MulResRdy   : in  std_logic  -- Multiplication result is ready 
						   ); 
end component; 
 
component MultiplierTestAdder is port( 
						   -- Global signals 
	                       nRESET      : in  std_logic; 
						   CLK         : in  std_logic; 
						   CLKEN       : in std_logic; 
	                       -- Data inputs 
	                       ADataIn     : in std_logic_vector(31 downto 0); 
						   BDataIn     : in std_logic_vector(31 downto 0); 
						   -- Control inputs 
						   ReadLH      : in  std_logic; 
						   MulResRdy   : in  std_logic 
						   ); 
end component; 
 
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
 
-- Signal declarations 
signal nRESET  : std_logic := '0'; 
signal CLK     : std_logic := '0'; 
signal CLKEN   : std_logic := '0'; 
 
signal TesterADataOut : std_logic_vector(31 downto 0) := (others => '0'); 
signal TesterBDataOut : std_logic_vector(31 downto 0) := (others => '0'); 
signal TesterADataIn  : std_logic_vector(31 downto 0) := (others => '0'); 
signal TesterBDataIn  : std_logic_vector(31 downto 0) := (others => '0'); 
 
signal LoadRsRm    : std_logic := '0'; 
signal LoadPS      : std_logic := '0'; 
signal ClearPSC     : std_logic := '0'; 
signal UnsignedMul : std_logic := '0'; 
signal ReadLH	   : std_logic := '0'; 
signal MulResRdy   : std_logic := '0'; 
 
begin 
 
CLK_And_nRESET:component ClockAndResetGenerator port map( 
	                                      nRESET => nRESET, 
						                  CLK   => CLK 
						                  ); 
 
Tester:component MultiplierTesterSim port map(  
						   -- Global signals 
	                       nRESET      => nRESET, 
						   CLK         => CLK, 
						   CLKEN       => CLKEN, 
	                       -- Data outputs 
	                       ADataOut    => TesterADataOut, 
						   BDataOut    => TesterBDataOut, 
						   -- Control outputs 
						   LoadRsRm    => LoadRsRm, 
						   LoadPS      => LoadPS, 
						   ClearPSC    => ClearPSC, 
						   UnsignedMul => UnsignedMul, 
						   ReadLH	   => ReadLH, 
						   -- Control inputs 
						   MulResRdy   => MulResRdy 
						   ); 
						    
MultiplierUnderTest:component Multiplier port map(  
						   -- Global signals 
	                       nRESET      => nRESET, 
						   CLK         => CLK, 
						   CLKEN       => CLKEN, 
	                       -- Data inputs 
	                       ADataIn     => TesterADataOut, 
						   BDataIn     => TesterBDataOut, 
						   -- Data outputs 
						   ADataOut    => TesterADataIn, 
						   BDataOut    => TesterBDataIn, 
						   -- Control inputs 
						   LoadRsRm    => LoadRsRm, 
						   LoadPS      => LoadPS, 
						   ClearPSC    => ClearPSC, 
						   UnsignedMul => UnsignedMul, 
						   ReadLH	   => ReadLH, 
						   -- Control outputs 
						   MulResRdy   => MulResRdy 
						   ); 
 
MultiplierTestAdder_Inst:component MultiplierTestAdder port map( 
						   -- Global signals 
	                       nRESET      => nRESET, 
						   CLK         => CLK, 
						   CLKEN       => CLKEN, 
	                       -- Data inputs 
	                       ADataIn     => TesterADataIn, 
						   BDataIn     => TesterBDataIn, 
						   -- Control inputs 
						   ReadLH      => ReadLH, 
						   MulResRdy   => MulResRdy 
						   ); 
 
 
 
 
end Struct; 

