----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2021 10:02:03 AM
-- Design Name: 
-- Module Name: pixel_configure - Behavioral
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

entity pixel_configure is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_pixel : in STD_LOGIC_VECTOR (11 downto 0);
           o_location : out STD_LOGIC_VECTOR (18 downto 0);
           o_byte : out STD_LOGIC_VECTOR (7 downto 0);
           o_last_byte : out STD_LOGIC;
           o_valid_byte: out std_logic;
           i_next_byte : in STD_LOGIC);
end pixel_configure;

architecture Behavioral of pixel_configure is

type statetype is (start,delays,r1s,r2s,b1,b2,b3,done);
signal state: statetype;
signal nextloadstate: statetype;
signal delay_count: unsigned (1 downto 0);
signal delay_on: std_logic;
signal location: unsigned (18 downto 0);
signal R1: std_logic_vector (11 downto 0);
signal R2: std_logic_vector (11 downto 0);
signal last_byte: std_logic;
begin


delaycounter:process(i_clk)
begin 
if(rising_edge(i_clk)) then 
if(i_reset='1') then
delay_count<="00";
elsif (state=delays) then delay_count<=delay_count+1;
end if;
end if;
end process;



nextload: process(i_clk)
begin
if(rising_edge(i_clk)) then 
if(i_reset='1') then
nextloadstate<=r1s;
elsif(state=r1s) then 
nextloadstate<=r2s;
elsif(state=r2s) then 
nextloadstate<=r1s;
end if;
end if;
end process;


SM: process(i_clk)
begin
if(rising_edge(i_clk)) then 
if(i_reset='1') then
state<=start;
o_last_byte<='0';
else 
case state is

when start => 
location<= (others=>'0');
R1<=(others=>'0');
R2<=(others=>'0');
state<=delays;

when delays=>
if(delay_count="11") then 
state<=nextloadstate;
end if;

when r1s => 
R1<=i_pixel;
location<=location+1;
state<=delays;

when r2s =>
R2<=i_pixel;
location<=location+1;
state<=b1;

when b1 =>
if( i_next_byte='1') then 
state<=b2;
end if;

when b2 =>
if( i_next_byte='1') then 
state<=b3;
o_last_byte <= last_byte;
end if;

when b3 =>
if(last_byte='1') then
state <= done;
elsif( i_next_byte='1') then 
state<=delays;
end if;

when done =>
state<=done;

end case;
end if;
end if;
end process;


process(location)
begin
if(location=TO_UNSIGNED(272_640,19)) then 
last_byte<='1';
else
last_byte<='0';
end if;
end process;





process(state)
begin
if(state=b1 or state=b2 or state=b3) then 
o_valid_byte<='1';
else 
o_valid_byte<='0';
end if; 
end process;

o_location<=std_logic_vector(location);

process(state) 
begin 
case state is

when b1 =>
o_byte<= R1(11 downto 4); 

when b2 =>
o_byte<= R1(3 downto 0) & R2(11 downto 8); 

when b3 =>
o_byte<= R2(7 downto 0); 

when others => 
o_byte<=(others=>'0');
end case;
end process;





end Behavioral;
