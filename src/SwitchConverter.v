`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Benjamin Huntsman
// 
// Create Date: 10/09/2014 02:08:48 PM
// Design Name: SimpleBot
// Module Name: SwitchConverter
// Project Name: Project 1
// Target Devices: Nexys 4
// Tool Versions: 
// Description: This module coverts the debounced pushbuttons into a usable Motion Code for
// the rest of the design.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SwitchConverter(
    input	         CLK,
    input            BTN_LEFT,
    input            BTN_UP,
    input            BTN_RIGHT,
    input            BTN_DOWN,
    output reg [2:0] Code
    );
    
    // Parameters for output    
    localparam  STOP     = 3'b000,
                FORWARD  = 3'b001,
                REVERSE  = 3'b010,
                RIGHT1X  = 3'b011,
                RIGHT2X  = 3'b100,
                LEFT1X   = 3'b101,
                LEFT2X   = 3'b110;
                
    // Paramters for intput
    localparam  LNONERNONE  = 4'b0000,
                LNONERREV   = 4'b0001,
                LNONERFOR   = 4'b0010,
                LNONERSTOP  = 4'b0011,
                LREVRNONE   = 4'b0100,
                LREVRREV    = 4'b0101,
                LREVRFOR    = 4'b0110,
                LREVRSTOP   = 4'b0111,
                LFORRNONE   = 4'b1000,
                LFORRREV    = 4'b1001,
                LFORRFOR    = 4'b1010,
                LFORRSTOP   = 4'b1011,
                LSTOPRNONE  = 4'b1100,
                LSTOPRREV   = 4'b1101,
                LSTOPRFOR   = 4'b1110,
                LSTOPRSTOP  = 4'b1111;
                
    // PushButton to Motion Code Convertion
    always @(posedge CLK) begin
        case ({BTN_LEFT,BTN_UP,BTN_RIGHT,BTN_DOWN})
            LNONERNONE, LNONERSTOP, LSTOPRNONE, LSTOPRSTOP: MotionCode = STOP;
            LFORRFOR:                                       MotionCode = FORWARD;
            LREVRREV:                                       MotionCode = REVERSE;
            LNONERREV, LFORRNONE, LFORRSTOP, LSTOPRREV:     MotionCode = RIGHT1X;
            LNONERFOR, LREVRNONE, LREVRSTOP, LSTOPRFOR:     MotionCode = LEFT1X;
            LFORRREV:                                       MotionCode = RIGHT2X;
            LREVRFOR:                                       MotionCode = LEFT2X;
        endcase
    end
endmodule
