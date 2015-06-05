// ImageProcessor.sv - Top level for the image processor
//
// Author: 			Benjamin Huntsman
// Date Created: 	30 April 2015
// 
// Description:
// ------------
//  The top level module that defines image processor architecture. The image
//  processor uses parallel cell processors to process the image at an
//  accelerated rate. 
//
//
// Cell Processor Ports
//  Interface:
//      logic    clk, rst
//    	pixel_t  pixelA, pixelB
//    	pixel_t  userInputA
//	  	opcode_t opcode
//		pixel_t  processedPixel
//	  
///////////////////////////////////////////////////////////////////////////

import ImageProcessingPkg::*;
import CellProcessingPkg::*;

module ImageProcessor(
	input 			clk,
	input 			rst,
	input pixel_t 	pixelA,
	input pixel_t 	pixelB,
	input opcodes_t opcode,
	output pixel_t 	result
);

	// Registers for pulling in and buffering data
	reg [

    // Bring in the 
    always_comb begin
		
    end

endmodule
