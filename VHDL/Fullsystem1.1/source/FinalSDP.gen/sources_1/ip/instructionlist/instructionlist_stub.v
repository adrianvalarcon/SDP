// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Mar 12 13:41:50 2021
// Host        : DESKTOP-43OEE1M running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Users/Kyle/Documents/sr_proj_test/SDP/VHDL/Fullsystem1.1/source/FinalSDP.gen/sources_1/ip/instructionlist/instructionlist_stub.v
// Design      : instructionlist
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module instructionlist(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[2:0],douta[399:0]" */;
  input clka;
  input ena;
  input [2:0]addra;
  output [399:0]douta;
endmodule
