----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:07:28 09/30/2020 
-- Design Name: 
-- Module Name:    ProgramCounter - Behavioral 
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

entity ProgramCounter is
    Port ( clock  : in  STD_LOGIC;
			  enable : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           next_address : in  STD_LOGIC_VECTOR (31 downto 0);
           address : out  STD_LOGIC_VECTOR (31 downto 0));
end ProgramCounter;

architecture Behavioral of ProgramCounter is
begin
update : process(clock,reset)
begin
if(reset = '1') then
	address <= (others => '0');
elsif(rising_edge(clock) and enable = '1') then
	address <= next_address;
end if;
end process;


end Behavioral;

