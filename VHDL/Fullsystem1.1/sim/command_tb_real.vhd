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

entity command_tb_real is

end command_tb_real;

architecture Behavioral of command_tb_real is

    signal i_clk    : STD_LOGIC := '0';
    signal i_reset  : STD_LOGIC := '0';
    signal o_hsync  : STD_LOGIC;
    signal o_vsync  : STD_LOGIC;
    signal o_r      : STD_LOGIC_VECTOR(3 downto 0);
    signal o_g      : STD_LOGIC_VECTOR(3 downto 0);
    signal o_b      : STD_LOGIC_VECTOR(3 downto 0);
    signal o_tx     : STD_LOGIC;
    signal i_rx     : std_logic := '1';
    signal rx_empty : std_logic;
    signal r_data   : std_logic_vector(7 downto 0);
    signal rd_uart  : std_logic;

    signal v_r_data   : std_logic_vector(7 downto 0);
    signal v_rd_uart  : std_logic;
    signal v_rx_empty : std_logic;
    
begin

    UUT : entity work.system_wrapper
        Port map( 
            i_clk   => i_clk, 
            i_reset => i_reset,
            o_hsync => o_hsync,
            o_vsync => o_vsync,
            o_r     => o_r, 
            o_g     => o_g,
            o_b     => o_b,
            o_tx    => o_tx,
            i_rx    => i_rx
        );

    verify : entity work.uart_rx_sim
        port map(
            i_clk    => i_clk,
            i_rst    => i_reset,
            i_data   => o_tx,
            v_r_data => v_r_data
        );

    clk_gen : process
        begin
            wait for 5ns;
            i_clk <= not i_clk;
        end process; 
    
    rst : process
        begin
            i_reset <= '0';
            wait for 30ns;
            i_reset <= '1';
            wait for 30ns;
            i_reset <= '0';
            wait;
        end process; 
   
end Behavioral;
