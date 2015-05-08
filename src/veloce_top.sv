
module veloce_top
(
	input  clk,
	input  rst,
    input  CellProcessingPkg::cell_t 		cellA,
    input  CellProcessingPkg::cell_t 		cellB,
    input  CellProcessingPkg::userInput_t 	userInputA,
    input  CellProcessingPkg::opcodes_t 	opcode,
    output CellProcessingPkg::cell_t		processedCell
);
	
	cellProcessor_int cell_int(clk, rst);

	assign cell_int.cellA 		= cellA;
	assign cell_int.cellB 		= cellB;
	assign cell_int.userInputA 	= userInputA;
	assign cell_int.opcode		= opcode;
	assign processedCell		= cell_int.processedCell;

	// Instantiate the cell processor
	CellProcessor IPCore(.ports(cell_int.cellPorts));
	
endmodule