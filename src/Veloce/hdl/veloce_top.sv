
module veloce_top;

	import CellProcessingPkg::*;
	reg clk, rst;
	bit [cellDepth - 1:0]	cellA;
   bit [cellDepth - 1:0]	cellB;
	userInput_t userInputA;
	opcodes_t opcode = ADD;
	pixel_t processedPixel;
	integer done, counter, shift_amount;

	bit [31:0] temp_pixelA;
	bit [31:0] temp_pixelB;

	//clock generator
	//tbx clkgen
	initial
	begin
		clk = 0;
		forever
		begin
			#10 clk = ~clk;
		end
	end

	//reset generator
	//tbx clkgen
	initial
	begin
		rst = 1;
		#20 rst = 0;
	end

	//DPI import functions
	import "DPI-C" task load_images();
	import "DPI-C" task load_3x3_pixels();
	import "DPI-C" task send_pixel_to_hdl(output bit [31:0] pixel_outA,
													  output bit [31:0] pixel_outB);
	import "DPI-C" task receive_result_pixel(input pixel_t processedPixel, output bit [31:0] done);
	import "DPI-C" task shutdown_hvl();
	
	cellProcessor_int cell_int(clk, rst);
	
	initial
	begin
		@(posedge clk);
		while(rst) @(posedge clk);
		load_images();
	end

	//Process the cells
	always @(posedge clk)
	begin
		if(!rst)
		begin
			load_3x3_pixels();
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);

			//Reset every iteration
			shift_amount = 0;
			cellA = 0;
			cellB = 0;

			//Unpack the 3x3 cells into the 216 bit data vectors
			for(counter = 0; counter < 9; counter++)
			begin
				send_pixel_to_hdl(temp_pixelA, temp_pixelB);
				cellA |= (temp_pixelA & 32'h00FFFFFF) << shift_amount; 
				cellB |= (temp_pixelB & 32'h00FFFFFF) << shift_amount; 
				shift_amount += 24;
			end
			
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			receive_result_pixel(processedPixel, done);

			if(done)
			begin
				shutdown_hvl();
				$finish();
			end
		end
	end
	
	assign cell_int.cellA		= cellA;
	assign cell_int.cellB		= cellB;
	assign cell_int.userInputA  = userInputA;
	assign cell_int.opcode		= opcode;
	assign processedPixel 		= cell_int.processedPixel;

	// Instantiate the cell processor
	CellProcessor IPCore(.ports(cell_int.cellPorts));
	
endmodule
