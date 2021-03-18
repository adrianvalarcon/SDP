onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib vga_clk_opt

do {wave.do}

view wave
view structure
view signals

do {vga_clk.udo}

run -all

quit -force
