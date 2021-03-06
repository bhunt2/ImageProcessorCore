// This is the test bench for testing the package and the module for operating
//  on a image cell made of a square matrix of pixels.

module TestBench;
    // Bring in the ImageProcessorPkg
    import CellProcessingPkg::*;
    
    // Establish registers/wires for using the Image Processor Core
    reg clk;
    reg rst;
    pixel_t result;
    instruction_t IW;

    // Parameters for timing
    parameter CLOCK_CYCLE   = 10;             // Using time value suffix for 10 nanoseconds
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
        $display("                Time   OpCode     CellACenterPixel       CellBCenterPixel        Result\n");
        $monitor($time, "       %h      %h  %h      %h", IW.opcode, IW.cellA.pixelMatrix[centerPixel][centerPixel], IW.cellB.pixelMatrix[centerPixel][centerPixel], result);
    end

    // Setup a struct to use for testing the cells
    enum logic [23:0]{
        black   = 24'h000000,
        white   = 24'hFFFFFF,
        red     = 24'hFF0000,
        lime    = 24'h00FF00,
        blue    = 24'h0000FF
    } colors_t;

    // Generate stimulus
    initial begin
                                     foreach ( IW.cellA.pixelMatrix[i,j] ) begin
                                         IW.cellA.pixelMatrix[i][j] = black;
                                     end
                                     foreach (IW.cellB.pixelMatrix[i,j]) begin
                                         IW.cellB.pixelMatrix[i][j] = black;
                                     end
                                     IW.opcode = ADD;
                                     rst = 1;
        repeat (2) @(negedge clk);   rst = 0;
        repeat (2) @(negedge clk);   foreach (IW.cellB.pixelMatrix[i,j]) begin
                                         IW.cellB.pixelMatrix[i][j] = lime;
                                     end
        repeat (2) @(negedge clk);   foreach (IW.cellA.pixelMatrix[i,j]) begin
                                         IW.cellA.pixelMatrix[i][j] = blue;
                                     end
        repeat (2) @(negedge clk);   foreach (IW.cellB.pixelMatrix[i,j]) begin
                                         IW.cellB.pixelMatrix[i][j] = red;
                                     end
    end


    // Instantiate a single cell processor
    CellProcessor cellCore (clk, rst, IW, result);

endmodule
