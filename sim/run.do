configure -emul velocesolo1

reg setvalue CellProcessor.rst 1
run 10

reg setvalue CellProcessor.rst 0
run 10

reg setvalue CellProcessor.IW.cellA 216'h0
reg setvalue CellProcessor.IW.cellB 216'hffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff
reg setvalue CellProcessor.opcode 2'h0
run 1

upload -tracedir ./veloce.wave/wave1
exit 