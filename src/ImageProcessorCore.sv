// nexys4fpga.v - Top level module for Nexys4 as used in the ECE 540 Project 2
//
// 
// Created By:		Jeff Nguyen
// Last Modified:	10-27-2014 
//
// 
//
// Description:
// ------------
// Modified from the handout for final project Short circuit. The flowing modules are instantitated 
// for final projects
//   kcpsm6.v
//   Final_project PicoBlaze prom file 
//   nexys4_bot_if.v       //interface between sensor interfaces/motor drive and picoblaze
//   blackline_sensors.v   //blackline follower sensor interface
//   blk_sensor.v          //FindRanger sensor interfaces
//   motor_driver.v        //motor drive
//   clk_en.v              //clock divider.
//   Xbee_uart.v            //serial interface with Xbee module
//
//   The pushbuttons will be replaced by command from android app.
//  (Use the pushbuttons to control the Rojobot wheels)
//	btnl			Left wheel forward
//	btnu			Left wheel reverse
//	btnr			Right wheel forward
//	btnd			Right wheel reverse
//  btnc			in this design
//	btnCpuReset		CPU RESET Button - System reset.  Asserted low by Nexys 4 board
//
//	sw[15:0]		Not used in this design
//
// External port names match pin names in the nexys4fpga.xdc constraints file
///////////////////////////////////////////////////////////////////////////

module Nexys4fpga (
	input 				clk,                 	// 100MHz clock from on-board oscillator
	input               bLine_R,                //Right blackLine follower sensor reading
	input               bLine_C,                //Center sensor follower
	input               bLine_L,                //Left sensor follower
	input               FRanger_L,              //Left Ranger Finder 
	input               FRanger_R,              //Right Ranger Finder.
	input               uart_in,                //Xbee interface in
	input               nCTS,                   //Xbee asserts when fifo full - not implemented.
	input               btnCpuReset,            //reset button on board but it not going to debounce
	output              Rmotor_dir,             //direct and speed control for motor
	output              Rmotor_speed,           // 1 - forward/ 0 - reverse
	output              Lmotor_dir,             // speed controls by pulse width
	output              Lmotor_speed,
	output              nRTS,                   //request Xbee read command - not implemented
	output              uart_out,               //uart_out cmd not implemented
	input	    		switch,						// switch inputs
	output	[15:0]		led,  					// LED outputs	
	output 	[6:0]		seg,					// Seven segment display cathode pins
	output              dp,
	output	[7:0]		an					// Seven segment display anode pins
); 

	// parameter
	parameter SIMULATE = 0;
	parameter SLEEP    = 1'b0;
	// reset - asserted high
   	parameter  RESET_POLARITY_LOW		= 1'b1;

	// internal variables
	wire 	[15:0]		db_sw;					// debounced switches
	wire 	[5:0]		db_btns;				// debounced buttons
	
	wire				sysclk;					// 100MHz clock from on-board oscillator	
	wire				sysreset;				// system reset signal - asserted high to force reset
	
	wire 	[4:0]		dig7, dig6,
						dig5, dig4,
						dig3, dig2, 
						dig1, dig0;				// display digits
	wire 	[7:0]		decpts;					// decimal points
	wire 	[15:0]		chase_segs;				// chase segments from Rojobot (debug)
	
	wire    [7:0]       segs_int;              // sevensegment module the segments and the decimal point

/******************************************************************/
/* CHANGE THIS SECTION FOR YOUR LAB 1                             */
/******************************************************************/		
	
	wire 	[63:0]		digits_out;				// ASCII digits (Only for Simulation)
	wire reset_in, switch_mode;
	reg  android_mode = 1'b0;



