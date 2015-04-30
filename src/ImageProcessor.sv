/************************************************/
/* Image Processor                              */
/*                                              */
/************************************************/

import ImageProcessingPkg::*;

module ImageProcessor(
	input clk,
	input instruction_t IW,
	output pixelMatrix_t result
);

    // Always block for operating on the current input values
    always_comb begin
        case (IW.opcode)
            ADD :   result = add(IW.cellA, IW.cellB);
        endcase
    end

endmodule