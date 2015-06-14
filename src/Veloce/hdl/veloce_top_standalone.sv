
module veloce_top
(
	input  clk,
	input  rst,
    input  [CellProcessingPkg::cellDepth - 1:0]	cellA,
    input  [CellProcessingPkg::cellDepth - 1:0]	cellB,
    input  CellProcessingPkg::userInput_t 		userInputA,
    input  CellProcessingPkg::opcodes_t 		opcode,
    output CellProcessingPkg::pixel_t			processedPixel
);
	
	cellProcessor_int cell_int(clk, rst);
	
	

	
	assign cell_int.cellA		= cellA;
	assign cell_int.cellB		= cellB;
	assign cell_int.userInputA  = userInputA;
	assign cell_int.opcode		= opcode;
	assign processedPixel 		= cell_int.processedPixel;

	// Instantiate the cell processor
	CellProcessor IPCore(.ports(cell_int.cellPorts));
	
endmodule
