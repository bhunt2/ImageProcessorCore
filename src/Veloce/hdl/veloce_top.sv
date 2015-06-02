
module veloce_top;
	reg clk, rst;
	reg [CellProcessingPkg::cellDepth - 1:0]	cellA;
   reg [CellProcessingPkg::cellDepth - 1:0]	cellB;
	reg CellProcessingPkg::userInput_t userInputA;
	reg CellProcessingPkg::opcodes_t opcode;
	reg CellProcessingPkg::pixel_t processedPixel;
	integer done;

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
	import "DPI-C" task send_3x3_pixels(output [CellProcessingPkg::cellDepth - 1:0] cellA,
													output [CellProcessingPkg::cellDepth - 1:0] cellB);
	import "DPI-C" task recieve_result_pixel(input CellProcessingPkg::pixel_t processedPixel, output bit [31:0] done);
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
			send_3x3_pixels(cellA, cellB);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			recieve_result_pixel(processedPixel, done);

			if(done)
			begin
				shutdown_hvl();
				$finish();
			end
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