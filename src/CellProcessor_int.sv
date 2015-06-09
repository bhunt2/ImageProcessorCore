// CellProcessor_int.sv - Interface for working with the cell processor.
//
// Author: 			Benjamin Huntsman
// Date Created: 	30 April 2015
// 
// Description:
// ------------
//  This defines the interface for working with the cell processor. Modports
//  for the cell processor and connecting modules are provided and
//  recommended for use.
//
//
// Cell Processor Ports
//  Interface:
//      logic    clk, rst
//    	cell_t   CellA, CellB
//    	pixel_t  userInput
//	  	opcode_t opcode
//		pixel_t  processedPixel
//	  
///////////////////////////////////////////////////////////////////////////

import CellProcessingPkg::cellDepth;
import CellProcessingPkg::opCodeWidth;
import CellProcessingPkg::pixel_t;

// Interface
interface cellProcessor_int(input logic clk, rst);
    logic [cellDepth - 1:0] 	cellA;
    logic [cellDepth - 1:0] 	cellB;
    pixel_t  					userInput;
    logic [opCodeWidth - 1:0]	opcode;
    pixel_t						processedPixel;
  
    modport cellPorts ( input  clk,
                        input  rst,
                        input  cellA,
                        input  cellB,
                        input  userInput,
                        input  opcode,
                        output processedPixel
                      );
                      
    modport imagePorts ( output cellA,
                         output cellB,
                         output userInput,
                         output opcode
                       );
                       
endinterface