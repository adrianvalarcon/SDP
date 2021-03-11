----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2021 10:40:05 AM
-- Design Name: 
-- Module Name: bigcountdown - Behavioral
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

entity bigcountdown is
    Port ( sim: in boolean;
           i_clk : in STD_LOGIC;
           i_reset: in std_logic;
           state : in integer range 1 to 9;
           load : in STD_LOGIC;
           done : out STD_LOGIC;
           ack: in std_logic);
end bigcountdown;

architecture Behavioral of bigcountdown is

type waittype is array (1 to 9) of integer range 0 to 2_000_000_000;
constant waitsim: waittype :=(5,15,1,3,7,6,3,2,2);
constant waitreal: waittype :=
(1_700_000_000, --1 
10_000_000,  --2
1_700_000_000, --3 
12_000_000, --4
10_000_000, --5
10_000_000, --6
10_000_000, --7
41_000_000, --8
10_000_000); -- needs to be updated for real test
signal delay: waittype;
signal counter: integer range 0 to 1_000_000_000;
signal oldstate: integer range 0 to 9;
signal todone: std_logic;
signal ackreg: std_logic;
signal set: std_logic;
signal clear: std_logic;
signal divider: unsigned (2 downto 0);
begin


delay <= waitsim when sim else waitreal;
        



process(i_clk)
begin
if(rising_edge(i_clk)) then
if(i_reset='1') then 
    oldstate<=0;
    else
    if (load='1') then 
    oldstate<=state;
    counter<=delay(state);
    elsif (counter/=0 and divider="111") then 
    counter<=counter-1;
end if; 
end if;
end if;
end process;



process(counter,ack,ackreg,state,oldstate)
begin
if(ack='1' or ackreg='1' or state/=oldstate) then 
done<='0';
elsif(counter=0) then 
done<='1';
else 
done<='0';
end if;
end process;


set<= '1' when ack='1' else '0';
clear<= '1' when state/=oldstate else '0';


process(i_clk)
begin
if(rising_edge(i_clk)) then 
if(set='1') then 
ackreg<='1';
elsif (clear='1') then 
ackreg<='0';
end if;
end if;
end process; 


process(i_clk)
begin
if(rising_edge(i_clk)) then
if(i_reset='1') then
divider<="000";
else 
divider<=divider+1;
end if;
end if;
end process;




end Behavioral;
