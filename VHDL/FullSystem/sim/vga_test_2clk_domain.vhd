----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2021 01:57:22 PM
-- Design Name: 
-- Module Name: vga_test_1clk_domain - Behavioral
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

entity vga_test_1clk_domain is
--  Port ( );
end vga_test_1clk_domain;


architecture Behavioral of vga_test_1clk_domain is

signal    i_clk :  STD_LOGIC:='0';
signal    i_reset :  std_logic:='0';
signal    o_hsync :  std_logic;
signal    o_vsync :  std_logic;
signal    o_r:  std_logic_vector(3 downto 0);
signal    o_g:  std_logic_vector (3 downto 0);
signal    o_b:  std_logic_vector (3 downto 0);

constant half_clk_period: time := 5ns;
constant clk_period : time := 10ns;

begin

UUT: entity work.test_wrapper
port map( 
    i_clk => i_clk,
    i_reset => i_reset,
    o_hsync => o_hsync,
    o_vsync => o_vsync,
    o_r => o_r,
    o_g => o_g,
    o_b => o_b
    ); 

clk_gen: process
begin
wait for half_clk_period;
loop 
wait for half_clk_period;
i_clk <= not i_clk;
end loop;
end process;

IO_stim: process
begin 
wait for 1 ns;
wait for clk_period;
i_reset <= '1';
wait for 2 * clk_period; 
i_reset <= '0';
wait;
end process;
end Behavioral;
