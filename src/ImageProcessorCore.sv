// nexys4fpga.v - Top level module for Nexys4 as used testing image processor cell
//
// Description:
// ------------
// Top level module for testing a single cell processor for an image processor
// on the Nexys4 FPGA Board (Xilinx XC7A100T-CSG324)
//
// Instantiates:
//	CellProcessor
//  sevensegment
//  debounce
//
// Board Inputs:
//  btnCpuReset 	- CPU RESET Button - System reset.  Asserted low by Nexys 4 board
//  sw[3:0] 		- Used to switch between cellA input colors.
//  sw[7:4] 		- Used to switch between cellB input colors.
//  sw[15:11] 		- Used to switch between possible opcodes.
//  led[15:0] 		- Light up to show that switch is registered.
//  7-segment[2:0] 	- Outputs the values of each of the channels in the resulting image.
//
// External port names match pin names in the nexys4fpga.xdc constraints file
///////////////////////////////////////////////////////////////////////////

module Nexys4fpga (
	input 				clk,                 	// 100MHz clock from on-board oscillator
	input				btnL, btnR,				// pushbutton inputs - left (db_btns[4])and right (db_btns[2])
	input				btnU, btnD,				// pushbutton inputs - up (db_btns[3]) and down (db_btns[1])
	input				btnC,					// pushbutton inputs - center button -> db_btns[5]
	input				btnCpuReset,			// red pushbutton input -> db_btns[0]
	input	[15:0]		sw,						// switch inputs	
	output	[15:0]		led,  					// LED outputs	
	output 	[6:0]		seg,					// Seven segment display cathode pins
	output              dp,						// Seven segment decimal point
	output	[7:0]		an,						// Seven segment display anode pins		
	output	[7:0]		JA						// JA Header
); 

	// parameter
	parameter SIMULATE = 0;
	parameter RESET_POLARITY_LOW = 1;

	// internal variables
	wire 	[15:0]		db_sw;					// debounced switches
	wire 	[5:0]		db_btns;				// debounced buttons
	
	wire 	[4:0]		dig7, dig6,				// display digits
						dig5, dig4,
						dig3, dig2, 
						dig1, dig0;
	wire 	[7:0]		decpts;					// decimal points
	
	wire    [23:0]		result;					// Result from cell
	
	wire 	[63:0]		digits_out;				// ASCII digits (Only for Simulation)
	wire    [7:0]       segs_int;               // seven segment module the segments and the decimal point

/******************************************************************/
/* Setup for clocking and reset				                      */
/******************************************************************/		
	wire				sysclk;					// 100MHz clock from on-board oscillator	
	wire				sysreset;				// system reset signal - asserted high to force reset
		
	assign	sysclk 		= clk;
	assign 	sysreset 	= db_btns[0]; // btnCpuReset is asserted low

	
/******************************************************************/
/* Setup for 7-segment display		                              */
/******************************************************************/		
	// set up the display and LEDs
	assign	dig7 = {5'b11111};					// blank
	assign	dig6 = {5'b11111};
	assign	dig5 = {5'b11111};
	assign	dig4 = {5'b11111};
	
	assign	dig3 = MIDisplay;
	assign	dig2 = Hundreds;
	assign 	dig1 = Tens;
	assign	dig0 = Ones;
	assign	decpts = 8'b00000100;			// d2 is on
	assign  dp = segs_int[7];
	assign  seg = segs_int[6:0];

/******************************************************************/
/* Setup for leds and switches display                            */
/******************************************************************/		
	assign	led = db_sw;			    // leds show the debounced switches

	

	
	assign	JA = {sysclk, sysreset, 6'b000000};
	
	//instantiate the debounce module
	debounce
	#(
		.RESET_POLARITY_LOW(RESET_POLARITY_LOW),
		.SIMULATE(SIMULATE)
	)  	DB
	(
		.clk(sysclk),	
		.pbtn_in({btnC,btnL,btnU,btnR,btnD,btnCpuReset}),
		.switch_in(sw),
		.pbtn_db(db_btns),
		.swtch_db(db_sw)
	);	
		
	// instantiate the 7-segment, 8-digit display
	sevensegment
	#(
		.RESET_POLARITY_LOW(RESET_POLARITY_LOW),
		.SIMULATE(SIMULATE)
	) SSB
	(
		// inputs for control signals
		.d0({1'b0, result[3:0]}),
		.d1({1'b0, result[7:4]}),
 		.d2(5'b0),
		.d3({1'b0, result[11:8]}),
		.d4({1'b0, result[15:12]}),
		.d5(5'b0),
		.d6({1'b0, result[19:16]}),
		.d7({1'b0, result[23:20]}),
		.dp(decpts),
		
		// outputs to seven segment display
		.seg(segs_int),			
		.an(an),
		
		// clock and reset signals (100 MHz clock, active high reset)
		.clk(sysclk),
		.reset(sysreset),
		
		// ouput for simulation only
		.digits_out(digits_out)
	);

	ImageProcessor IPCore( .clk(sysclk), .rst(sysreset), .IW(IW), .result(result));
);
	
	
endmodule