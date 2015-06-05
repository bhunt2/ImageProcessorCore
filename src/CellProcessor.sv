// CellProcessor.v - The top level of the cell processor
//
// Description:
// ------------
// Top level module for a single cell processor
//
//
// Cell Processor Ports
//  Interface:
//    cell_t CellA, CellB
//    userInput_t
//	  
//  btnCpuReset 	- CPU RESET Button - System reset.  Asserted low by Nexys 4 board
//  sw[3:0] 		- Used to switch between cellA input colors.
//  sw[7:4] 		- Used to switch between cellB input colors.
//  sw[15:12] 		- Used to switch between possible opcodes.
//  led[15:0] 		- Light up to show that switch is registered.
//  7-segment[2:0] 	- Outputs the values of each of the channels in the resulting image.
//
// External port names match pin names in the nexys4fpga.xdc constraints file
///////////////////////////////////////////////////////////////////////////
module CellProcessor(
	cellProcessor_int.cellPorts ports
);
    import CellProcessingPkg::*;
    
    pixel_t RESULT;
    assign ports.processedPixel = RESULT;
	
	cell_t cellBlockA;
	cell_t cellBlockB;
	
	always_comb begin
		cellBlockA.singleCell = ports.cellA;
		cellBlockB.singleCell = ports.cellB;
	end
	
    // Always block for operating on the current input values
    always_comb begin
        if(ports.rst)
            RESULT = ~0;
        else begin
            case (ports.opcode)
                ADD :   RESULT  = add(cellBlockA, cellBlockB);
                ADDI:   RESULT  = addi(cellBlockA, ports.userInputA);
                SUB :   RESULT  = sub(cellBlockA, cellBlockB);
                SUBI:   RESULT  = subi(cellBlockA, ports.userInputA);
                default: RESULT = cellBlockA.pixelMatrix[centerPixel];
            endcase
        end
    end

endmodule