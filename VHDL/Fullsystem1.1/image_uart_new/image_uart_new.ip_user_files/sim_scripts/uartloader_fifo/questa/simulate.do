onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib uartloader_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {uartloader_fifo.udo}

run -all

quit -force
