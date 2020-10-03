----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:09:00 10/03/2020 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           instr_addr : out  STD_LOGIC_VECTOR (31 downto 0);
           dataRead : in  STD_LOGIC_VECTOR (31 downto 0);
			  dataWrite : out STD_LOGIC_VECTOR(31 downto 0);
           dataAddr : out  STD_LOGIC_VECTOR (31 downto 0);
           memWriteOut : out  STD_LOGIC;
           memReadOut : out  STD_LOGIC;
			  debug : out STD_LOGIC_VECTOR(31 downto 0));
end CPU;

architecture Behavioral of CPU is

COMPONENT ALU
    PORT(
         in1 : IN  std_logic_vector(31 downto 0);
         in2 : IN  std_logic_vector(31 downto 0);
         ALUctrl : IN  std_logic_vector(3 downto 0);
         clock : IN  std_logic;
         result : INOUT  std_logic_vector(31 downto 0);
         zero : OUT  std_logic
        );
END COMPONENT;
COMPONENT ALUController
    PORT(
         ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
         Func  : in  STD_LOGIC_VECTOR (5 downto 0);
         Output : out  STD_LOGIC_VECTOR (3 downto 0)
        );
END COMPONENT;
COMPONENT Controller
    PORT(
         clock : IN  std_logic;
         enable : IN  std_logic;
         op_code : IN  std_logic_vector(5 downto 0);
         RegDst : OUT  std_logic;
         Jump : OUT  std_logic;
         Branch : OUT  std_logic;
         MemRead : OUT  std_logic;
         MemToReg : OUT  std_logic;
         MemWrite : OUT  std_logic;
         ALUOp : OUT  std_logic_vector(1 downto 0);
         ALUSrc : OUT  std_logic;
         RegWrite : OUT  std_logic
        );
END COMPONENT;
COMPONENT HazardBuffer
    PORT(
         enable : IN  std_logic;
         writeReg : IN  std_logic_vector(4 downto 0);
         clock : IN  std_logic;
         reset : IN  std_logic;
         checkReg1 : IN  std_logic_vector(4 downto 0);
         checkReg2 : IN  std_logic_vector(4 downto 0);
         hazard : OUT  std_logic
        );
END COMPONENT;
COMPONENT PipeStep
	 GENERIC(K : INTEGER);
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         input : IN  std_logic_vector(K downto 0);
         output : OUT  std_logic_vector(K downto 0)
        );
END COMPONENT;
COMPONENT Registers
    PORT(
         reset : IN  std_logic;
         clock : IN  std_logic;
         regWrite : IN  std_logic;
         readReg1 : IN  std_logic_vector(4 downto 0);
         readReg2 : IN  std_logic_vector(4 downto 0);
         writeReg : IN  std_logic_vector(4 downto 0);
         writeData : IN  std_logic_vector(31 downto 0);
         readData1 : OUT  std_logic_vector(31 downto 0);
         readData2 : OUT  std_logic_vector(31 downto 0)
        );
END COMPONENT;
COMPONENT ProgramCounter
	 PORT(
	      clock : IN  STD_LOGIC;
		   reset : IN  STD_LOGIC;
			enable: IN  STD_LOGIC;
		   next_address : IN  STD_LOGIC_VECTOR (31 downto 0);
		   address : OUT  STD_LOGIC_VECTOR (31 downto 0)
		  );
END COMPONENT;
COMPONENT Mux21
	 PORT(
	      SEL : IN  STD_LOGIC;
		   A : IN  STD_LOGIC;
		   B : IN  STD_LOGIC;
		   O : OUT  STD_LOGIC
		  );
END COMPONENT;

