`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Benjamin Huntsman
// 
// Create Date: 10/09/2014 10:41:38 AM
// Design Name: SimpleBot
// Module Name: MotionIndicator
// Project Name: Project 1
// Target Devices: Nexys 4
// Tool Versions: 
// Description: This module is the Motion Indicator block that controls the motion indicator
// 7-segment display.  It outputs a code that will display only one segment of the 7-segment
// display at a time.
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
    input         CLK_En,
    input	      RST,
    input  [15:0] DebouncedSwitches,
    output [215:0]CellA, CellB
    ); 
 
    // Reset Logic
    wire reset_in = RESET_POLARITY_LOW? ~RST : RST;
    
    // Setup output of CharCode
    // ColorChannel [4:0]   4  	3  	2  	1  	0
    //			00 0		0	0	0	0	0
	//			01 1		0	0 	0 	0 	1
	//        	02 2 		0 	0 	0 	1 	0 
	//			03 3 		0 	0 	0 	1 	1 
	//			04 4 		0 	0 	1 	0 	0 
	//			05 5 		0 	0 	1 	0 	1 
	//			06 6		0 	0 	1 	1 	0 
	//			07 7 		0 	0 	1 	1 	1 
	//			08 8		0 	1 	0 	0 	0 
	//			09 9		0 	1 	0 	0 	1 
	//			10 A 		0 	1 	0 	1 	0 
	//			11 B 		0 	1 	0 	1 	1 
	//			12 C 		0 	1 	1 	0 	0 
	//			13 D 		0 	1 	1 	0 	1 
	//			14 E 		0 	1 	1 	1 	0 
	//			15 F 		0 	1 	1 	1 	1 
    // This shows that ColorChannel [4] is constant.  Therefore it will
    // be set constant.
    
    // Eslablish local params to be used by the FSM
    // Parameters for Motion Code
    localparam  ZERO	= 4'h0
				ONE     = 4'h1,
				TWO		= 4'h2,
				THREE	= 4'h3,
				FOUR	= 4'h4,
				FIVE	= 4'h5,
				SIX		= 4'h6,
				SEVEN	= 4'h7,
				EIGHT	= 4'h8,
				NINE	= 4'h9,
				HEXA	= 4'hA,
				HEXB	= 4'hB,
				HEXC	= 4'hC,
				HEXD	= 4'hD,
				HEXE	= 4'hE,
				HEXF	= 4'hF;
				
    // Parameters for States
    localparam  Seg_A    = 3'b000,
                Seg_B    = 3'b001,
                Seg_C    = 3'b010,
                Seg_D    = 3'b011,
                Seg_E    = 3'b100,
                Seg_F    = 3'b101,
                Seg_G    = 3'b110,
                ALL_OFF  = 3'b111;
            
    // Establish registers for current and next states
    reg [3:0] RedCurrentState, RedNextState;
	reg [3:0] GreenCurrentState, GreenNextState;
	reg [3:0] BlueCurrentState, BlueNextState;
    
    // Register CharCode[4:3] to constant 2'b10 and wire CurrentState to other bits
    assign RedChannel = {1'b0, RedCurrentState};
	assign GreenChannel = {1'b0, GreenCurrentState};
	assign BlueChannel = {1'b0, BlueCurrentState};
  
    // Clock in new state
    always @(posedge SYSCLK) begin
        if(reset_in)
            RedCurrentState <= ZERO;
			GreenCurrentState <
        else if(CLK_En)
            CurrentState = NextState;
        else
            CurrentState = CurrentState;
    end
    
    // Setup next state logic
    always @(*) begin
        case (CurrentState)
            Seg_A: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = ALL_OFF;
                   else if (MotionCode == REVERSE)
                       NextState = Seg_D;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_B;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_F;
                   else
                       NextState = ALL_OFF;
            Seg_B: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = Seg_A;
                   else if (MotionCode == REVERSE)
                       NextState = Seg_D;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_C;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_A;
                   else
                       NextState = ALL_OFF;
            Seg_C: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = Seg_A;
                   else if (MotionCode == REVERSE)
                       NextState = Seg_D;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_D;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_B;
                   else
                       NextState = ALL_OFF;
            Seg_D: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = Seg_A;
                   else if (MotionCode == REVERSE)
                       NextState = ALL_OFF;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_E;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_C;
                   else
                       NextState = ALL_OFF;
            Seg_E: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = Seg_A;
                   else if (MotionCode == REVERSE)
                       NextState = Seg_D;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_F;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_D;
                   else
                       NextState = ALL_OFF;
            Seg_F: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = Seg_A;
                   else if (MotionCode == REVERSE)
                       NextState = Seg_D;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_A;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_E;
                   else
                       NextState = ALL_OFF;
            Seg_G: if (MotionCode == STOP)
                       NextState = Seg_G;
                   else if (MotionCode == FORWARD)
                       NextState = Seg_A;
                   else if (MotionCode == REVERSE)
                       NextState = Seg_D;
                   else if (MotionCode == RIGHT1X || MotionCode == RIGHT2X)
                       NextState = Seg_A;
                   else if (MotionCode == LEFT1X || MotionCode == LEFT2X)
                       NextState = Seg_A;
                   else
                       NextState = ALL_OFF;
            ALL_OFF: if (MotionCode == STOP)
                         NextState = Seg_G;
                     else if (MotionCode == FORWARD)
                         NextState = Seg_A;
                     else if (MotionCode == REVERSE)
                         NextState = Seg_D;
                     else
                         NextState = ALL_OFF;
            default: NextState = ALL_OFF;
        endcase
    end
endmodule
