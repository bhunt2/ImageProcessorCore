/************************************************/
/* Cell Processor                               */
/*                                              */
/************************************************/

module CellProcessor(
	cellProcessor_int.cellPorts ports
);
    import CellProcessingPkg::*;
    
    pixel_t RESULT;
    assign ports.processedCell = RESULT;	
	
    // Always block for operating on the current input values
    always_comb begin
        if(ports.rst)
            RESULT = ~0;
        else begin
            case (ports.opcode)
                ADD :   RESULT  = add(ports.cellA, ports.cellB);
                ADDI:   RESULT  = addi(ports.cellA, ports.userInputA);
                SUB :   RESULT  = sub(ports.cellA, ports.cellB);
                SUBI:   RESULT  = subi(ports.cellA, ports.userInputA);
				AVG:	RESULT	= avg(ports.cellA);
                default: RESULT = ports.cellA.pixelMatrix[centerPixel][centerPixel];
            endcase
        end
    end

endmodule