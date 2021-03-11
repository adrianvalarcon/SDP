----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2021 07:06:00 PM
-- Design Name: 
-- Module Name: twoto1mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity twoto1mux is
    Port ( i1 : in STD_LOGIC_VECTOR (7 downto 0);
           i2 : in STD_LOGIC_VECTOR (7 downto 0);
           s : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (7 downto 0));
end twoto1mux;

architecture Behavioral of twoto1mux is

begin

process(s,i1,i2)
begin
if(s='1') then 
z<=i2;
else
z<=i1;
end if;
end process; 


end Behavioral;
