/************************************************/
/* Cell Processor                               */
/*                                              */
/************************************************/

import CellProcessingPkg::*;

module CellProcessor(
	input clk,
	input rst,
	input instruction_t IW,
	output pixel_t result
);
	
    // Always block for operating on the current input values
    always_comb begin
        if(rst)
            result = ~0;
        else begin
            case (IW.opcode)
                ADD :   result  = add(IW.cellA, IW.cellB);
                ADDI:   result  = addi(IW.cellA, IW.userInputA);
                SUB :   result  = sub(IW.cellA, IW.cellB);
                SUBI:   result  = subi(IW.cellA, IW.userInputA);
				AVG:	result	= avg(IW.cellA);
                default: result = IW.cellA.pixelMatrix[centerPixel][centerPixel];
            endcase
        end
    end

endmodule