----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/05/2021 02:47:18 AM
-- Design Name: 
-- Module Name: uart_test - Behavioral
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

entity uart_test is
	--generic(
	--	  D_bit   : integer := 8;     -- # data bits
	--    SB_tick : integer := 16;    -- # ticks for stop bits
	--    DVSR    : integer := 543;   -- DVSR = 100M/(16*115200)
	--    DVSR_bit: integer := 10;	  -- # bits of DVSR
	--    FIFO_w  : integer := 2	  -- # fifo address bits
	--);
end uart_test;

architecture Behavioral of uart_test is
	constant clk_per  : time := 10ns;
	constant D_bit    : integer := 8;  
	constant SB_tick  : integer := 16; 
	constant DVSR     : integer := 55;
	constant DVSR_bit : integer := 6; 
	constant FIFO_w   : integer := 2;
    constant bit_clks : integer := DVSR*16;  
	signal clk     	  : std_logic;
	signal reset   	  : std_logic;
	signal rd_uart 	  : std_logic;
	signal wr_uart 	  : std_logic;
	signal rx      	  : std_logic;
	signal w_data  	  : std_logic_vector(7 downto 0);
	signal tx_full 	  : std_logic;
	signal rx_empty	  : std_logic;
	signal r_data  	  : std_logic_vector(7 downto 0);
	signal tx      	  : std_logic;

	component uart is
		generic(
		    D_bit    : integer := D_bit;     -- # data bits
		    SB_tick  : integer := SB_tick;    -- # ticks for stop bits
		    DVSR     : integer := DVSR;   -- DVSR = 100M/(16*115200)
		    DVSR_bit : integer := DVSR_bit;    -- # bits of DVSR
		    FIFO_w   : integer := FIFO_w      -- # FIFO address bits/# words in FIFO 
		); 
		port( 
	        clk      : in  std_logic;
	        reset    : in  std_logic;
	        rd_uart  : in  std_logic;
	        wr_uart  : in  std_logic;
	        rx       : in  std_logic;
	        w_data   : in  std_logic_vector(7 downto 0);
	        tx_full  : out std_logic;
	        rx_empty : out std_logic;
	        r_data   : out std_logic_vector(7 downto 0);
	        tx       : out std_logic
		);
	end component;

begin

	clk_gen : process is
		begin
			clk <= '1';
			wait for clk_per/2;
			clk <= '0';
			wait for clk_per/2;
		end process;

	uut : uart
		generic map(
			D_bit    => D_bit,   
			SB_tick  => SB_tick, 
			DVSR     => DVSR,
			DVSR_bit => DVSR_bit,
			FIFO_w   => FIFO_w
		)
		port map(
	        clk      => clk,
	        reset    => reset,
	        rd_uart  => rd_uart,
	        wr_uart  => wr_uart,
	        rx       => rx,
	        w_data   => w_data,
	        tx_full  => tx_full,
	        rx_empty => rx_empty,
	        r_data   => r_data,
	        tx       => tx
		);

	test_case_1 : process
		begin
            -- Idle
            reset    <= '1';
            rx       <= '1';     -- rx line idle at high
            rd_uart  <= '0';
            wr_uart	 <= '0';
            w_data   <= (others => '0');
            
            wait for bit_clks*clk_per;
			
			-- Start bit
			reset    <= '0';
			rx       <= '0';
			wait for bit_clks*clk_per;
			
			-- 8 Data bits
			rx       <= '1';
			wait for bit_clks*clk_per;
			rx       <= '1';
			wait for bit_clks*clk_per;
			rx       <= '0';
			wait for bit_clks*clk_per;
			rx       <= '1';
			wait for bit_clks*clk_per;
			rx       <= '0';
			wait for bit_clks*clk_per;
			rx       <= '1';
			wait for bit_clks*clk_per;
			rx       <= '1';
			wait for bit_clks*clk_per;
			rx       <= '0';
			wait for bit_clks*clk_per;
			
			-- Stop bits (2)
			rx       <= '1';
			wait for SB_tick/2*bit_clks*clk_per;
			
			wait for 5*clk_per;
			
			-- Receive 8 data bits from fifo_rx
			rd_uart  <= '1';
			wait for 5*clk_per;
			wait;
			
		end process;
end Behavioral;
