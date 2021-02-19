----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/29/2021 01:43:44 AM
-- Design Name: 
-- Module Name: baud_gen - Behavioral
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

entity baud_gen is
    generic (
        N           : integer := 6;   -- 2^4 = 16 samples per data bit
        cntr_bits   : integer := 55   -- 100MHz clk/(16 samples * 115200 baud rate) = 543
    );
    
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        tick    : out std_logic;
        bit_cnt : out std_logic_vector(N-1 downto 0)
    );
    end baud_gen;
    
architecture Behavioral of baud_gen is

    signal r_reg    : unsigned(N-1 downto 0);
    signal r_next   : unsigned(N-1 downto 0);
  
begin
  
    process (clk, reset)
    begin
        if (reset = '1') then
            r_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            r_reg <= r_next;
        end if;
    end process;
    
    -- Next State Logic
    r_next <= (others => '0') when r_reg = (cntr_bits - 1) else r_reg + 1;
    
    -- Output Logic
    bit_cnt <= std_logic_vector(r_reg);
    tick <= '1' when r_reg = (cntr_bits - 1) else '0';
    
end Behavioral;