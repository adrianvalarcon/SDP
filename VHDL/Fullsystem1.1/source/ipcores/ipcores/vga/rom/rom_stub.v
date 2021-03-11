// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Mar 10 17:43:06 2021
// Host        : LAPTOP-Q3NGNHTM running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/rylan/OneDrive/Desktop/Fullsystemfile/source/ipcores/ipcores/vga/rom/rom_stub.v
// Design      : rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module rom(clka, ena, addra, douta, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[18:0],douta[11:0],clkb,enb,addrb[18:0],doutb[11:0]" */;
  input clka;
  input ena;
  input [18:0]addra;
  output [11:0]douta;
  input clkb;
  input enb;
  input [18:0]addrb;
  output [11:0]doutb;
endmodule
