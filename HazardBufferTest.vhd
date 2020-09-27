--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:39:39 09/27/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/MIPS_CPU/HazardBufferTest.vhd
-- Project Name:  MIPS_CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HazardBuffer
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
 
ENTITY HazardBufferTest IS
END HazardBufferTest;
 
ARCHITECTURE behavior OF HazardBufferTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT HazardBuffer
    PORT(
         regWrite : IN  std_logic;
         writeReg : IN  std_logic_vector(4 downto 0);
         clock : IN  std_logic;
         reset : IN  std_logic;
         checkReg1 : IN  std_logic_vector(4 downto 0);
         checkReg2 : IN  std_logic_vector(4 downto 0);
         hazard : OUT  std_logic;
			debug : OUT std_logic_vector(17 downto 0);
			debug2 : OUT std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal regWrite : std_logic := '0';
   signal writeReg : std_logic_vector(4 downto 0) := (others => '0');
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal checkReg1 : std_logic_vector(4 downto 0) := (others => '0');
   signal checkReg2 : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal hazard : std_logic;
   signal debug : std_logic_vector(17 downto 0);
   signal debug2 : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clock_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: HazardBuffer PORT MAP (
          regWrite => regWrite,
          writeReg => writeReg,
          clock => clock,
          reset => reset,
          checkReg1 => checkReg1,
          checkReg2 => checkReg2,
          hazard => hazard,
			 debug => debug,
			 debug2 => debug2
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
		wait for clock_period/4;
		regWrite <= '1';
		writeReg <= "00001";
		wait for clock_period;
		checkReg1 <= "00011";
      checkReg2 <= "00010";
		writeReg <= "01110";
		wait for clock_period;
		checkReg1 <= "01110";
		regWrite <= '0';
		writeReg <= "00000";
		wait for clock_period/2;
		assert(hazard = '1') report "Error 1" severity error;
		wait for clock_period;
		assert(hazard = '1') report "Error 2" severity error;
		wait for clock_period;
		assert(hazard = '1') report "Error 3" severity error;
		wait for clock_period;
		assert(hazard = '0') report "Error 4" severity error;
		wait for clock_period*3/2;
		regWrite <= '1';
		writeReg <= "00000";
		checkReg1 <= "00100";
		wait for clock_period;
		checkReg1 <= "00000";
		writeReg <= "11111";
		wait for clock_period/2;
		assert(hazard = '1') report "Error 5" severity error;
		wait for clock_period;
		assert(hazard = '1') report "Error 6" severity error;
		wait for clock_period;
		assert(hazard = '1') report "Error 7" severity error;
		wait for clock_period;
		assert(hazard = '0') report "Error 8" severity error;
		
      wait;
   end process;

END;
