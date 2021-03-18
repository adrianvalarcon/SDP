onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+uartloader_fifo -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.uartloader_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {uartloader_fifo.udo}

run -all

endsim

quit -force
