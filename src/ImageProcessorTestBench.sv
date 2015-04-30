// This is the test bench for testing the package and the module for operating
//  on a image cell made of a square matrix of pixels.

module TestBench;
    // Bring in the ImageProcessorPkg
    import ImageProcessPkg::*;
    
    // Establish registers/wires for using the Image Processor Core
    reg clk;
    pixelMatrix_t result;
    instruction_t IW;

    // Parameters for timing
    parameter CLOCK_CYCLE   = 10ns;             // Using time value suffix for 10 nanoseconds
    parameter IDLE_CLOCKS   = 2;
    localparam CLOCK_WIDTH  = CLOCK_CYCLE/2;

    
    // Local parameters for true and false statements
    localparam  TRUE    = 1'b1,
                FALSE   = 1'b0;


    // Get a clock going
    initial begin
        clk = FALSE;
        forever #CLOCK_WIDTH clk = ~clk;
    end

    
    // Monitor results
    initial begin
        $display("                Time  Result    CellA    CellB  Result\n");
        $monitor($time, "       %f  %f  %f", IW.cellA, IW.cellB, result);
    end

    // Setup a struct to use for testing the cells
    typedef enum {
        black   = 24'h000000,
        white   = 24'hFFFFFF,
        red     = 24'hFF0000,
        lime    = 24'h00FF00,
        blue    = 24'h0000FF
    } colors_t;
    colors_t colors;

    // Generate stimulus
    initial begin
        			                 IW.cellA.pixel; 		      IW.cellB = 0;
        repeat (2) @(negedge Clock); IW.cellA = 1;                IW.cellB = 1;                IW.x = 0;   IW.y = 0;   	IW.opcode = ADD;
        repeat (2) @(negedge Clock); IW.cellA = $realtobits(1.1); IW.cellB = $realtobits(1.1);   
        repeat (2) @(negedge Clock); IW.cellA = $realtobits(1.1); IW.cellB = $realtobits(1.1);        			IW.opcode = MUL;
        repeat (2) @(negedge Clock); IW.cellA = 0;                IW.cellB = 0;                IW.x = 1.1; IW.y = 1.1; 	IW.opcode = CREATE;
        repeat (2) @(negedge Clock); IW.cellA = $realtobits(1.1); IW.cellB = 0;                IW.x = 0;   IW.y = 0;   	IW.opcode = PRINT;
        repeat (4) @(negedge Clock);
        $stop;
    end


    // Instantiate the Image Processor Core
    ImageProcessor IPCore (clk, IW, result);

endmodule
