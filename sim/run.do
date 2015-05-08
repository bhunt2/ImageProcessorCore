configure -emul velocesolo1

reg setvalue veloce_top.rst 1
run 10

reg setvalue veloce_top.rst 0
run 10

reg setvalue veloce_top.cellA 216'h0
reg setvalue veloce_top.cellB 216'hffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff
reg setvalue veloce_top.opcode 2'h0
run 1

upload -tracedir ./veloce.wave/wave1
exit 
