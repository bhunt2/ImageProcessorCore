// ImageProcesspr_int.sv - Interface for working with the cell processor.
//
// Author: 			Benjamin Huntsman
// Date Created: 	30 April 2015
// 
// Description:
// ------------
//  This defines the interface for working with the image processor. Modports
//  for the image processor and connecting modules are provided and
//  recommended for use.
//
//
// Cell Processor Ports
//  Interface:
//      logic    clk, rst
//    	pixel_t  pixelA, pixelB
//    	pixel_t  userInput
//	  	opcode_t opcode
//		pixel_t  processedPixel
//	  
///////////////////////////////////////////////////////////////////////////

import CellProcessingPkg::pixelDepth;
import CellProcessingPkg::opCodeWidth;
import CellProcessingPkg::pixel_t;
import CellProcessingPkg::userInput_t;

// Interface
interface ImageProcessor_int(input logic clk, rst);
    pixel_t 					pixelA;
    pixel_t 					pixelB;
    pixel_t  					userInput;
    logic [opCodeWidth - 1:0]	opcode;
    pixel_t						processedPixel;
  
    modport intPorts (  input  clk,
                        input  rst,
                        input  pixelA,
                        input  pixelB,
                        input  userInput,
                        input  opcode,
                        output processedPixel
                      );
                      
    modport extPorts (  output pixelA,
                        output pixelB,
                        output userInput,
                        output opcode
                      );
                       
endinterface