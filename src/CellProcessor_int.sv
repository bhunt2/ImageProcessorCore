// Interface
interface cellProcessor_int(input logic clk, rst);
    CellProcessingPkg::cell_t 		cellA;
    CellProcessingPkg::cell_t 		cellB;
    CellProcessingPkg::userInput_t userInputA;
    CellProcessingPkg::opcodes_t 	opcode;
    CellProcessingPkg::cell_t		processedCell;
    
    modport cellPorts ( input  clk,
                        input  rst,
                        input  cellA,
                        input  cellB,
                        input  userInputA,
                        input  opcode,
                        output processedCell
                      );
                      
    modport imagePorts ( output cellA,
                         output cellB,
                         output userInputA,
                         output opcode
                       );
                       
endinterface