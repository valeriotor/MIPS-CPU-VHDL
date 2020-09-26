--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:32:12 09/26/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/MIPS_CPU/RegistersTest.vhd
-- Project Name:  MIPS_CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Registers
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
--USE ieee.numeric_std.ALL;
 
ENTITY RegistersTest IS
END RegistersTest;
 
ARCHITECTURE behavior OF RegistersTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal reset : std_logic := '0';
   signal clock : std_logic := '0';
   signal regWrite : std_logic := '0';
   signal readReg1 : std_logic_vector(4 downto 0) := (others => '0');
   signal readReg2 : std_logic_vector(4 downto 0) := (others => '0');
   signal writeReg : std_logic_vector(4 downto 0) := (others => '0');
   signal writeData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal readData1 : std_logic_vector(31 downto 0);
   signal readData2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clock_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Registers PORT MAP (
          reset => reset,
          clock => clock,
          regWrite => regWrite,
          readReg1 => readReg1,
          readReg2 => readReg2,
          writeReg => writeReg,
          writeData => writeData,
          readData1 => readData1,
          readData2 => readData2
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
      wait for clock_period*3;
		writeReg <= "11100";
		regWrite <= '1';
		writeData <= (0 => '0', 4 => '0', others => '1');
		wait for clock_period;
		writeReg <= "10100";
		writeData <= (1 => '0', 2 => '0', others => '1');
		readReg1 <= "11100";
		readReg2 <= "00011";
		wait for clock_period;
		assert(readData1 = "11111111111111111111111111101110") report "Error 1" severity error;
		assert(readData2 = "00000000000000000000000000000000") report "Error 2" severity error;
		regWrite <= '0';
		writeReg <= "00011";
		readReg1 <= "10100";
		wait for clock_period;
		assert(readData1 = "11111111111111111111111111111001") report "Error 3" severity error;
		assert(readData2 = "00000000000000000000000000000000") report "Error 4" severity error;
		regWrite <= '1';
		writeReg <= "00001";
		writeData <= (1 => '0', 3 => '0', others => '1');
		readReg1 <= "00001";
		wait for clock_period;
		assert(readData1 = "11111111111111111111111111110101") report "Warning 1: may not write and read at the same time" severity warning;
		wait for clock_period;
		assert(readData1 = "11111111111111111111111111110101") report "Error 5" severity error;
      wait;
   end process;

END;
