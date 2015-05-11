configure -emul velocesolo1

reg setvalue veloce_top.rst 1
run 10

reg setvalue veloce_top.rst 0
run 10

reg setvalue veloce_top.cellA 216'h0
reg setvalue veloce_top.cellB 216'hffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff00
reg setvalue veloce_top.opcode 2'h0
run 5

reg setvalue veloce_top.cellB 216'h111111111111111111111111cccccc111111111111111111111111
run 5



upload -tracedir ./veloce.wave/wave1
exit 
