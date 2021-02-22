----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/12/2021 01:19:19 PM
-- Design Name: 
-- Module Name: vga_multiclock_wrapper - Behavioral
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_multiclock_wrapper is
  Port (
    i_clk : in STD_LOGIC;
    i_reset : in std_logic;
    o_hsync : out std_logic;
    o_vsync : out std_logic;
    o_addr : out std_logic_vector (18 downto 0);
    i_pixel: in std_logic_vector (11 downto 0);
    o_r: out std_logic_vector(3 downto 0);
    o_g: out std_logic_vector (3 downto 0);
    o_b: out std_logic_vector (3 downto 0));
end vga_multiclock_wrapper;

architecture Behavioral of vga_multiclock_wrapper is

COMPONENT fifo_generator_0
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC;
    prog_empty : OUT STD_LOGIC
  );
END COMPONENT;

component vga_clk
port
 (
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

signal reset: std_logic;
signal clk_vga: std_logic;
signal fifores: std_logic; 

signal pixel_addr: unsigned (18 downto 0):= (others =>'0');
signal inc: std_logic_vector(2 downto 0):= (others =>'0'); 

signal xpos: std_logic_vector (9 downto 0);
signal ypos: std_logic_vector (9 downto 0);
signal hsync: std_logic;
signal vsync: std_logic;



signal pixel: std_logic_vector (11 downto 0); 
signal empty: std_logic;
signal full: std_logic; 

signal locked: std_logic; 

alias r: std_logic_vector (3 downto 0) is pixel(11 downto 8); 
alias g: std_logic_vector (3 downto 0) is pixel(7 downto 4); 
alias b: std_logic_vector (3 downto 0) is pixel(3 downto 0);

constant syncdelayconst : integer :=20;
constant screendelay: integer := syncdelayconst-7; 
type syncsignal is array (0 to syncdelayconst) of std_logic_vector(1 downto 0);
signal syncsync: syncsignal;
signal syncali: std_logic_vector(1 downto 0);
signal on_screen: std_logic_vector(syncdelayconst downto 0);

begin

o_addr <= std_logic_vector(pixel_addr);




reset <= i_reset or (not locked);

syncsync(0) <= vsync & hsync; 
syncali <= syncsync(syncdelayconst);
o_hsync <= syncali(0);
o_vsync <= syncali(1);


position: entity work.vga_position_controller 
port map(
i_clk => clk_vga, 
i_reset => reset,
o_xpos => xpos,
o_ypos => ypos,
o_hsync => hsync,-- syncs will need to be slowed
o_vsync => vsync);

pixelholder : fifo_generator_0
  PORT MAP (
    rst => fifores,
    wr_clk => i_clk,
    rd_clk => clk_vga,
    din => i_pixel,
    wr_en => inc(2),
    rd_en => on_screen(0),
    dout => pixel,
    full => open,
    empty => open,
    prog_full => full,
    prog_empty => empty
    
  );
  
 clock_for_vga : vga_clk
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_vga,
  -- Status and control signals                
   reset => i_reset,
   locked => locked,
   -- Clock in ports
   clk_in1 => i_clk
 );   


counter: process (i_clk)
begin
if(rising_edge(i_clk)) then
   
   if(reset='1') then 
   pixel_addr <= (others =>'0');   
   elsif (pixel_addr = TO_UNSIGNED(272_639,19)) then
   pixel_addr <= (others =>'0');
   elsif (inc(2) = '1') then
   pixel_addr <= pixel_addr + 1; 

   end if;
end if; 
end process;   


inrange: process(xpos,ypos)
begin
   if(reset = '1') then
   on_screen(0) <= '1';
   elsif ( (unsigned(xpos) <= TO_UNSIGNED(639,10)) and (unsigned(ypos) <= TO_UNSIGNED(425,10))) then 
   on_screen(0) <= '1';
   elsif ((unsigned(ypos)>=TO_UNSIGNED(425,10))) then 
   on_screen(0) <='0';
   else 
   on_screen(0)<='0';
   end if;
end process;    

inc_latch:process(full,empty,reset)
begin
if(reset = '1') then
inc(0) <= '1';
elsif  (full = '1')then
inc(0) <= '0';
elsif (empty = '1') then
inc(0) <= '1'; 
end if;
end process; 

mux: process(r,g,b,on_screen(screendelay))
begin
if on_screen(screendelay)='1' then
o_r <= r;
o_g <= g;
o_b <= b;
else 
o_r <= (others =>'0');
o_g <= (others =>'0');
o_b <= (others =>'0');
end if;
end process;

D_gen_sync_inc:for I in 0 to 1 generate
sync_inc_dff: entity work.d_ff_generic
generic map(
 N => 1)  
port map(
clk => i_clk,
d(0) => inc(I),
q(0) => inc(I+1)); 
end generate; 

D_gen_sync_delay: for I in 0 to (syncdelayconst - 1) generate
sync_delay_dff: entity work.d_ff_generic
generic map(
N => 2)
port map(
clk => clk_vga,
d => syncsync(I),
q => syncsync(I+1));
end generate;
 
 
D_normal: entity work.d_ff_generic
generic map(
 N => 1)  
port map(
clk => i_clk,
d(0) => reset,
q(0) => fifores); 

D_gen_screen_delay: for I in 0 to (screendelay - 1) generate
screen_delay_dff: entity work.d_ff_generic
generic map(
N => 1)
port map(
clk => clk_vga,
d(0) => on_screen(I),
q(0) => on_screen(I+1));
end generate;


end Behavioral;
