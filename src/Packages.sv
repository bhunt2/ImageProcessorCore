// This is the package for using complex numbers

// // Definitions for real and imaginary parts of complex number
`define ChannelWidth 7:0
`define CellSize 2:0

package ImageProcessingPkg;

    // type definition enumeration for opcodes
    typedef enum {ADD, ADDI, SUB, SUBI, MULT, MULTI, DIV2, INV, AND, OR, NOR} opcodes_t;

    // type definition for color channel
    typedef logic [`ChannelWidth] colorChannel;
	
	// type definition for user inputs
	typedef logic [`ChannelWidth] userInput;

	// type definition for a pixel
	typedef union {
		colorChannel red, green, blue;
		colorChannel [2:0] pixel;
	} pixel_t;
	
	// type definition for a pixelMatrix or cell
	typedef union {
		pixel_t [`CellSize][`CellSize] pixelMatrix; 
	} pixelMatrix_t;
	
    // type definition for instructions
    typedef struct {
		pixelMatrix_t cellA;
		pixelMatrix_t cellB;
		userInput userInputA;
        opcodes_t opcode;
    } instruction_t;

    // Function for adding two complex numbers
    function automatic pixelMatrix_t add (pixelMatrix_t cellA, cellB);
        
		// Add each pixel in cellA to corresponding pixel in cellB
		foreach ( cellA[i,j] ) begin
			cellA[i][j].red      += cellB[i][j].red;
			cellA[i][j].green    += cellB[i][j].green;
			cellA[i][j].blue     += cellB[i][j].blue;
		end
        
        // Return result
        return cellA;
    endfunction

endpackage

