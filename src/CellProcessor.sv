// CellProcessor.sv - The top level of the cell processor
//
// Author: 			Benjamin Huntsman
// Date Created: 	30 April 2015
// 
// Description:
// ------------
//  Top level module for a single cell processor. Opcode is used to determine
//  what operation to perform on the inputs. A single pixel, the center of the
//  kernel, is returned.
//
// Cell Processor Ports
//  Interface:
//    Inputs -
//      logic    clk, rst
//	  	cell_t   CellA, CellB
//    	pixel_t  userInput
//	  	opcode_t opcode
//    Outputs -
//		pixel_t  processedPixel
//	  
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
                ADDI:   RESULT  = addi(cellBlockA, ports.userInput);
                SUB :   RESULT  = sub(cellBlockA, cellBlockB);
                SUBI:   RESULT  = subi(cellBlockA, ports.userInput);
                default: RESULT = cellBlockA.pixelMatrix[centerPixel];
            endcase
        end
    end

endmodule