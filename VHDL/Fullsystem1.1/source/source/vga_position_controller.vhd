----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2020 02:26:47 PM
-- Design Name: 
-- Module Name: vga_position_controller - Behavioral
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

-- for 640 by 480
entity vga_position_controller is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_xpos : out std_logic_vector (9 downto 0);
           o_ypos : out std_logic_vector (9 downto 0);
           o_hsync : out STD_LOGIC;
           o_vsync : out STD_LOGIC);
end vga_position_controller;

architecture Behavioral of vga_position_controller is

-- back porch is 48
constant width : unsigned (9 downto 0) := TO_UNSIGNED(799,10); 
constant hendfrontporch: unsigned (9 downto 0) :=TO_UNSIGNED(655,10);
constant hendsync: unsigned (9 downto 0) := TO_UNSIGNED (751,10);

--back porch is 33
constant height : unsigned (9 downto 0) := TO_UNSIGNED (524,10);
constant vendfrontporch : unsigned (9 downto 0) := TO_UNSIGNED (489,10);
constant vendsync: unsigned (9 downto 0) :=TO_UNSIGNED (491,10);


signal x: unsigned (9 downto 0) := TO_UNSIGNED(0,10);
signal y: unsigned (9 downto 0) := TO_UNSIGNED(0,10);

begin 

process (i_clk, i_reset)
begin 
if(rising_edge(i_clk)) then 

    if(i_reset='1') then 
    x <= TO_UNSIGNED(0,10);
    y <= TO_UNSIGNED(0,10);
    
    elsif(x=width) then 
    x <= TO_UNSIGNED(0,10);   
       
       if(y=height) then
       y <= TO_UNSIGNED(0,10);
       
       else 
       y <= y+1;
       end if;
    
    else 
    x <= x+1;    
    end if; 

end if;
end process; 



process(x,y)
begin 

if(x >= hendfrontporch and x<= hendsync) then
o_hsync <= '0';
else 
o_hsync <= '1';
end if;

if(y >= vendfrontporch and y<= vendsync) then 
o_vsync <= '0';
else 
o_vsync <= '1';
end if; 

end process;

o_xpos <= std_logic_vector(x);
o_ypos <= std_logic_vector(y); 

end Behavioral;
