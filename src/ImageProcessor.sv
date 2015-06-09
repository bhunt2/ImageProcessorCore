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
//    	pixel_t  userInput
//	  	opcode_t opcode
//		pixel_t  processedPixel
//	  
///////////////////////////////////////////////////////////////////////////


module ImageProcessor(
	ImageProcessor_int.inports ports
);
	// Import Packages
	import ImageProcessingPkg::*;
	import CellProcessingPkg::*;

	// Registers for pulling in and buffering data
    ioBuf_t [1:0] inputShiftReg;			// Input buf for two pixels
	ioBuf_t [1:0] outputShiftReg;			// Output buf for two pixels
	pixel_t 					userInput
	logic [opCodeWidth - 1:0] 	opCodeReg;	// Store opcode for operation

    // Bring in the 
    always_comb begin
		
    end

endmodule
