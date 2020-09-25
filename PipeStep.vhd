----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:30:09 09/25/2020 
-- Design Name: 
-- Module Name:    PipeStep - Behavioral 
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

entity PipeStep is
	 Generic (K : integer := 10);
    Port ( clock : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (K downto 0);
           output : out  STD_LOGIC_VECTOR (K downto 0));
end PipeStep;

architecture Behavioral of PipeStep is
signal stored : STD_LOGIC_VECTOR(K downto 0) := (others => '0');
begin
output <= stored;

update : process(clock, reset)
begin
	if(reset = '1') then
		stored <= (others => '0');
	elsif(falling_edge(clock)) then
		stored <= input;
	end if;
end process;

end Behavioral;

