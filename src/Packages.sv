// This is the package for using the Image Processor


package CellProcessingPkg;

	parameter opCodeWidth 	= 4;
	parameter channelWidth 	= 8;
	parameter channelNum    = 3;
	parameter channelDepth  = channelWidth * channelNum;
	parameter cellN			= 3;
	parameter cellDepth		= channelDepth * cellN * cellN;
	parameter centerPixel	= (cellN - 1) >> 1;
	parameter divShift		= $clog2(cellN * cellN);

    // type definition enumeration for opcodes
    typedef enum logic [opCodeWidth - 1:0] {ADD, ADDI, SUB, SUBI, MULT, MULTI, DIV2, INV, AND, OR, NOR, AVG} opcodes_t;

    // type definition for color channel
    typedef logic [channelWidth - 1:0] colorChannel_t;
	
	// type definition for user inputs
	typedef logic [channelWidth - 1:0] userInput_t;

	// type definition for a pixel
	typedef struct packed{
		colorChannel_t red;
		colorChannel_t green;
		colorChannel_t blue;
	} pixel_t;
	
	// type definition for a cell
	typedef union packed{
		logic	[cellDepth - 1:0]		singleCell;
		pixel_t [cellN - 1:0][cellN - 1:0] 	pixelMatrix; 
	} cell_t;

    // Function for adding two cell's center pixels to each other
    // Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
	function automatic pixel_t add (cell_t cellA, cellB);
		// Add each color channel in center pixel of cellA to corresponding pixel color channel of cellB
		cellA.pixelMatrix[centerPixel][centerPixel].red 	+= cellB.pixelMatrix[centerPixel][centerPixel].red;
		cellA.pixelMatrix[centerPixel][centerPixel].green 	+= cellB.pixelMatrix[centerPixel][centerPixel].green;
		cellA.pixelMatrix[centerPixel][centerPixel].blue 	+= cellB.pixelMatrix[centerPixel][centerPixel].blue;
		
		// Return result
        return cellA.pixelMatrix[centerPixel][centerPixel];
    endfunction
    
    // Function for adding a cell's center pixel with an immediate user input
	// Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
    function automatic pixel_t addi (cell_t cellA, userInput_t userInputA);
        
        // Add user input to each color channel in center pixel of cellA
		cellA.pixelMatrix[centerPixel][centerPixel].red 	+= userInputA;
		cellA.pixelMatrix[centerPixel][centerPixel].green 	+= userInputA;
		cellA.pixelMatrix[centerPixel][centerPixel].blue 	+= userInputA;
		
		// Return result
        return cellA.pixelMatrix[centerPixel][centerPixel];
    endfunction

	// Function for subtracting two cell's center pixels from each other
    // Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
	function automatic pixel_t sub (cell_t cellA, cellB);
		// Add each color channel in center pixel of cellA to corresponding pixel color channel of cellB
		cellA.pixelMatrix[centerPixel][centerPixel].red 	-= cellB.pixelMatrix[centerPixel][centerPixel].red;
		cellA.pixelMatrix[centerPixel][centerPixel].green 	-= cellB.pixelMatrix[centerPixel][centerPixel].green;
		cellA.pixelMatrix[centerPixel][centerPixel].blue 	-= cellB.pixelMatrix[centerPixel][centerPixel].blue;
		
		// Return result
        return cellA.pixelMatrix[centerPixel][centerPixel];
    endfunction
    
    // Function for subtracting a user's input from a cell's center pixel
	// Inputs: pixelMatrix_t, userInput_t
	// Output: pixel_t
    function automatic pixel_t subi (cell_t cellA, userInput_t userInputA);
        
        // Subtract user input from each color channel in center pixel of cellA
		cellA.pixelMatrix[centerPixel][centerPixel].red 	-= userInputA;
		cellA.pixelMatrix[centerPixel][centerPixel].green 	-= userInputA;
		cellA.pixelMatrix[centerPixel][centerPixel].blue 	-= userInputA;
		
		// Return result
        return cellA.pixelMatrix[centerPixel][centerPixel];
    endfunction
	
	// Function for averaging all pixels within a cell
	// Inputs: pixelMatrix_t
	// Output: pixel_t
    function automatic pixel_t avg (cell_t cellA);
        // variable for storing the sum for output
		integer redSum, greenSum, blueSum;
		
        // Sum pixels within a cell
		foreach (cellA.pixelMatrix[x,y]) begin
			redSum 		+= cellA.pixelMatrix[x][y].red;
			greenSum 	+= cellA.pixelMatrix[x][y].green;
			blueSum		+= cellA.pixelMatrix[x][y].blue;
		end
		
		// Divide for average
		// This uses a predefined parameter using 
		redSum 		>>>= divShift;
		greenSum 	>>>= divShift;
		blueSum 	>>>= divShift;
		
		// Return result
        return {redSum,greenSum,blueSum};
    endfunction
endpackage

package ImageProcessingPkg;
	
	// Import necessary packages
	import CellProcessingPkg::pixel_t;
	import CellProcessingPkg::centerPixel;
	import CellProcessingPkg::opcodes_t;
	import CellProcessingPkg::userInput_t;
	
	// Parameters for building an image
	parameter imageWidth 	= 640;
	parameter imageHeighth 	= 480;
	
	// type definition for an image
	typedef pixel_t [imageWidth - 1:0][imageHeighth - 1:0] rxImage_t;
	typedef pixel_t [imageWidth - (centerPixel + 1):0][imageHeighth - (centerPixel + 1):0] txImage_t;
	
	// type definition for instructions
    typedef struct packed{
		rxImage_t 	imageA;
		rxImage_t	imageB;
		userInput_t userInputA;
        opcodes_t 	opcode;
    } instruction_t;

	// Function for processing two images through the CellProcessor
	
	
	
	// Function for processing an image with a user input through the CellProcessor
	
	
endpackage
