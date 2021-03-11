----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2021 01:16:30 PM
-- Design Name: 
-- Module Name: FIFO_loader - Behavioral
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
use IEEE.numeric_std.All;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO_loader is
    Port ( i_clk : in STD_LOGIC;
           i_reset: in STD_LOGIC;
           i_command : in STD_LOGIC_VECTOR (399 downto 0);
           i_pixel : in STD_LOGIC;
           o_selcmd : out STD_LOGIC_VECTOR (2 downto 0);
           o_loadfifo: out STD_LOGIC;
           o_data: out STD_Logic_Vector(7 downto 0);
           o_next_byte: out std_logic;
           i_last_byte: in std_logic;
           i_through_data: in STD_Logic_Vector(7 downto 0);
           i_pixel_valid: in std_logic);
           
end FIFO_loader;

architecture Behavioral of FIFO_loader is

signal taskdone: std_logic;
signal timerdone: std_logic;
type instructionstate is(init,i1,i2,i3,i4,i5,i6,i7,data,i8,idle);
signal instruction: instructionstate;
signal lastinstruction: instructionstate; 

type bytesenderstate is(nr,sending);
signal sendstate: bytesenderstate;
signal bytenumber:  integer range 0 to 49;
signal send_byte: std_logic;
--signal keep_sending: std_logic;
signal valid_data:std_logic;
signal data_to_send: std_logic_vector(7 downto 0);
signal short_delay: unsigned (1 downto 0);
signal muxselect: std_logic_vector(5 downto 0);
signal statenum: integer range 1 to 9;
--signal timer_ack: std_logic;
signal full_load_sent:std_logic;
signal byte_counter: integer range 0 to 2047;

type datastatetype is (idle,loadbyte,sn,delay);
signal datastate: datastatetype;
signal ra: std_logic; 
signal load_timer: std_logic;
signal start_timer: std_logic;

type holddatatype is record
data : std_logic_vector(7 downto 0);
valid: std_logic;
end record;


signal datareg:holddatatype;
 
signal image_bytes_sent: integer range 0 to 50_000_000; 
 
begin

newstate:process(i_clk)
begin
if(rising_edge(i_clk)) then 
if(i_reset='1') then
lastinstruction <= init;
else
lastinstruction<=instruction;
end if;
end if;
end process;

bigState:process(i_clk)
begin
if(rising_edge(i_clk)) then

if(i_reset='1') then
instruction<=init;
else

case instruction is

when init=>
instruction<=i1;


when i1 => 
if(timerdone='1') then 
instruction<=i2;
end if;

when i2 => 
if(timerdone='1') then 
instruction<=i3;
end if;

when i3 => 
if(timerdone='1') then 
instruction<=i4;
end if;

when i4 => 
if(timerdone='1') then 
instruction<=i5;
end if;

when i5 => 
if(timerdone='1') then 
instruction<=i6;
end if;

when i6 => 
if( timerdone='1') then 
instruction<=i7;
end if;


when i7 => 
if(timerdone='1') then 
instruction<=data;
end if;

when data => 
if(timerdone='1' and full_load_sent='1') then 
instruction<=i8;
elsif(timerdone='1') then
instruction<=i7;
end if;

when i8 => 
if(timerdone='1') then 
instruction<=idle;
end if;

when idle =>
instruction<=idle;
end case;
end if; 
end if; 
end process;


comb_logic_bigstate: process(instruction)
begin



o_selcmd<="000";
statenum<=1;

case instruction is


when init=>
o_selcmd<="000";

when i1 => 
o_selcmd<="000";

when i2 => 
o_selcmd<="001";
statenum<=2;

when i3 => 
o_selcmd<="010";
statenum<=3;

when i4 => 
o_selcmd<="011";
statenum<=4;

when i5 => 
o_selcmd<="100";
statenum<=5;

when i6 => 
o_selcmd<="101";
statenum<=6;

when i7 => 
o_selcmd<="110";
statenum<=7;

when data => 
o_selcmd<="000";
statenum<=8;

