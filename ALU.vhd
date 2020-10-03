----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:42:02 09/25/2020 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port ( in1 : in  STD_LOGIC_VECTOR (31 downto 0);
           in2 : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUctrl : in  STD_LOGIC_VECTOR (3 downto 0);
           clock : in  STD_LOGIC;
           result : inout  STD_LOGIC_VECTOR (31 downto 0);
           zero : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

begin
compute:process(clock)
begin
if(rising_edge(clock)) then
	case ALUctrl is
		when "0000" => result <= in1 and in2;
		when "0001" => result <= in1 or in2;
		when "0010" => result <= std_logic_vector(signed(in1) + signed(in2));
		when "0110" => result <= std_logic_vector(signed(in1) - signed(in2));
		when "0111" => if(signed(in1) < signed(in2)) then
								result <= "00000000000000000000000000000001";
							else
								result <= "00000000000000000000000000000000";
							end if;
		when "1100" => result <= in1 nor in2;
		when others => report "ERROR: unknown ALUctrl code" severity failure;
	end case;
	if(result = "00000000000000000000000000000000") then
		zero <= '1';
	else
		zero <= '0';
	end if;
end if;

end process;

end Behavioral;