signal no_op : STD_LOGIC := '0';
signal long_clock : STD_LOGIC := '0';
signal instr_address_sig : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal next_instr_address : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal part_instr_holder : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal immediate : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal shifted_imm : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal pipe1in : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal pipe1out : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal pipe2in : STD_LOGIC_VECTOR(124 downto 0) := (others => '0');
signal pipe2out : STD_LOGIC_VECTOR(124 downto 0) := (others => '0');
signal pipe2reset : STD_LOGIC := '0';
signal pipe3in : STD_LOGIC_VECTOR(106 downto 0) := (others => '0');
signal pipe3out : STD_LOGIC_VECTOR(106 downto 0) := (others => '0');
signal pipe3reset : STD_LOGIC := '0';
signal pipe4in : STD_LOGIC_VECTOR(70 downto 0) := (others => '0');
signal pipe4out : STD_LOGIC_VECTOR(70 downto 0) := (others => '0');
signal PCSrc : STD_LOGIC := '0';
signal PCIn : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RegDst : std_logic;
signal Jump : std_logic;
signal Branch : std_logic;
signal MemRead : std_logic;
signal MemToReg : std_logic;
signal MemWrite : std_logic;
signal ALUOp : std_logic_vector(1 downto 0);
signal ALUSrc : std_logic;
signal RegWrite : std_logic;
signal Branch_Addr : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal ReadData1 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal ReadData2 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal WriteReg : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Address ID Stage
signal WriteRegEx : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Address EX Stage
signal WriteRegMem : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Address MEM Stage
signal ALUMode : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal ALUIn2 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal ALUResult : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal zero : STD_LOGIC := '0';
signal RD2EXStage : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal BranchAddEx : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal MEMWBSigs : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
signal WBSigs : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal ALUResMem : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
signal finalWriteData : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal hazardEnable : STD_LOGIC := '0';
constant four : STD_LOGIC_VECTOR(2 downto 0) := "100";
signal Hazard : STD_LOGIC := '0';

begin

instr_addr <= instr_address_sig;

pipe1in <= instr_address_sig & instruction;
pipe2in <= MemToReg & RegWrite & Branch & MemWrite & MemRead & ALUOp & ALUSrc & next_instr_address & ReadData1 & ReadData2 & WriteReg & part_instr_holder;
pipe3in <= MEMWBSigs & BranchAddEx & zero & ALUResult & RD2EXStage & WriteRegEx;
pipe4in <= WBSigs & dataRead & ALUResMem & WriteRegMem;

dataAddr <= ALUResMem;
Branch_addr <= pipe3out(101 downto 70);

finalWriteData <= pipe4out(68 downto 37) when pipe4out(70) = '1' else
					  pipe4out(36 downto 5);
					 
debug <= "00000000000000000" & WriteRegMem & WriteRegEx & WriteReg;					 
no_op <= '1' when unsigned(pipe1out(31 downto 0)) = 0 else
			'0';
hazardEnable <= RegWrite and not no_op;
immediate <= "1111111111111111" & pipe2out(15 downto 0) when pipe2out(15) = '1' else
				 "0000000000000000" & pipe2out(15 downto 0);
				 
shifted_imm <= immediate(29 downto 0) & "00";				 

PCIn <= Branch_Addr when PCSrc = '1' else
		  ReadData1(29 downto 0) & "00" when Jump = '1' else
		  pipe1out(63 downto 32) when Hazard = '1' else
		  next_instr_address;

PCSRC <= pipe3out(104) and pipe3out(69);

ALUIn2 <= RD2EXStage when pipe2out(117) = '0' else -- pipe2out = ALUSrc
			  immediate;
			  
		  
PC : ProgramCounter
		PORT MAP(clock => clock,
					reset => reset,
					enable => long_clock,
					next_address => PCIn,
					address => instr_address_sig);

IF_ID : PipeStep -- Contains current instruction address & full current instruction (64 bits)
		GENERIC MAP(63)
		PORT MAP(clock => long_clock,
					reset => reset,
					input => pipe1in,
					output => pipe1out);
					
