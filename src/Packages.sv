// This is the package for using complex numbers

// // Definitions for real and imaginary parts of complex number
`define ChannelWidth 7:0
`define CellSize 2:0
`define CellWidth 215:0

package ImageProcessingPkg;

    // type definition enumeration for opcodes
    typedef enum {ADD, ADDI, SUB, SUBI, MULT, MULTI, DIV2, INV, AND, OR, NOR} opcodes_t;

    // type definition for color channel
    typedef logic [`ChannelWidth] colorChannel;
	
	// type definition for user inputs
	typedef logic [`ChannelWidth] userInput;

	// type definition for a pixel
	typedef struct packed{
		colorChannel red;
		colorChannel green;
		colorChannel blue;
	} pixel_t;
	
	// type definition for a pixelMatrix or cell
	typedef union packed{
		pixel_t [`CellSize][`CellSize] pixelMatrix; 
		logic [`CellWidth] singleCell;
	} pixelMatrix_t;
	
    // type definition for instructions
    typedef struct packed{
		pixelMatrix_t cellA;
		pixelMatrix_t cellB;
		userInput userInputA;
        opcodes_t opcode;
    } instruction_t;

    // Function for adding two cells
    function automatic pixelMatrix_t add (pixelMatrix_t cellA, cellB);
        
		// Add each pixel in cellA to corresponding pixel in cellB
		foreach ( cellA.pixelMatrix[i,j] ) begin
			cellA.pixelMatrix[i][j].red      += cellB.pixelMatrix[i][j].red;
			cellA.pixelMatrix[i][j].green    += cellB.pixelMatrix[i][j].green;
			cellA.pixelMatrix[i][j].blue     += cellB.pixelMatrix[i][j].blue;
		end
        
        // Return result
        return cellA;
    endfunction
    
    // Function for adding a cell's pixels with an immediate user input
    function automatic pixelMatrix_t addi (pixelMatrix_t cellA, userInput userInputA);
        
        // Add userInputA to each pixel in cell
        foreach ( cellA.pixelMatrix[i,j] ) begin
            cellA.pixelMatrix[i][j].red      += userInputA;
            cellA.pixelMatrix[i][j].green    += userInputA;
            cellA.pixelMatrix[i][j].blue     += userInputA;
        end
        
        // Return result
        return cellA;
    endfunction

    // Function for subbing two cells
    function automatic pixelMatrix_t sub (pixelMatrix_t cellA, cellB);
        
		// Sub each pixel in cellA to corresponding pixel in cellB
		foreach ( cellA.pixelMatrix[i,j] ) begin
			cellA.pixelMatrix[i][j].red      -= cellB.pixelMatrix[i][j].red;
			cellA.pixelMatrix[i][j].green    -= cellB.pixelMatrix[i][j].green;
			cellA.pixelMatrix[i][j].blue     -= cellB.pixelMatrix[i][j].blue;
		end
        
        // Return result
        return cellA;
    endfunction
    
    // Function for subbing a cell's pixels with an immediate user input
    function automatic pixelMatrix_t subi (pixelMatrix_t cellA, userInput userInputA);
        
        // Sub user input from each pixel in cellA
        foreach ( cellA.pixelMatrix[i,j] ) begin
            cellA.pixelMatrix[i][j].red      += userInputA;
            cellA.pixelMatrix[i][j].green    += userInputA;
            cellA.pixelMatrix[i][j].blue     += userInputA;
        end
        
        // Return result
        return cellA;
    endfunction

endpackage

