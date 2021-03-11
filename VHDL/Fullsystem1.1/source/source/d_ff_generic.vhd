----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2021 04:54:50 PM
-- Design Name: 
-- Module Name: d_ff_generic - Behavioral
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

entity d_ff_generic is
    Generic(N: integer :=16);
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (N-1 downto 0);
           q : out STD_LOGIC_VECTOR (N-1 downto 0));
end d_ff_generic;

architecture Behavioral of d_ff_generic is

begin

process (clk)
begin
if(rising_edge (clk)) then 
q <= d; 
end if;
end process; 
end Behavioral;
