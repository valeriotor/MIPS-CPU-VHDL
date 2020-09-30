----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:16:26 09/30/2020 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( clock : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           op_code : in  STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out  STD_LOGIC;
           Jump : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemToReg : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR(1 downto 0);
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC);
end Controller;

architecture Behavioral of Controller is
constant r_op : std_logic_vector(5 downto 0) := "000000";
constant addi : std_logic_vector(5 downto 0) := "001000";
constant ori  : std_logic_vector(5 downto 0) := "001101";
constant beq  : std_logic_vector(5 downto 0) := "000100";
constant bne  : std_logic_vector(5 downto 0) := "000101";
constant j    : std_logic_vector(5 downto 0) := "000010";
constant jal  : std_logic_vector(5 downto 0) := "000011";
constant lw   : std_logic_vector(5 downto 0) := "100011";
constant sw   : std_logic_vector(5 downto 0) := "101011";

begin
process(clock)
begin
if(rising_edge(clock) and enable = '1') then
		
		case op_code is
			when r_op => RegWrite <= '1';
			when addi => RegWrite <= '1';
			when ori  => RegWrite <= '1';
			when lw   => RegWrite <= '1';
--			when jal  => RegWrite <= '1';
			when others => RegWrite <= '0';
		end case;
		case op_code is
			when addi => AluSrc <= '1';
			when ori  => AluSrc <= '1';
			when lw   => AluSrc <= '1';
			when sw   => AluSrc <= '1';
			when others => AluSrc <= '0';
		end case;
		case op_code is
			when lw   => AluOp <= "00";
			when sw   => AluOp <= "00";
			when beq  => AluOp <= "01";
			when r_op => AluOp <= "10";
			when others => AluOp <= "00";
		end case;
		case op_code is
			when sw   => MemWrite <= '1';
			when others => MemWrite <= '0';
		end case;
		case op_code is 
			when lw   => MemRead <= '1';
			when others => MemRead <= '0';
		end case;
		case op_code is 
			when lw   => MemToReg <= '1';
			when others => MemToReg <= '0';
		end case;
		case op_code is
			when beq  => Branch <= '1';
			when others => Branch <= '0';
		end case;
		case op_code is
			when j    => Jump <= '1';
			when others => Jump <= '0';
		end case;
		case op_code is
			when r_op => RegDst <= '1';
			when others => RegDst <= '0';
		end case;	
end if;
end process;

end Behavioral;

