onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+vga_clk -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.vga_clk xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {vga_clk.udo}

run -all

endsim

quit -force
