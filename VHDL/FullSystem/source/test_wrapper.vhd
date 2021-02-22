----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/01/2021 09:41:40 PM
-- Design Name: 
-- Module Name: test_wrapper - Behavioral
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

entity test_wrapper is
port( 
    i_clk : in STD_LOGIC;
    i_reset : in std_logic;
    o_hsync : out std_logic;
    o_vsync : out std_logic;
    o_r: out std_logic_vector(3 downto 0);
    o_g: out std_logic_vector (3 downto 0);
    o_b: out std_logic_vector (3 downto 0)
    ); 
       
end test_wrapper;

architecture Behavioral of test_wrapper is

COMPONENT rom
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;




signal on_screen: std_logic;
signal pixel: std_logic_vector(11 downto 0); 
signal addra: std_logic_vector (18 downto 0);

begin

image : rom
  PORT MAP (
    clka => i_clk,
    ena => '1' ,
    addra => addra,
    douta => pixel
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


end Behavioral;
