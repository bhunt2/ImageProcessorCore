module TestBench;

	// Bring in the ImageProcessorPkg
    import CellProcessingPkg::*;
    
    // Establish registers/wires for using the Image Processor Core
    reg clk;
    reg rst;
    pixel_t result;
    instruction_t IW;
    	
	// Instantiate a single cell processor
    CellProcessor cellCore (clk,rst,IW,result);
    
endmodule