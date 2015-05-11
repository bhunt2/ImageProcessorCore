/************************************************/
/* Cell Processor                               */
/*                                              */
/************************************************/

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