--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:07:39 09/25/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/MIPS_CPU/ALUTest.vhd
-- Project Name:  MIPS_CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALUTest IS
END ALUTest;
 
ARCHITECTURE behavior OF ALUTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal in1 : std_logic_vector(31 downto 0) := (others => '0');
   signal in2 : std_logic_vector(31 downto 0) := (others => '0');
   signal ALUctrl : std_logic_vector(3 downto 0) := (others => '0');
   signal clock : std_logic := '0';

	--BiDirs
   signal result : std_logic_vector(31 downto 0);

 	--Outputs
   signal zero : std_logic;

   -- Clock period definitions
   constant clock_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          in1 => in1,
          in2 => in2,
          ALUctrl => ALUctrl,
          clock => clock,
          result => result,
          zero => zero
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      in1 <= "00000000000000000000000000010101";
		in2 <= "00000000000000000000000000010001";
		ALUctrl <= "0010";
		wait for clock_period;
		assert(result = "00000000000000000000000000100110") report "Error sum" severity error;
		ALUctrl <= "0110";
		wait for clock_period;
		assert(result = "00000000000000000000000000000100") report "Error sub" severity error;
		ALUctrl <= "0111";
		wait for clock_period;
		assert(result = "00000000000000000000000000000000") report "Error slt 1" severity error;
		assert(zero = '0') report "Error slt 2" severity error;
		ALUctrl <= "0000";
		wait for clock_period;
		assert(result = "00000000000000000000000000010001") report "Error and" severity error;
		ALUctrl <= "0001";
		wait for clock_period;
		assert(result = "00000000000000000000000000010101") report "Error or" severity error;
      wait;
   end process;

END;
