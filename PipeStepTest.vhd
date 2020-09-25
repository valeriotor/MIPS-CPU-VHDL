--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:35:54 09/25/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/MIPS_CPU/PipeStepTest.vhd
-- Project Name:  MIPS_CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PipeStep
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
 
ENTITY PipeStepTest IS
END PipeStepTest;
 
ARCHITECTURE behavior OF PipeStepTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PipeStep
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         input : IN  std_logic_vector(10 downto 0);
         output : OUT  std_logic_vector(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal input : std_logic_vector(10 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clock_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PipeStep PORT MAP (
          clock => clock,
          reset => reset,
          input => input,
          output => output
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
		wait for 7 ns;
		input <= (0 => '1', 3 => '1', others => '0');
		wait for clock_period;
		assert(output = "00000001001") report "Error 1" severity error;
		input <= (0 => '1', 4 => '1', others => '0');
		wait for clock_period;
		assert(output = "00000010001") report "Error 2" severity error;
      wait;
   end process;

END;
