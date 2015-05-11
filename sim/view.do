view wave
dataset open ./veloce.wave/wave1.stw wave1
wave add -d wave1 {veloce_top.cellA[215:0]} {veloce_top.cellB[215:0]} {veloce_top.opcode[3:0]} veloce_top.clk veloce_top.rst {veloce_top.processedPixel[23:0]}
echo "wave1.stw loaded and signals added. Open the Wave window to observe outputs."
