import CellProcessingPkg::cellDepth;

// Interface
interface cellProcessor_int(input logic clk, rst);
    logic [cellDepth - 1:0] 		cellA;
    logic [cellDepth - 1:0] 		cellB;
    CellProcessingPkg::userInput_t  userInputA;
    CellProcessingPkg::opcodes_t 	opcode;
    CellProcessingPkg::pixel_t		processedPixel;
    
    modport cellPorts ( input  clk,
                        input  rst,
                        input  cellA,
                        input  cellB,
                        input  userInputA,
                        input  opcode,
                        output processedPixel
                      );
                      
    modport imagePorts ( output cellA,
                         output cellB,
                         output userInputA,
                         output opcode
                       );
                       
endinterface