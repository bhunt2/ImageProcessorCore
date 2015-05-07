view wave
dataset open ./veloce.wave/wave1.stw wave1
wave add -d wave1 {ImageProcessor.IW.cellA} {ImageProcessor.IW.cellA} {ImageProcessor.IW.opcode} ImageProcessor.clk ImageProcessor.rst {ImageProcessor.result}
echo "wave1.stw loaded and signals added. Open the Wave window to observe outputs."