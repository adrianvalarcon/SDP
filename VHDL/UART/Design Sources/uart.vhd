----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/29/2021 11:08:46 AM
-- Design Name: 
-- Module Name: uart - Behavioral
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
use ieee.numeric_std.all;

entity uart is
    generic(
    -- Default:
    -- 115200 baud, 8 data bits, 1 stop bit, 2^x FIFO
    D_bit   : integer := 8;     -- # data bits
    SB_tick : integer := 16;    -- # ticks for stop bits
    DVSR    : integer := 55;    -- DVSR = 100M/(16*115200)
    DVSR_bit: integer := 6;     -- # bits of DVSR
    FIFO_w  : integer := 2      -- # FIFO address bits/# words in FIFO 
    );
    
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        rd_uart : in  std_logic;                    -- initiate D_bit read from uart_rx
        wr_uart : in  std_logic;                    -- initiate D_bit write to uart_tx
        rx      : in  std_logic;                    -- rx input data bit
        w_data  : in  std_logic_vector(7 downto 0); -- D_bit line for fifo_tx
        tx_full : out std_logic;                    -- fifo_tx full indicator
        rx_empty: out std_logic;                    -- fifo_rx empty indicator
        r_data  : out std_logic_vector(7 downto 0); -- D_bit line for fifo_rx
        tx      : out std_logic                     -- tx output data bit
    );
end uart;

architecture Behavioral of uart is
    signal tick         : std_logic;
    signal rx_done      : std_logic;
    signal tx_fifo_out  : std_logic_vector(7 downto 0);
    signal rx_data_out  : std_logic_vector(7 downto 0);
    signal tx_empty     : std_logic;
    signal tx_fifo_not_empty : std_logic;
    signal tx_done      : std_logic;
    
begin
    baud_gen : entity work.baud_gen
        generic map(
            N => DVSR_bit,
            cntr_bits => DVSR
        )
        port map(
            clk => clk,
            reset => reset,
            bit_cnt => open,
            tick => tick
        );
    
    uart_rx : entity work.uart_rx(Behavioral)
        generic map(
            D_bit => D_bit,
            SB_tick => SB_tick
        )
        port map(
            clk => clk,
            reset => reset,
            rx => rx,
            s_tick => tick,
            rx_done => rx_done,
            d_out => rx_data_out
        );
    
    fifo_rx : entity work.fifo(Behavioral)
        generic map(
            B => D_bit,
            W => FIFO_w
        )
        port map(
            clk => clk,
            reset => reset,
            rd => rd_uart,
            wr => rx_done,
            w_data => rx_data_out,
            empty => rx_empty,
            full => open,
            r_data => r_data
        );
        
    fifo_tx : entity work.fifo(Behavioral)
        generic map(
            B => D_bit,
            W => FIFO_w
        )
        port map(
            clk => clk,
            reset => reset,
            rd => tx_done,
            wr => wr_uart,
            w_data => w_data,
            empty => tx_empty,
            full => tx_full,
            r_data => tx_fifo_out
        );
    
    uart_tx : entity work.uart_tx(Behavioral)
        generic map(
            D_bit => D_bit,
            SB_tick => SB_tick
        )
        port map(
            clk => clk,
            reset => reset,
            tx_start => tx_fifo_not_empty,
            s_tick => tick,
            d_in => tx_fifo_out,
            tx_done => tx_done,
            tx => tx
        );
        
        tx_fifo_not_empty <= not tx_empty;
        
end Behavioral;
