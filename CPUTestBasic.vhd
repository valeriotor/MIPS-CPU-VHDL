--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:44:39 10/03/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/MIPS_CPU/CPUTestBasic.vhd
-- Project Name:  MIPS_CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY CPUTestBasic IS
END CPUTestBasic;
 
ARCHITECTURE behavior OF CPUTestBasic IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         instruction : IN  std_logic_vector(31 downto 0);
         instr_addr : OUT  std_logic_vector(31 downto 0);
         dataRead : IN  std_logic_vector(31 downto 0);
         dataWrite : OUT  std_logic_vector(31 downto 0);
         dataAddr : OUT  std_logic_vector(31 downto 0);
         memWriteOut : OUT  std_logic;
         memReadOut : OUT  std_logic;
			debug : OUT std_logic_vector(31 downto 0);
			debug2 : OUT std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    
	type PseudoMemory is array(0 to 1023) of STD_LOGIC_VECTOR(7 downto 0);
	signal RAM : PseudoMemory := (others => (others => '0'));
	
   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal instruction : std_logic_vector(31 downto 0) := (others => '0');
   signal dataRead : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal instr_addr : std_logic_vector(31 downto 0);
   signal dataWrite : std_logic_vector(31 downto 0);
   signal dataAddr : std_logic_vector(31 downto 0);
   signal memWriteOut : std_logic;
   signal memReadOut : std_logic;
	signal debug : std_logic_vector(31 downto 0);
	signal debug2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clock_period : time := 25 ns;
	
	--Addresses as Ints
	signal intInstrAddr : integer := 0;
	signal intDataAddr  : integer := 0;
	
	--Instructions
	constant firstInstr   : STD_LOGIC_VECTOR(31 downto 0) := "00100001000010000000000001000000"; -- addi t0 t0 64
	constant secondInstr : STD_LOGIC_VECTOR(31 downto 0) := "00100001001010010000000001000000"; -- addi t1 t1 64
	constant thirdInstr  : STD_LOGIC_VECTOR(31 downto 0) := "10101101000010010000000000000000"; -- sw t1 0(t0)
	constant fourthInstr : STD_LOGIC_VECTOR(31 downto 0) := "00010001001010001111111111111101"; -- beq t1 t0 -3
	constant fifthInstr   : STD_LOGIC_VECTOR(31 downto 0) := "10001101001010100000000000000000"; -- lw t2 0(t1)
	constant sixthInstr  : STD_LOGIC_VECTOR(31 downto 0) := "10101101001010100000000000000000"; -- sw t2 0(t0)
	constant seventhInstr: STD_LOGIC_VECTOR(31 downto 0) := "00001000000000000000000000000001"; -- j 1
	
 
BEGIN
intInstrAddr <= to_integer(unsigned(instr_addr));
instruction <= RAM(intInstrAddr) & RAM(intInstrAddr+1) & RAM(intInstrAddr+2) & RAM(intInstrAddr+3);
intDataAddr <= to_integer(unsigned(dataAddr));
dataRead <= RAM(intDataAddr) & RAM(intDataAddr+1) & RAM(intDataAddr+2) & RAM(intDataAddr+3);


	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          clock => clock,
          reset => reset,
          instruction => instruction,
          instr_addr => instr_addr,
          dataRead => dataRead,
          dataWrite => dataWrite,
          dataAddr => dataAddr,
          memWriteOut => memWriteOut,
          memReadOut => memReadOut,
			 debug => debug,
			 debug2 => debug2
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		--report integer'image(intInstrAddr);
		if(MemWriteOut = '1') then
			report integer'image(to_integer(unsigned(dataWrite))) severity note;
		end if;
		--report "Debug: " & integer'image(to_integer(unsigned(debug)));
		--report "Debug2: " & integer'image(to_integer(unsigned(debug2)));
		--if(MemReadOut = '1') then
			--report "Data Read: " & integer'image(to_integer(unsigned(dataRead))) severity note;
			--report "Data Addr: " & integer'image(intDataAddr) severity note;
		--end if;
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      RAM(4)  <= firstInstr(31 downto 24);
		RAM(5)  <= firstInstr(23 downto 16);
		RAM(6)  <= firstInstr(15 downto 8);
		RAM(7)  <= firstInstr(7 downto 0);
      RAM(8)  <= secondInstr(31 downto 24);
		RAM(9)  <= secondInstr(23 downto 16);
		RAM(10)  <= secondInstr(15 downto 8);
		RAM(11)  <= secondInstr(7 downto 0);
      RAM(12) <= thirdInstr(31 downto 24);
		RAM(13) <= thirdInstr(23 downto 16);
		RAM(14) <= thirdInstr(15 downto 8);
		RAM(15) <= thirdInstr(7 downto 0);
      RAM(16) <= fourthInstr(31 downto 24);
		RAM(17) <= fourthInstr(23 downto 16);
		RAM(18) <= fourthInstr(15 downto 8);
		RAM(19) <= fourthInstr(7 downto 0);
      RAM(20) <= fifthInstr(31 downto 24);
		RAM(21) <= fifthInstr(23 downto 16);
		RAM(22) <= fifthInstr(15 downto 8);
		RAM(23) <= fifthInstr(7 downto 0);
      RAM(24) <= sixthInstr(31 downto 24);
		RAM(25) <= sixthInstr(23 downto 16);
		RAM(26) <= sixthInstr(15 downto 8);
		RAM(27) <= sixthInstr(7 downto 0);
      RAM(28) <= seventhInstr(31 downto 24);
		RAM(29) <= seventhInstr(23 downto 16);
		RAM(30) <= seventhInstr(15 downto 8);
		RAM(31) <= seventhInstr(7 downto 0);
		RAM(128) <= "11111111";
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
