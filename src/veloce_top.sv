
module veloce_top
(
	input  clk,
	input  rst,
    input  [CellProcessingPkg::cellDepth - 1:0]	cellA,
    input  [CellProcessingPkg::cellDepth - 1:0]	cellB,
    input  CellProcessingPkg::userInput_t 		userInputA,
    input  CellProcessingPkg::opcodes_t 		opcode,
    output [CellProcessingPkg::cellDepth - 1:0]	processedCell
);
	
	cellProcessor_int cell_int(clk, rst);

	always @(posedge clk) begin
		cell_int.cellA.singleCell	<= cellA;
		cell_int.cellB.singleCell	<= cellB;
		cell_int.userInputA 		<= userInputA;
		cell_int.opcode				<= opcode;
	end

	assign processedCell = cell_int.processedCell.singleCell;

	// Instantiate the cell processor
	CellProcessor IPCore(.ports(cell_int.cellPorts));
	
endmodule
