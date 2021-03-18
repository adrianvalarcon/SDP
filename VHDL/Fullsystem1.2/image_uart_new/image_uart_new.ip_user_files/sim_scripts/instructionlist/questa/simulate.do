onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib instructionlist_opt

do {wave.do}

view wave
view structure
view signals

do {instructionlist.udo}

run -all

quit -force
