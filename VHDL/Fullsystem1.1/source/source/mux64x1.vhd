----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2021 09:05:33 PM
-- Design Name: 
-- Module Name: mux64x1 - Behavioral
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

entity mux64x1 is
    Port ( din : in STD_LOGIC_VECTOR (399 downto 0);
           s : in STD_LOGIC_Vector (5 downto 0);
           dout : out STD_LOGIC_VECTOR (7 downto 0));
end mux64x1;

architecture Behavioral of mux64x1 is

type row1type is array (0 to 31) of std_logic_vector(7 downto 0);
signal row1out: row1type;

type row2type is array (0 to 15) of std_logic_vector(7 downto 0);
signal row2out: row2type;

type row3type is array (0 to 7) of std_logic_vector(7 downto 0);
signal row3out: row3type;

type row4type is array (0 to 3) of std_logic_vector(7 downto 0);
signal row4out: row4type;

type row5type is array (0 to 1) of std_logic_vector(7 downto 0);
signal row5out: row5type;

begin



smallmux1: for I in 0 to 31 generate

USED1:if(I<25) generate 
row1mux:entity work.twoto1mux 
port map(
i1 => din(I*16+7 downto I*16),
i2 => din(I*16+15 downto I*16+8),
s => s(0),
z => row1out(I));
end generate;

NUSED: if(I>24) generate 
row1muxnu: entity work.twoto1mux 
port map(
i1 => (others=>'0'),
i2 => (others=>'0'),
s => s(0),
z => row1out(I));
end generate; 
end generate;

smallmux2: for I in 0 to 15 generate
row2mux: entity work.twoto1mux
port map(
i1 => row1out(I*2),
i2 => row1out(I*2+1),
s => s(1),
z => row2out(I));
end generate;


smallmux3: for I in 0 to 7 generate
row3mux: entity work.twoto1mux
port map(
i1 => row2out(I*2),
i2 => row2out(I*2+1),
s => s(2),
z => row3out(I));
end generate;

smallmux4: for I in 0 to 3 generate
row4mux: entity work.twoto1mux
port map(
i1 => row3out(I*2),
i2 => row3out(I*2+1),
s => s(3),
z => row4out(I));
end generate;

smallmux5: for I in 0 to 1 generate
row5mux: entity work.twoto1mux
port map(
i1 => row4out(I*2),
i2 => row4out(I*2+1),
s => s(4),
z => row5out(I));
end generate;


row6mux: entity work.twoto1mux
port map(
i1 => row5out(0),
i2 => row5out(1),
s => s(5),
z => dout);





end Behavioral;
