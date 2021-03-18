----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 12:04:06 PM
-- Design Name: 
-- Module Name: uart_rx_sim - Behavioral
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

entity uart_rx_sim is
    port(
        i_clk     : in  std_logic;
        i_rst     : in  std_logic;
        i_data    : in  std_logic;
        v_r_data  : out std_logic_vector(7 downto 0)
    );
end uart_rx_sim;

architecture Behavioral of uart_rx_sim is

    signal v_rd_uart  : std_logic;
    signal v_rx_empty : std_logic;

begin

    rx_sim : entity work.uart
        port map(
            clk      => i_clk,
            reset    => i_rst,
            rd_uart  => v_rd_uart,
            wr_uart  => 'Z',
            rx       => i_data,
            w_data   => "ZZZZZZZZ",
            tx_full  => open,
            rx_empty => v_rx_empty,
            r_data   => v_r_data,
            tx       => open
        );

    process (i_clk)
        begin
            if (rising_edge(i_clk)) then
                if (v_rx_empty = '0') then
                    v_rd_uart <= '0';
                else
                    v_rd_uart <= '1';            
                end if;
            end if;
        end process;
    
end Behavioral;
