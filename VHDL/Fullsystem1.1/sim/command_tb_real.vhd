----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2021 06:21:15 PM
-- Design Name: 
-- Module Name: command_tb_real - Behavioral
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

entity command_tb_real is
--  Port ( );
end command_tb_real;




architecture Behavioral of command_tb_real is


signal           i_clk :  STD_LOGIC:='0';
signal           i_reset : STD_LOGIC:='0';
signal           o_hsync : STD_LOGIC;
signal           o_vsync : STD_LOGIC;
signal           o_r : STD_LOGIC_VECTOR (3 downto 0);
signal           o_g : STD_LOGIC_VECTOR (3 downto 0);
signal           o_b : STD_LOGIC_VECTOR (3 downto 0);
signal           o_tx: STD_LOGIC;
signal           i_rx: std_logic:='1';




begin


UUT:entity work.system_wrapper
    Port map( 
           i_clk => i_clk, 
           i_reset => i_reset,
           o_hsync => o_hsync,
           o_vsync => o_vsync,
           o_r => o_r,
           o_g => o_g,
           o_b => o_b,
           o_tx => o_tx,
           i_rx => i_rx);



process begin
wait for 5ns;
i_clk<=not i_clk;
end process; 

process begin
i_reset<='0';
wait for 30ns;
i_reset<='1';
wait for 30ns;
i_reset<='0';
wait;
end process;                
end Behavioral;
