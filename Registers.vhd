----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:04:47 09/26/2020 
-- Design Name: 
-- Module Name:    Registers - Behavioral 
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

entity Registers is
    Port ( reset : in STD_LOGIC;
			  clock : in STD_LOGIC;
			  regWrite : in  STD_LOGIC;
           readReg1 : in  STD_LOGIC_VECTOR (4 downto 0);
           readReg2 : in  STD_LOGIC_VECTOR (4 downto 0);
           writeReg : in  STD_LOGIC_VECTOR (4 downto 0);
           writeData : in  STD_LOGIC_VECTOR (31 downto 0);
           readData1 : out  STD_LOGIC_VECTOR (31 downto 0);
           readData2 : out  STD_LOGIC_VECTOR (31 downto 0));
end Registers;

architecture Behavioral of Registers is
type reg is array (0 to 31) of std_logic_vector(31 downto 0);
signal data : reg := (others => (others => '0'));
begin

read_and_write : process(reset, clock)
begin
if(reset = '1') then
	data <= (others => (others => '0'));
	readData1 <= (others => '0');
	readData2 <= (others => '0');
elsif(rising_edge(clock)) then
	if(regWrite = '1') then
		data(to_integer(unsigned(writeReg))) <= writeData;
	end if;
	readData1 <= data(to_integer(unsigned(readReg1)));
	readData2 <= data(to_integer(unsigned(readReg2)));
end if;
end process;

end Behavioral;