when i8 => 
o_selcmd<="111";
statenum<=9;

when idle =>
o_selcmd<="000";

end case;

end process;

bytesender:process(i_clk) begin
if (rising_edge (i_clk)) then 
if(i_reset='1') then
sendstate<=nr;
taskdone<='0';
else 
case sendstate is 

when nr=>
taskdone<='0';
if(send_byte='1') then 
sendstate<=sending;
else
sendstate<=nr;
end if;

when sending=>
if(valid_data='1') then 
sendstate<=sending;
taskdone<='0';
else 
sendstate<=nr;
taskdone<='1';
end if;
end case; 
end if; 
end if;
end process;


bytesendercomb: process(sendstate,send_byte,data_to_send,datareg.valid)
begin
if((sendstate=sending and data_to_send/="00000000") or send_byte='1' or datareg.valid='1') then 
o_loadfifo<='1';
else
o_loadfifo<='0';
end if;
end process;


bytecounter:process(i_clk)
begin
if(rising_edge (i_clk)) then 

if(send_byte='1' or (valid_data='1' and bytenumber /=49)) then 
bytenumber<=bytenumber-1;
else
bytenumber<=49; 
end if;
end if;
end process;

muxselect<=std_logic_vector (TO_UNSIGNED(bytenumber,6));

MUX512x8: entity work.mux64x1  port map(
din => i_command,
s => muxselect,
dout => data_to_send);

data_good:process(bytenumber)
begin
if(data_to_send="00000000") then
valid_data<='0';
else 
valid_data<='1';
end if;
end process; 


process(i_clk) 
begin
if(rising_edge(i_clk)) then
if(i_reset='1') then 
short_delay<="00";
elsif(instruction /= lastinstruction or short_delay/="00") then 
short_delay<=short_delay+1;
end if;
end if;
end process;


process(short_delay)
begin
if(short_delay="11" and instruction/=data) then
send_byte<='1';
else 
send_byte<='0';
end if;
end process; 

o_data<= data_to_send when (instruction/=data) else datareg.data ; 
load_timer<= taskdone or start_timer;

delay_counter: entity work.bigcountdown 
port map (
sim => true,
i_clk => i_clk,
i_reset => i_reset,
state => statenum,
load => load_timer,
done => timerdone,
ack => '0');


data_sm: process(i_clk)
begin
if(rising_edge(i_clk)) then 
if(i_reset='1') then
datastate<=idle;
byte_counter<=0;
datareg.valid<='0';
ra<='1';
full_load_sent<='0';
else 
case datastate is

when idle=> 
if(instruction=data) then 
datastate<=loadbyte;
byte_counter<=0;
datareg.valid<='0';
ra<='1';
end if;

when loadbyte =>

datareg.data<=i_through_data;
datareg.valid<=i_pixel_valid;
if(i_pixel_valid='1') then 
byte_counter<=byte_counter + 1;
end if;
if(byte_counter=2047) then 
datastate<=delay;
elsif(i_last_byte='1') then 
datastate<=sn;
end if;

when sn =>
full_load_sent<='1';
datareg.data<=(others=>'0');
datareg.valid<='1';
byte_counter<=byte_counter + 1;
if(byte_counter=2047) then 
datastate<=delay;

end if;

when delay =>
ra<='0';
datareg.valid<='0';
if(timerdone='1') then 
datastate<=idle;
end if;
end case;
end if; 
end if;
end process; 


process(datastate,ra)
begin
if(datastate=delay and ra='1') then 
start_timer<='1';
else 
start_timer<='0';
end if;
end process;


process(datastate)
begin
if(datastate=loadbyte) then 
o_next_byte<='1';
else 
o_next_byte<='0';
end if;
end process;







process(i_clk)
begin 
if(rising_edge(i_clk)) then
if(i_reset='1') then
image_bytes_sent<=0;
elsif(datareg.valid='1') then 
image_bytes_sent<=image_bytes_sent+1;
end if;
end if;
end process;


end;









