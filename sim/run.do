configure -emul velocesolo1

reg setvalue simple_alu.reset 1
run 10

reg setvalue simple_alu.reset 0
run 10

reg setvalue simple_alu.operandA 8'h4
reg setvalue simple_alu.operandB 8'h4
reg setvalue simple_alu.opcode 2'h0
run 1


reg setvalue simple_alu.operandA 8'h4
reg setvalue simple_alu.operandB 8'h4
reg setvalue simple_alu.opcode 2'h1
run 1

reg setvalue simple_alu.operandA 8'hF
reg setvalue simple_alu.operandB 8'h7
reg setvalue simple_alu.opcode 2'h2
run 1

reg setvalue simple_alu.operandA 8'h4
reg setvalue simple_alu.operandB 8'h1
reg setvalue simple_alu.opcode 2'h3
run 1

upload -tracedir ./veloce.wave/wave1
exit 