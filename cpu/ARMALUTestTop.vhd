--**************************************************************************************************** 
-- ALU tester top entity for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 09.11.2002 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
 
entity ARMALUTestTop is 
end ARMALUTestTop; 
  
architecture STRUCT of ARMALUTestTop is 
 
component ClockAndResetGenerator is port ( 
	                                      nRESET  : out std_logic; 
						                  CLK     : out std_logic 
						                  ); 
end component;							 
 
component ALUTesterSim is port ( 
	                    nRESET  : in std_logic; 
						CLK    : in std_logic; 
						 
						ADataOut   : out  std_logic_vector(31 downto 0);  
						BDataOut   : out  std_logic_vector(31 downto 0);  
						InvA	   : out  std_logic; 
						InvB	   : out  std_logic; 
						PassA	   : out  std_logic; 
						PassB	   : out  std_logic;	-- MOV/MVN operations 
						-- Logic operations 
						AND_Op	   : out  std_logic; 
						ORR_Op	   : out  std_logic; 
						EOR_Op	   : out  std_logic; 
						-- Tester flag outputs						 
						CFlagOut   : out  std_logic; 
						CFlagUse   : out  std_logic  -- ADC/SBC/RSC instructions 
						     ); 
end component; 
 
component ALU is port ( 
	                    ADataIn    : in  std_logic_vector(31 downto 0);  
						BDataIn    : in  std_logic_vector(31 downto 0);  
						DataOut    : out std_logic_vector(31 downto 0);  
						InvA	   : in  std_logic; 
						InvB	   : in  std_logic; 
						PassA	   : in  std_logic; 
						PassB	   : in  std_logic;	-- MOV/MVN operations 
						-- Logic operations 
						AND_Op	   : in  std_logic; 
						ORR_Op	   : in  std_logic; 
						EOR_Op	   : in  std_logic; 
						-- Flag inputs						 
						CFlagIn	   : in  std_logic; 
						CFlagUse   : in  std_logic; -- ADC/SBC/RSC instructions 
						-- Flag outputs 
						CFlagOut    : out  std_logic; 
						VFlagOut    : out  std_logic; 
						NFlagOut    : out  std_logic; 
						ZFlagOut    : out  std_logic 
				    ); 
end component;		  
 
 
-- Signal declarations 
signal nRESET    : std_logic := '0'; 
signal CLK      : std_logic := '0'; 
 
signal ADataBus : std_logic_vector(31 downto 0) := (others => '0');  
signal BDataBus : std_logic_vector(31 downto 0) := (others => '0');  
signal InvA	    : std_logic := '0'; 
signal InvB	    : std_logic := '0'; 
signal PassA	: std_logic := '0'; 
signal PassB	: std_logic := '0'; 
 
signal AND_Op	: std_logic := '0'; 
signal ORR_Op	: std_logic := '0'; 
signal EOR_Op   : std_logic := '0'; 
 
signal CFlag	: std_logic := '0'; 
signal CFlagUse : std_logic := '0';  
 
 
begin 
 
CLK_And_nRESET:component ClockAndResetGenerator port map ( 
	                                      nRESET  => nRESET, 
						                  CLK    => CLK 
						                  ); 
 
 
Tester:component ALUTesterSim  port map ( 
	                    nRESET   => nRESET, 
						CLK     => CLK, 
						 
						ADataOut => ADataBus, 
						BDataOut => BDataBus, 
						InvA	 => InvA, 
						InvB	 => InvB, 
						PassA	 => PassA, 
						PassB	 => PassB, 
						-- Logic operations 
						AND_Op	 => AND_Op, 
						ORR_Op	 => ORR_Op, 
						EOR_Op	 => EOR_Op, 
						-- Flag inputs						 
						CFlagOut => CFlag, 
						CFlagUse => CFlagUse 
						     ); 
 
 
ALUUnderTest:component ALU port map( 
	                    ADataIn => ADataBus, 
						BDataIn => BDataBus, 
						DataOut => open, 
						InvA	=> InvA, 
						InvB	=> InvB, 
						PassA	 => PassA, 
						PassB	=> PassB, 
						-- Logic operations 
						AND_Op	=> AND_Op, 
						ORR_Op	=> ORR_Op, 
						EOR_Op	=> EOR_Op, 
						-- Flag inputs						 
						CFlagIn	=> CFlag, 
						CFlagUse => CFlagUse, 
						-- Flag outputs 
						CFlagOut => open, 
						VFlagOut => open, 
						NFlagOut => open, 
						ZFlagOut => open 
				    ); 
 
end STRUCT; 

