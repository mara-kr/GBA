--**************************************************************************************************** 
-- Multiplier for ARM core 
-- Designed by Ruslan Lepetenok 
-- Modified 12.02.2003 
--**************************************************************************************************** 
library	IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
entity Multiplier is port (  
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
end Multiplier; 
 
architecture Struct of Multiplier is 
 
-- Multiplier control and partial sum/carry registers 
component MulCtrlAndRegs is generic(EarlyTermination : boolean); 
	                     port( 
						   -- Global signals 
	                       nRESET          : in  std_logic; 
						   CLK             : in  std_logic; 
						   CLKEN           : in  std_logic; 
	                       -- Interface for the 32x8 combinatorial multiplier  
	                       Rs9Out          : out std_logic_vector(8 downto 0); 
	                       PartialSumOut   : out std_logic_vector(63 downto 0); -- ??? Size  
						   PartialCarryOut : out std_logic_vector(63 downto 0); -- ??? Size  
						   PartialSumIn    : in  std_logic_vector(63 downto 0); -- ??? Size  
						   PartialCarryIn  : in  std_logic_vector(63 downto 0); -- ??? Size  
						   PP4P            : out std_logic; 
		                   PP4M            : out std_logic; 
		                   -- Data inputs 
	                       ADataIn         : in  std_logic_vector(31 downto 0); -- RdHi(Rn)/Rs data path  
						   BDataIn         : in  std_logic_vector(31 downto 0); -- RdLo(Rd)/Rm data path 
						   -- Control inputs 
						   LoadRsRm        : in  std_logic;  -- Load Rs and Rm and start 
						   LoadPS          : in  std_logic;  -- Load partial sum register with RHi:RLo    
						   ClearPSC        : in  std_logic;  -- Clear prtial sum register 
						   UnsignedMul     : in  std_logic;  -- Unsigned multiplication 
						   ReadLH	       : in  std_logic;	-- 0 - Read PS/PC low,1 - Read PS/PC high 
						   -- Control outputs 
						   MulResRdy       : out std_logic; -- Multiplication result is ready 
						   -- Result 
						   ResPartSum      : out std_logic_vector(31 downto 0); 
						   ResPartCarry    : out std_logic_vector(31 downto 0) 
						      ); 
end component; 
 
 
component Mul32x8Comb is port (  
							 RmIn            : in  std_logic_vector(31 downto 0); 
	                         Rs9In           : in  std_logic_vector(8 downto 0); 
							 PartialSumIn    : in  std_logic_vector(63 downto 0);  
							 PartialCarryIn  : in  std_logic_vector(63 downto 0); 
							 PartialSumOut   : out std_logic_vector(63 downto 0); 
							 PartialCarryOut : out std_logic_vector(63 downto 0); 
							 UMul            : in  std_logic;                      
							 PP4P            : in  std_logic; 
		                     PP4M            : in  std_logic 
	                          ); 
end component; 
 
 
-- Signal declarations 
 
signal RmIn            : std_logic_vector(31 downto 0) := (others => '0'); 
signal Rs9In           : std_logic_vector(8 downto 0)  := (others => '0'); 
signal PartialSumIn    : std_logic_vector(63 downto 0) := (others => '0'); 
signal PartialCarryIn  : std_logic_vector(63 downto 0) := (others => '0'); 
signal PartialSumOut   : std_logic_vector(63 downto 0) := (others => '0'); 
signal PartialCarryOut : std_logic_vector(63 downto 0) := (others => '0'); 
signal PP4P            : std_logic  := '0';                    
signal PP4M            : std_logic  := '0';                    
 
begin 
 
	 
ControlAndRegs:component MulCtrlAndRegs generic map(EarlyTermination => TRUE) 
	                     port map( 
						   -- Global signals 
	                       nRESET          => nRESET, 
						   CLK             => CLK, 
						   CLKEN           => CLKEN, 
	                       -- Interface for the 32x8 combinatorial multiplier  
	                       Rs9Out          => Rs9In, 
	                       PartialSumOut   => PartialSumIn, 
						   PartialCarryOut => PartialCarryIn, 
						   PartialSumIn    => PartialSumOut, 
						   PartialCarryIn  => PartialCarryOut, 
                           PP4P            => PP4P, 
						   PP4M			   => PP4M, 
                           -- Data inputs 
	                       ADataIn         => ADataIn, 
						   BDataIn         => BDataIn, 
						   -- Control inputs 
						   LoadRsRm        => LoadRsRm, 
						   LoadPS          => LoadPS, 
						   ClearPSC        => ClearPSC, 
						   UnsignedMul     => UnsignedMul, 
						   ReadLH	       => ReadLH, 
						   -- Control outputs 
						   MulResRdy       => MulResRdy, 
						   -- Result 
						   ResPartSum      => ADataOut, 
						   ResPartCarry    => BDataOut 
						      ); 
 
MultComb:component Mul32x8Comb port map(  
							 RmIn            => BDataIn, 
	                         Rs9In           => Rs9In, 
	                         PartialSumIn    => PartialSumIn, 
							 PartialCarryIn  => PartialCarryIn, 
							 PartialSumOut   => PartialSumOut, 
							 PartialCarryOut => PartialCarryOut, 
							 UMul            => UnsignedMul, 
	                         PP4P            => PP4P, 
		                     PP4M            => PP4M 
						   ); 
 
end Struct; 
