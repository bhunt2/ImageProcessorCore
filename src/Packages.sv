// Packages.sv - Package File
//
// Author: 			Benjamin Huntsman
// Date Created: 	30 April 2015
// 
// Description:
// ------------
//  Packages used for working with the cell processors and image processor.
//  Includes type definitions and other necessary parameters for
//  parameterization of design. Also, functions for each of the operations
//  accomplished by the cell processor.
//
//  Use of functions:
//		The functions receive one cell, two cells, or
//      a cell and a pixel as inputs. To use them you
//      set up the function as follows where result is
//      a register of pixel size that is the output.
//      	always_comb begin
//		   		if(ports.rst)
//					RESULT = ~0;
//				else begin
//					case (ports.opcode)
//						ADD :   RESULT  = add(cellBlockA, cellBlockB);
//						ADDI:   RESULT  = addi(cellBlockA, ports.userInput);
//						SUB :   RESULT  = sub(cellBlockA, cellBlockB);
//						SUBI:   RESULT  = subi(cellBlockA, ports.userInput);
//						default: RESULT = cellBlockA.pixelMatrix[centerPixel];
//					endcase
//				end
//			end
//
//  Syntax Notes:
//		Step Through Color Channels -
//			So that the design is completely parameterized and not independent
//          of a color space, an indexed part select is used.
//          	cellA.pixelMatrix[centerPixel][index +:channelWidth]
//				and [<starting index><+/->:<number of bits>]
//			If index = 0 and channelWidth = 8
//				then [index +: channelWidth] is equivalent to [7:0]
//			if index = 23 and channelWidth = 8
//				then [index -: channelWidth] is equivalent to [23:16]
//	  
///////////////////////////////////////////////////////////////////////////

package CellProcessingPkg;

	parameter opCodeWidth 	= 4;
	parameter channelWidth 	= 8;
	parameter channelNum    = 3;
	parameter cellN			= 3;
	parameter pixelDepth    = channelWidth * channelNum;
	parameter cellDepth		= pixelDepth * cellN * cellN;
	parameter centerPixel	= (cellN * cellN - 1) >> 1;
	parameter divShift		= $clog2(cellN * cellN);
	parameter boundUp		= 1 << channelWidth + 1;

    // type definition enumeration for opcodes
    typedef enum logic [opCodeWidth - 1:0] {ADD, ADDI, SUB, SUBI, MULT, MULTI, DIV2, INV, AND, OR, NOR, AVG} opcodes_t;

    // type definition for color channel
    typedef logic [channelWidth - 1:0] colorChannel_t;

	// type definition for a pixel
	typedef logic [pixelDepth - 1:0] pixel_t;
	
	// type definition for a cell
	typedef union packed{
		logic	[cellDepth - 1:0]		singleCell;
		pixel_t [cellN * cellN - 1:0]	pixelMatrix; 
	} cell_t;

    // Function for adding two cell's center pixels to each other
    // Inputs: cell_t, cell_t
	// Output: pixel_t
	function automatic pixel_t add (cell_t cellA, cellB);
		logic [channelWidth:0] tempPix;
		
		// Add each color channel in center pixel of cellA to corresponding pixel color channel of cellB
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			tempPix = cellA.pixelMatrix[centerPixel][index +:channelWidth] + cellB.pixelMatrix[centerPixel][index +:channelWidth];
			if(tempPix >= boundUp) begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = ~0;
			end
			else begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = tempPix;
			end
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction
    
    // Function for adding a cell's center pixel with an immediate user input
	// Inputs: cell_t, pixel_t
	// Output: pixel_t

    function automatic pixel_t addi (cell_t cellA, pixel_t userInput);
        logic [channelWidth:0] tempPix;
		
        // Add user input to each color channel in center pixel of cellA
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			tempPix = cellA.pixelMatrix[centerPixel][index +:channelWidth] + userInput[index +:channelWidth];
			if(tempPix >= boundUp) begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = ~0;
			end
			else begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = tempPix;
			end
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction

	// Function for subtracting two cell's center pixels from each other
    // Inputs: cell_t, cell_t
	// Output: pixel_t
	function automatic pixel_t sub (cell_t cellA, cellB);
		logic [channelWidth:0] tempPix;
		
		// Add each color channel in center pixel of cellA to corresponding pixel color channel of cellB
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			tempPix = cellA.pixelMatrix[centerPixel][index +:channelWidth] - cellB.pixelMatrix[centerPixel][index +:channelWidth];
			if(tempPix >= boundUp) begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = 0;
			end
			else begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = tempPix;
			end
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction
    
    // Function for subtracting a user's input from a cell's center pixel
	// Inputs: cell_t, pixel_t
	// Output: pixel_t
    function automatic pixel_t subi (cell_t cellA, pixel_t userInput);
        logic [channelWidth:0] tempPix;
		
        // Subtract user input from each color channel in center pixel of cellA
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			tempPix = cellA.pixelMatrix[centerPixel][index +:channelWidth] - userInput[index +:channelWidth];
			if(tempPix >= boundUp) begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = 0;
			end
			else begin
				cellA.pixelMatrix[centerPixel][index +:channelWidth] = tempPix;
			end
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction
	
	// Function for averaging all pixels within a cell
	// Inputs: cell_t
	// Output: pixel_t
    function automatic pixel_t avg (cell_t cellA);
        // variable for storing the sum for output
		integer redSum, greenSum, blueSum;
		
        // Sum pixels within a cell
		foreach (cellA.pixelMatrix[x]) begin
			redSum 		+= cellA.pixelMatrix[x][7:0];
			greenSum 	+= cellA.pixelMatrix[x][15:8];
			blueSum		+= cellA.pixelMatrix[x][23:16];
		end
		
		// Divide for average
		// This uses a predefined parameter using 
		redSum 		>>>= divShift;
		greenSum 	>>>= divShift;
		blueSum 	>>>= divShift;
		
		// Return result
        return {redSum[channelWidth - 1:0],greenSum[channelWidth - 1:0],blueSum[channelWidth - 1:0]};
    endfunction
endpackage

package ImageProcessingPkg;
	
	// Import necessary packages
	import CellProcessingPkg::pixel_t;
	import CellProcessingPkg::cellN;
	import CellProcessingPkg::centerPixel;
	import CellProcessingPkg::opcodes_t;
	
	// Parameters for building an image
	parameter imageWidth 	= 640;
	parameter imageHeighth 	= 480;
	
	// type definition for an image
	typedef pixel_t [imageWidth - 1:0] ioBuf_t;
	typedef pixel_t [imageWidth - 1:0] cellBuf_t [cellN - 1:0];		// Unpacked so that it creates an appropriately sized block
	
	// type definition for instructions
    typedef struct packed{
		pixel_t 	pixelA;
		pixel_t	    pixelB;
		pixel_t		userInput;
        opcodes_t 	opcode;
    } instruction_t;

	// Function for processing one image through the CellProcessor
	
	
	// Function for processing two images through the CellProcessor
	
	
	// Function for processing an image with a user input through the CellProcessor
	
	
endpackage
