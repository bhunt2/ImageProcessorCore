import CellProcessingPkg::pixelDepth;
import CellProcessingPkg::opCodeWidth;
import CellProcessingPkg::pixel_t;
import CellProcessingPkg::userInputA;

// Interface
interface ImageProcessor_int(input logic clk, rst);
    pixel_t 					pixelA;
    pixel_t 					pixelB;
    userInput_t  				userInputA;
    logic [opCodeWidth - 1:0]	opcode;
    pixel_t						processedPixel;
  
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