// This is the package for using the Image Processor


package CellProcessingPkg;

	parameter opCodeWidth 	= 4;
	parameter channelWidth 	= 8;
	parameter channelNum    = 3;
	parameter pixelDepth  = channelWidth * channelNum;
	parameter cellN			= 3;
	parameter cellDepth		= pixelDepth * cellN * cellN;
	parameter centerPixel	= (cellN * cellN - 1) >> 1;
	parameter divShift		= $clog2(cellN * cellN);

    // type definition enumeration for opcodes
    typedef enum logic [opCodeWidth - 1:0] {ADD, ADDI, SUB, SUBI, MULT, MULTI, DIV2, INV, AND, OR, NOR, AVG} opcodes_t;

    // type definition for color channel
    typedef logic [channelWidth - 1:0] colorChannel_t;
	
	// type definition for user inputs
	typedef logic [pixelDepth - 1:0] userInput_t;

	// type definition for a pixel
	typedef logic [pixelDepth - 1:0] pixel_t;
	
	// type definition for a cell
	typedef union packed{
		logic	[cellDepth - 1:0]		singleCell;
		pixel_t [cellN * cellN - 1:0]	pixelMatrix; 
	} cell_t;

    // Function for adding two cell's center pixels to each other
    // Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
	function automatic pixel_t add (cell_t cellA, cellB);
		// Add each color channel in center pixel of cellA to corresponding pixel color channel of cellB
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			cellA.pixelMatrix[centerPixel][index +:channelWidth] += cellB.pixelMatrix[centerPixel][index +:channelWidth];
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction
    
    // Function for adding a cell's center pixel with an immediate user input
	// Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
    function automatic pixel_t addi (cell_t cellA, userInput_t userInputA);
        
        // Add user input to each color channel in center pixel of cellA
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			cellA.pixelMatrix[centerPixel][index +:channelWidth] += userInputA[index +:channelWidth];
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction

	// Function for subtracting two cell's center pixels from each other
    // Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
	function automatic pixel_t sub (cell_t cellA, cellB);
		// Add each color channel in center pixel of cellA to corresponding pixel color channel of cellB
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			cellA.pixelMatrix[centerPixel][index +:channelWidth] -= cellB.pixelMatrix[centerPixel][index +:channelWidth];
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction
    
    // Function for subtracting a user's input from a cell's center pixel
	// Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
    function automatic pixel_t subi (cell_t cellA, userInput_t userInputA);
        
        // Subtract user input from each color channel in center pixel of cellA
		for (int index = 0; index <= pixelDepth; index += channelWidth) begin
			cellA.pixelMatrix[centerPixel][index +:channelWidth] += userInputA[index +:channelWidth];
		end
		
		// Return result
        return cellA.pixelMatrix[centerPixel];
    endfunction
	
	// Function for averaging all pixels within a cell
	// Inputs: pixelMatrix_t
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
	import CellProcessingPkg::userInput_t;
	
	// Parameters for building an image
	parameter imageWidth 	= 640;
	parameter imageHeighth 	= 480;
	
	// type definition for an image
	typedef pixel_t [imageWidth - 1:0] ioBuf_t;
	typedef pixel_t [imageWidth - 1:0] cellBuf_t [cellN - 1:0];		// Unpacked so that it creates an appropriately sized block
	
	// type definition for instructions
    typedef struct packed{
		
		userInput_t userInputA;
        opcodes_t 	opcode;
    } instruction_t;

	// Function for processing one image through the CellProcessor
	
	
	
	// Function for processing two images through the CellProcessor
	
	
	
	// Function for processing an image with a user input through the CellProcessor
	
	
endpackage
