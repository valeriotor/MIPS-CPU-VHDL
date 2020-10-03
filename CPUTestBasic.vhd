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
			debug : OUT std_logic_vector(31 downto 0)
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

   -- Clock period definitions
   constant clock_period : time := 25 ns;
	
	--Addresses as Ints
	signal intInstrAddr : integer := 0;
 
BEGIN
intInstrAddr <= to_integer(unsigned(instr_addr));
instruction <= RAM(intInstrAddr) & RAM(intInstrAddr+1) & RAM(intInstrAddr+2) & RAM(intInstrAddr+3);



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
			 debug => debug
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
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      RAM(0) <= "00100001";
		RAM(1) <= "00001000";
		RAM(3) <= "00010000";
		
		RAM(4) <= "10101101";
		RAM(5) <= "00001000";
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
