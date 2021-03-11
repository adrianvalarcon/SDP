----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 07:01:37 PM
-- Design Name: 
-- Module Name: system_wrapper - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity system_wrapper is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_hsync : out STD_LOGIC;
           o_vsync : out STD_LOGIC;
           o_r : out STD_LOGIC_VECTOR (3 downto 0);
           o_g : out STD_LOGIC_VECTOR (3 downto 0);
           o_b : out STD_LOGIC_VECTOR (3 downto 0);
           o_tx: out STD_LOGIC;
           i_rx: in STD_LOGIC);
end system_wrapper;

architecture Behavioral of system_wrapper is

COMPONENT instructionlist
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(399 DOWNTO 0)
  );
END COMPONENT;

COMPONENT rom
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

COMPONENT uartloader_fifo
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;

signal pixel: std_logic_vector(11 downto 0); 
signal addra: std_logic_vector (18 downto 0);
signal rd_uart: std_logic;
signal wr_uart: std_logic;
signal w_data: std_logic_vector(7 downto 0);
signal tx_full: std_logic;
signal rx_empty:std_logic;
signal r_data: std_logic_vector(7 downto 0);
signal count: unsigned(22 downto 0):=TO_UNSIGNED(0,23);
signal send: std_logic;


type dataout is array (0 to 8) of std_logic_vector(7 downto 0);
constant message: dataout :=(X"46",X"4F",X"52",X"20",X"4B",X"49",X"4D",X"0D",X"0A");
signal message_select: unsigned (3 downto 0):="0000";

signal selcmd: std_logic_vector(2 downto 0);
signal command: std_logic_vector(399 downto 0);
signal load_fifo: std_logic;


signal last_pixel: std_logic;
signal pixel_tosend: std_logic_vector(7 downto 0);
signal pixel_valid: std_logic;
signal next_byte: std_logic;


signal fullpixel: std_logic_vector(11 downto 0);
signal pixellocation: std_logic_vector(18 downto 0);

signal byte_to_fifo: std_logic_vector(7 downto 0);
signal fifo_empty: std_logic;
signal fifo_read: std_logic;
signal byte_to_uart: std_logic_vector(7 downto 0);

begin


image : rom
  PORT MAP (
    clka => i_clk,
    ena => '1' ,
    addra => addra,
    douta => pixel,
    clkb => i_clk,
    enb => '1',
    addrb => pixellocation,
    doutb => fullpixel
    
  );

vga : entity work.vga_multiclock_wrapper
port map(
 
    i_clk => i_clk,
    i_reset => i_reset,
    o_hsync => o_hsync,
    o_vsync => o_vsync,
    o_addr => addra,
    i_pixel => pixel,
    o_r => o_r,
    o_g => o_g,
    o_b => o_b);

uart_system : entity work.uart
port map(
        clk     => i_clk,
        reset   => i_reset,
        rd_uart => rd_uart,                  -- initiate D_bit read from uart_rx
        wr_uart => send,--wr_uart,                   -- initiate D_bit write to uart_tx
        rx      => i_rx,                    -- rx input data bit
        w_data  => w_data,                   -- D_bit line for fifo_tx
        tx_full => tx_full,                  -- fifo_tx full indicator
        rx_empty=> rx_empty,                   -- fifo_rx empty indicator
        r_data  => r_data,                   -- D_bit line for fifo_rx
        tx      => o_tx);                     -- tx output data bit

process(message_select)
begin
w_data<=message(TO_INTEGER(message_select));
end process;



sm_loader:entity work.FIFO_loader 
port map(
           i_clk => i_clk, 
           i_reset => i_reset,
           i_command => command,
           i_pixel => '0',
           o_selcmd => selcmd,
           o_loadfifo => load_fifo,
           o_data => byte_to_fifo,
           o_next_byte => next_byte, 
           i_last_byte => last_pixel,
           i_through_data => pixel_tosend,
           i_pixel_valid => pixel_valid );

pixel_to_byte: entity work.pixel_configure
port map(
           i_clk => i_clk,
           i_reset => i_reset,
           i_pixel => fullpixel ,
           o_location => pixellocation ,
           o_byte => pixel_tosend,
           o_last_byte => last_pixel,
           o_valid_byte => pixel_valid, 
           i_next_byte => next_byte);


ROM_Instrctions : instructionlist
  PORT MAP (
    clka => i_clk,
    ena => '1',
    addra => selcmd,
    douta => command
  );



UART_LOADER_FIFO : uartloader_fifo
  PORT MAP (
    clk => i_clk,
    srst => i_reset,
    din => byte_to_fifo,
    wr_en => load_fifo,
    rd_en => fifo_read,
    dout => byte_to_uart,
    full => open,
    empty => fifo_empty
  );


fifo_read <= not fifo_empty;


end Behavioral;


