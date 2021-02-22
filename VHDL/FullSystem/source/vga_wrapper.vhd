----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2021 01:59:07 PM
-- Design Name: 
-- Module Name: vga_wrapper - Behavioral
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

entity vga_wrapper is
    Port ( 
    i_clk : in STD_LOGIC;
    i_reset : in std_logic;
    o_hsync : out std_logic;
    o_vsync : out std_logic;
    o_addr : out std_logic_vector (18 downto 0);
    i_pixel: in std_logic_vector (11 downto 0);
    o_r: out std_logic_vector(3 downto 0);
    o_g: out std_logic_vector (3 downto 0);
    o_b: out std_logic_vector (3 downto 0);
    o_on_screen : out std_logic
    );
end vga_wrapper;

architecture Behavioral of vga_wrapper is

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

constant on_screen_delay: integer :=2;

type pixsync is array(0 to 2) of std_logic_vector(11 downto 0);
signal pixline : pixsync; 

alias r: std_logic_vector (3 downto 0) is pixline(2)(11 downto 8); 
alias g: std_logic_vector (3 downto 0) is pixline(2)(7 downto 4); 
alias b: std_logic_vector (3 downto 0) is pixline(2)(3 downto 0);

signal clk_vga: std_logic;

signal on_screen : std_logic_vector(on_screen_delay downto 0);
signal reset : std_logic; 
signal locked : std_logic;

signal pixel_addr: unsigned (18 downto 0):= (others =>'0') ;
type addsyncronizer is array (0 to 2) of std_logic_vector(18 downto 0);
signal addline : addsyncronizer;


signal xpos: std_logic_vector (9 downto 0);
signal ypos: std_logic_vector (9 downto 0);

signal hsync: std_logic_vector(0 downto 0); 
signal vsync: std_logic_vector(0 downto 0);
signal hsync_d: std_logic_vector(0 downto 0); 
signal vsync_d: std_logic_vector(0 downto 0);  

type syncsyncronizer is array (0 to 3) of std_logic_vector(0 downto 0); 
signal hsyncline : syncsyncronizer;
signal vsyncline : syncsyncronizer; 

begin

reset <= i_reset or (not locked);
o_on_screen <= on_screen(0);

addline(0) <= std_logic_vector(pixel_addr);
o_addr <= addline(2);

pixline(0) <= i_pixel;

hsyncline(0) <=hsync;
vsyncline(0) <=vsync;
hsync_d <= hsyncline(2);
vsync_d <= vsyncline(2);
o_hsync <= hsync_d(0);
o_vsync <= vsync_d(0);
 

pixelcount: process (clk_vga)
begin

if(rising_edge(clk_vga)) then
   
   if(reset='1') then 
   pixel_addr <= (others =>'0');
   on_screen(0)<='1';
   elsif ( (unsigned(xpos)<=TO_UNSIGNED(639,10)) and (unsigned(ypos)<=TO_UNSIGNED(425,10))) then 
   pixel_addr <= pixel_addr + 1; 
   on_screen(0)<='1';
   elsif ((unsigned(ypos)>=TO_UNSIGNED(425,10))) then 
   pixel_addr <= (others =>'0');
   on_screen(0)<='0';
   else 
   on_screen(0)<='0';
   end if;
end if; 
end process;    


output_control: process(r,g,b,on_screen(on_screen_delay),reset)
begin 
if (on_screen(on_screen_delay)='0' or reset='1') then
o_r <= (others=>'0');
o_g <= (others=>'0');
o_b <= (others=>'0');
else
o_r <= r;
o_g <= g;
o_b <= b;
end if;
end process;

position: entity work.vga_position_controller 
port map(
i_clk => clk_vga, 
i_reset => reset,
o_xpos => xpos,
o_ypos => ypos,
o_hsync => hsync(0),-- syncs will need to be slowed
o_vsync => vsync(0));


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
    
 D_gen_add: for I in 0 to 1 generate 
 d_ff_add: entity work.d_ff_generic
 generic map(
 N => 19)
 
 port map( 
 clk => i_clk,
 d => addline(I),
 q => addline(I+1));
 end generate; 
 
 D_gen_data : for I in 0 to 1 generate 
 d_ff_data: entity work.d_ff_generic
 generic map( 
 N => 12)
 port map(
 clk => clk_vga,
 d => pixline(I),
 q => pixline(I+1));
 end generate; 
 
 
 D_gen_hsync: for I in 0 to 2 generate
 d_ff_hsync: entity work.d_ff_generic
 generic map(
 N => 1)
 port map(
  clk => clk_vga,
 d => hsyncline(I),
 q => hsyncline(I+1));
 end generate; 
 
 D_gen_vsync: for I in 0 to 2 generate
 d_ff_vsync: entity work.d_ff_generic
 generic map(
 N => 1)
 port map(
 clk => clk_vga,
 d => vsyncline(I),
 q => vsyncline(I+1));
 end generate;  
 
 D_gen_on_screen: for I in 0 to on_screen_delay-1 generate 
 d_ff_on_screen: entity work.d_ff_generic
 generic map(
 N => 1)
 port map(
 clk => clk_vga,
 d(0) => on_screen(I),
 q(0) => on_screen(I+1));
 end generate;  
    
end Behavioral;
