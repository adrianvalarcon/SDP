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
begin


image : rom
  PORT MAP (
    clka => i_clk,
    ena => '1' ,
    addra => addra,
    douta => pixel,
    clkb => i_clk,
    enb => '0',
    addrb => (others =>'0'),
    doutb => open
    
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


process (i_clk)
begin
if(rising_edge(i_clk)) then 
count<=count+1;
end if;
end process; 

process(count)
begin
if(count = TO_UNSIGNED(10,23)) then 
send<='1';
else 
send<='0';
end if;
end process; 

process(i_clk)
begin
if(rising_edge(i_clk)) then
    if(message_select="1000" and send='1') then
    message_select<="0000";
    elsif (send='1') then
    message_select<=message_select+1;
    end if;
end if; 
end process;

end Behavioral;


