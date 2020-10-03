----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:59 09/27/2020 
-- Design Name: 
-- Module Name:    HazardBuffer - Behavioral 
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

entity HazardBuffer is
    Port ( enable : in  STD_LOGIC;
           writeReg : in  STD_LOGIC_VECTOR (4 downto 0);
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           checkReg1 : in  STD_LOGIC_VECTOR (4 downto 0);
           checkReg2 : in  STD_LOGIC_VECTOR (4 downto 0);
           hazard : out  STD_LOGIC);
end HazardBuffer;

architecture Behavioral of HazardBuffer is
type buff is array (0 to 3) of std_logic_vector(5 downto 0);
signal data : std_logic_vector(17 downto 0) := (others => '0');
signal dataIn : std_logic_vector(5 downto 0) := (others => '0');
begin

process(clock,reset)
begin
if(reset = '1') then
	dataIn <= (others => '0');
elsif(rising_edge(clock)) then
	if((data(5)  = '1' and data(4 downto 0)   = checkReg1) or
		(data(11) = '1' and data(10 downto 6)  = checkReg1) or
		(data(17) = '1' and data(16 downto 12) = checkReg1) or
		(data(5)  = '1' and data(4 downto 0)   = checkReg2) or
		(data(11) = '1' and data(10 downto 6)  = checkReg2) or
		(data(17) = '1' and data(16 downto 12) = checkReg2)) then
		hazard <= '1';
		dataIn <= "000000";
	else
		hazard <= '0';
		if(enable = '1') then
			dataIn <= '1' & writeReg;
		else
			dataIn <= "000000";
		end if;
	end if;
end if;
end process;

process(clock, reset)
begin
if(reset = '1') then
	data <= (others => '0');
elsif(falling_edge(clock)) then
	data <= dataIn & data(17 downto 6);
end if;
end process;

end Behavioral;