Regs : Registers
		PORT MAP(reset => reset,
					clock => long_clock,
					regWrite => pipe4out(69),
					readReg1 => pipe1out(25 downto 21),
					readReg2 => pipe1out(20 downto 16),
					writeReg => pipe4out(4 downto 0),
					writeData => finalWriteData,
					readData1 => ReadData1,
					readData2 => ReadData2);
					
Control : Controller
		PORT MAP(clock => clock,
					enable => long_clock,
					op_code => pipe1out(31 downto 26),
					RegDst => RegDst,
					Jump => Jump,
					Branch => Branch,
					MemRead => MemRead,
					MemToReg => MemToReg,
					MemWrite => MemWrite,
					ALUOp => ALUOp,
					ALUSrc => ALUSrc,
					RegWrite => RegWrite);
					
HazardDetector : HazardBuffer
		PORT MAP(enable => hazardEnable,
					writeReg => WriteReg,
					clock => long_clock,
					reset => reset,
					checkReg1 => pipe1out(25 downto 21),
					checkReg2 => pipe1out(20 downto 16),
					hazard => Hazard);
				  
ID_EX : PipeStep -- MemToReg, RegWrite, Branch, MemWrite, MemRead, ALUOp, ALUSrc, Next Instruction Address, ReadData1, ReadData2, WriteReg address, Current Instruction "Immediate"(15 downto 0)
		GENERIC MAP(124)
		PORT MAP(clock => long_clock,
					reset => pipe2reset,
					input => pipe2in,
					output => pipe2out);		  

ALUControl : ALUController
		PORT MAP(ALUOp => pipe2out(119 downto 118), -- change
					Func  => pipe2out(5 downto 0),
					Output => ALUMode);

Arith : ALU
		PORT MAP(in1 => pipe2out(84 downto 53),
					in2 => ALUIn2,
					ALUctrl => ALUMode,
					clock => long_clock,
					result => ALUResult,
					zero => zero);
        
EX_MEM : PipeStep -- MemToReg, RegWrite, Branch, MemWrite, MemRead, BranchAddr, Zero, ALUResult, ReadData2, WriteReg Address
		GENERIC MAP(106)
		PORT MAP(clock => long_clock,
					reset => pipe3reset,
					input => pipe3in,
					output => pipe3out);	
					
MEM_WB : PipeStep 
		GENERIC MAP(70)
		PORT MAP(clock => long_clock,
					reset => reset,
					input => pipe4in,
					output => pipe4out);	

clockProc : process(clock, reset)
begin
if(reset = '1') then
	long_clock <= '0';
elsif(falling_edge(clock)) then
	long_clock <= not long_clock;
elsif(rising_edge(clock)) then
	if(long_clock = '0') then -- should be used for saving pipe data to transfer to the next pipe as well as for MemStage
		next_instr_address <= std_logic_vector(unsigned(pipe1out(63 downto 32)) + unsigned(four));
		part_instr_holder <= pipe1out(15 downto 0);
		if(RegDst = '0') then
			WriteReg <= pipe1out(20 downto 16);
		else
			WriteReg <=	pipe1out(15 downto 11);
		end if;
		RD2EXStage <= pipe2out(52 downto 21);
		BranchAddEx <= std_logic_vector(signed(pipe2out(116 downto 85)) + signed(shifted_imm));
		MEMWBSigs <= pipe2out(124 downto 120);
		WriteRegEx <= pipe2out(20 downto 16);
		memWriteOut <= pipe3out(103);
		memReadOut <= pipe3out(102);
		ALUResMem <= pipe3out(68 downto 37);
		dataWrite <= pipe3out(36 downto 5);
		WBSigs <= pipe3out(106 downto 105);
		WriteRegMem <= pipe3out(4 downto 0);
	else -- should be used for resets
		pipe2reset <= reset or Hazard or PCSrc or no_op;
		pipe3reset <= reset or PCSrc;
	end if;
end if;
end process;


end Behavioral;

