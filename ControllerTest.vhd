--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:02:03 10/03/2020
-- Design Name:   
-- Module Name:   /home/valeriotor/Scrivania/Valerio/Uni/XilinxWEBPACK/14.7/ISE_DS/MIPS_CPU/ControllerTest.vhd
-- Project Name:  MIPS_CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Controller
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
 
ENTITY ControllerTest IS
END ControllerTest;
 
ARCHITECTURE behavior OF ControllerTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal clock : std_logic := '0';
   signal enable : std_logic := '1';
   signal op_code : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal RegDst : std_logic;
   signal Jump : std_logic;
   signal Branch : std_logic;
   signal MemRead : std_logic;
   signal MemToReg : std_logic;
   signal MemWrite : std_logic;
   signal ALUOp : std_logic_vector(1 downto 0);
   signal ALUSrc : std_logic;
   signal RegWrite : std_logic;

   -- Clock period definitions
   constant clock_period : time := 25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Controller PORT MAP (
          clock => clock,
          enable => enable,
          op_code => op_code,
          RegDst => RegDst,
          Jump => Jump,
          Branch => Branch,
          MemRead => MemRead,
          MemToReg => MemToReg,
          MemWrite => MemWrite,
          ALUOp => ALUOp,
          ALUSrc => ALUSrc,
          RegWrite => RegWrite
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		enable <= not enable;
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clock_period*4;
		op_code <= "001000";
		wait for clock_period;
		assert (RegDst  = '0' and
				  Jump    = '0'	and
				  Branch  = '0' and
				  MemRead = '0' and
				  MemWrite= '0' and
				  MemToReg= '0' and
				  ALUOp   ="00" and
				  ALUSrc  = '1' and
				  RegWrite= '1') report "Error 1" severity error;
      wait;
   end process;

END;
