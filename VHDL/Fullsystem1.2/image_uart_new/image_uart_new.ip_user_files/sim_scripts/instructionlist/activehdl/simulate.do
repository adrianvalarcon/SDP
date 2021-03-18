onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+instructionlist -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.instructionlist xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {instructionlist.udo}

run -all

endsim

quit -force