/******************************************************************/
/* THIS SECTION SHOULDN'T HAVE TO CHANGE FOR LAB 1                */
/******************************************************************/			
	// global assigns
	assign	sysclk = clk;
	
	
	assign dp = segs_int[7];
	assign seg = segs_int[6:0];
	
	assign JA = {sysclk, sysreset, 6'b000000};
	
	assign reset_in    = RESET_POLARITY_LOW ? ~btnCpuReset : btnCpuReset;
	
	
	// instantiate the 7-segment, 8-digit display
	sevensegment
	#(
		.RESET_POLARITY_LOW(1),
		.SIMULATE(SIMULATE)
	) SSB
	(
		// inputs for control signals
		.d0(dig0),
		.d1(dig1),
 		.d2(dig2),
		.d3(dig3),
		.d4(dig4),
		.d5(dig5),
		.d6(dig6),
		.d7(dig7),
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
	
/******************************************************************/
/* DEFINE WIRES for nexys4_bot_if                                 */
/******************************************************************/
						
	wire [17:0]        proj2_instruction;          //instruction bus between proj2demo to picoblaze
	wire [11:0]        proj2_address;              //addr bus between proj2 to picoblaze
	wire               bram_enable, kcpsm6_reset;
	wire [7:0]         port_id,out_port,in_port;
	wire               k_write_strobe, write_strobe, read_strobe;
	wire               interrupt, interrup_ack;
	
	wire [7:0]         motctl, pico_motctl;
	wire [7:0]         android_motctl;
	wire [7:0]         loc_x,loc_y;
	wire [7:0]         botinfo, sensors, lmdist, rmdist;
	wire               upd_sysregs;
	
	//Clock divider
	wire               clk20us_en, clk128khz_en, clk147us_en;
	wire     [7:0]     uart_cmd_in;
	wire               clk50ms_en;
	wire               int50ms_en;
	wire               sensor_L, sensor_C, sensor_R, apprx_L, apprx_R;
	
	

/******************************************************************/
/* INSTANTIATE THE PICOBLAZE                                      */
/******************************************************************/		
kcpsm6 #(
	.interrupt_vector	(12'h3FF),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h00))
  processor (
	.address 		(proj2_address),
	.instruction 	(proj2_instruction),
	.bram_enable 	(bram_enable),
	.port_id 		(port_id),
	.write_strobe 	(write_strobe),
	.k_write_strobe (k_write_strobe),
	.out_port 		(out_port),
	.read_strobe 	(read_strobe),
	.in_port 		(in_port),
	.interrupt 		(interrupt),
	.interrupt_ack 	(interrupt_ack),
	.reset 		    (reset_in || kcpsm6_reset),
	.sleep		    (SLEEP),
	.clk 			(sysclk)
	);

/******************************************************************/
/* INSTANTIATE THE finalProj                                      */
/******************************************************************/							
finalProj #(
	.C_FAMILY		   ("7S"),   	 //Family '7S' 
	.C_RAM_SIZE_KWORDS	(2),  	     //Program size '1', '2' or '4'
	.C_JTAG_LOADER_ENABLE	(0))  	 //Include JTAG Loader when set to '1' 
  program_rom (    				     //Name to match your PSM file
 	.rdl 			(kcpsm6_reset),
	.enable 		(bram_enable),
	.address 		(proj2_address),
	.instruction 	(proj2_instruction),
	.clk 			(sysclk)
	);
	
/******************************************************************/
/* INSTANTIATE THE Nexys4_bot_if.v                                */
/******************************************************************/						
Nexys4fpga_bot_if bot_intf(
	.clk           (sysclk),             	// 100MHz clock from on-board oscillator
	.reset         (reset_in),
	.port_id       (port_id),                
	.out_port      (out_port),
	.k_write_strobe(k_write_strobe),
	.write_strobe  (write_strobe),
	.read_strobe   (read_strobe),
	.interrupt_ack (interrupt_ack),
	.interrupt     (interrupt),
	.in_port       (in_port),
    .botinfo       (botinfo),
    .sensors       (sensors),
    .lmdist        (lmdist),
    .rmdist        (rmdist),
    .upd_sysregs   (clk50ms_en),
	.left_fwd      (left_fwd),
	.left_rev      (left_rev),
	.right_fwd     (right_fwd),
	.right_rev     (right_rev),
    .motctl        (pico_motctl),
    .seg_out7      (dig7),
    .seg_out6      (dig6),
    .seg_out5      (dig5),
    .seg_out4      (dig4),
    .seg_out3      (dig3),
    .seg_out2      (dig2),
    .seg_out1      (dig1),
    .seg_out0      (dig0),
    .dp            (decpts),
    .led           (led[7:0])	
); 

/******************************************************************/
/* INSTANTIATE CLOCK DIVIDER                                      */
/******************************************************************/		

clk_en  CLK_DIV(
	.clk(sysclk),                 	 //  100MHz clock from on-board oscillator
	.reset(reset_in),
	.clk147us_en(clk147us_en),       // FindRanger pwm clock
	.clk128khz_en(clk128khz_en),     // pwm clock for motor driver
	.clk50ms_en (clk50ms_en),
	.clk20us_en(clk20us_en)          // blackline sensors clock sample
); 

/******************************************************************/
/* INSTANTIATE BLACKLINE FOLLOWER SENSOR                          */
/******************************************************************/		

blackline_sensors BL_FOLLOWER(
	.clk (sysclk),                 	// 100MHz clock from on-board oscillator
	.reset(reset_in),
	.clk20us_en(clk20us_en),         // 6.8 Khz for 147 us period
	//input               resume,    // ack from PicoBalze to restart reading.
	.bLine_L_in(bLine_L),            // BlackLine follower sensor from Left
	.bLine_C_in(bLine_C),
	.bLine_R_in(bLine_R),
	.bLine_L_output (sensor_L), //(sensors[2]),
	.bLine_C_output (sensor_C), //(sensors[1]),
	.bLine_R_output (sensor_R)  //(sensors[0])
); 

/******************************************************************/
/* INSTANTIATE FIND_RANGER SENSORS.V                                    */
/******************************************************************/	
blk_sensors FIND_RANGER(
	.clk(sysclk),                 	            // 100MHz clock from on-board oscillator
	.reset(reset_in),
	.pwm_en(clk147us_en),                       // 147 us enable
	.blk_sensor_r(FRanger_R),                   // right sensor reading
	.blk_sensor_l(FRanger_L),                   // left sensor reading
	.m50ms_en(int50ms_en),                        // 50us signal - tied up FindRanger sensor
	.r_sensor_pwm_out(rmdist),                  //right motor distance
	.l_sensor_pwm_out(lmdist),                  //left motor distance
	.r_sensor_detect(apprx_R), //(sensors[3]),
	.l_sensor_detect(apprx_L)  //(sensors[4])
); 


assign sensors[7:0] = {3'b000,apprx_L, apprx_R, sensor_L, sensor_C, sensor_R};

/******************************************************************/
/* INSTANTIATE MOTOR_DRIVER.V                                     */
/******************************************************************/	
motor_driver_ctrl MOTOR_DRIVER(
	.clk(sysclk),                 	// 100MHz clock from on-board oscillator
	.reset(reset_in),
	.clk_pwm(clk128khz_en),         //128khz clock for pulsewidth modulation
	.motor_ctrl_in(motctl),         //from Xbee Module
	.motor_R_direction(Rmotor_dir),
    .motor_R_speed(Rmotor_speed),
    .motor_L_direction(Lmotor_dir),
    .motor_L_speed(Lmotor_speed)
); 

/******************************************************************/
/* INSTANTIATE XBEE_UART.V                                        */
/******************************************************************/	
uart_interface XBEE_UART(
	.clk (sysclk),                 	// 100MHz clock from on-board oscillator
	.reset(reset_in),
	.uart_in(uart_in),              //serial data from xbee
	.nCTS (nCTS),                   //asserts when fifo full
	.uart_out(uart_out),            //serial data out from xbee
	.nRTS(nRTS),                    //request to send flow.
	.cmd_out (uart_cmd_in)
); 

//switch motor command between picoBlaze and Android wifi control
assign motctl = (android_mode)? android_motctl: pico_motctl;
assign led[15:8] = (android_mode)? android_motctl: pico_motctl;

assign android_motctl = {2'b00,uart_cmd_in[4],uart_cmd_in[5], 2'b00, uart_cmd_in[6], uart_cmd_in[7]};
	       

//set to the android mode
always @(posedge sysclk)
begin
    if (reset_in)
		android_mode <= 1'b0;
	else 	
		if (switch) 
			android_mode <= 1'b1;
		else
			android_mode <= 1'b0;

end 

endmodule