----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:39:56 09/30/2020 
-- Design Name: 
-- Module Name:    ALUController - Behavioral 
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

entity ALUController is
    Port ( ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           Func  : in  STD_LOGIC_VECTOR (5 downto 0);
           Output : out  STD_LOGIC_VECTOR (3 downto 0));
end ALUController;

architecture Behavioral of ALUController is

begin
Output <= "0000" when AluOp(1) = '1' and Func(3 downto 0) = "0100" else
			 "0001" when AluOp(1) = '1' and Func(3 downto 0) = "0101" else
			 "0010" when AluOp = "00" 											 else
			 "0010" when AluOp(1) = '1' and Func(3 downto 0) = "0000" else
			 "0110" when AluOp = "01"										 	 else
			 "0110" when AluOp(1) = '1' and Func(3 downto 0) = "0010" else
			 "0111" when AluOp(1) = '1' and Func(3 downto 0) = "1010";

end Behavioral;

