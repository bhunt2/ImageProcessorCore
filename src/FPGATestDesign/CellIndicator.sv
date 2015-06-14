`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Benjamin Huntsman
// 
// Create Date: 10/09/2014 10:41:38 AM
// Design Name: Image Processor
// Module Name: CellIndicator
// Project Name: Image Processor
// Target Devices: Nexys 4
// Tool Versions: 
// Description: This module is the Cell Indicator block that controls the cell indicator
// 7-segment display.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module CellIndicator
#(   
    parameter integer RESET_POLARITY_LOW = 1
 )
(    
    input	      SYSCLK,
    input	      RST,
    input  [15:0] DebouncedSwitches,
    cellProcessor_int.imagePorts ports
    ); 
 
    // Reset Logic
    wire reset_in = RESET_POLARITY_LOW? ~RST : RST;
    
    
    // Setup a struct to use for testing the cells
    enum logic [23:0]{
        BLACK   = 24'h000000,
        WHITE   = 24'hFFFFFF,
        RED     = 24'hFF0000,
        LIME    = 24'h00FF00,
        BLUE    = 24'h0000FF
    } colors;
	
            
    // Establish registers for current and next states
    reg [3:0] cellACS, cellANS;
	reg [3:0] cellBCS, cellBNS;
	reg [3:0] opcodeCS, opcodeNS;
	reg [7:0] userInput = 8'hAA;

  
    // Clock in new state
    always @(posedge SYSCLK) begin
        if(reset_in) begin
            cellACS  <= WHITE;
			cellBCS  <= WHITE;
		end
        else begin
            cellACS  <= cellANS;
			cellBCS  <= cellBNS;
		end
    end
    
    // Setup next state logic for cellA
	assign ports.cellA = {cellACS,cellACS,cellACS,cellACS,cellACS,cellACS,cellACS,cellACS,cellACS};
    always @(*) begin
        case (DebouncedSwitches[3:0])
            4'b0001: cellANS = BLACK;
			4'b0011: cellANS = RED;
			4'b0100: cellANS = LIME;
			4'b0101: cellANS = BLUE;
            default: cellANS = WHITE;
        endcase
    end
	
	// Setup next state logic for cellB
	assign ports.cellB = {cellBCS,cellBCS,cellBCS,cellBCS,cellBCS,cellBCS,cellBCS,cellBCS,cellBCS};
    always @(*) begin
        case (DebouncedSwitches[7:4])
            4'b0001: cellBNS = BLACK;
			4'b0011: cellBNS = RED;
			4'b0100: cellBNS = LIME;
			4'b0101: cellBNS = BLUE;
            default: cellBNS = WHITE;
        endcase
    end
	
	// Setup next state logic for opcodes
	assign ports.opcode = opcodeCS;
	always @(posedge SYSCLK) begin
		opcodeNS <= DebouncedSwitches[15:12];
		opcodeCS <= opcodeNS;
	end
			
endmodule
