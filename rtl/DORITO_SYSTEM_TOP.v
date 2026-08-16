 21 timeunit 1ns;
 22 timeprecision 1ps;
 23
 24 import DORITO_PKG::*;
 25
 26 module DORITO_SYSTEM_TOP
 27 (       input logic SYS_CLOCK, FSM_ARESET,
 28 output logic MEM_ARESET, MEM_WRITE,
 29 output logic signed [ADDR_SIZE-1 : 0] MEM_ADDRESS,PC_OUT,
 30         output logic [BUS_SIZE-1 : 0] MEM_DATA_IN,
 31         output logic [BUS_SIZE-1 : 0] MEM_DATA_OUT,
 32         output logic [BUS_SIZE-1 : 0] ACCUM_REG
 33 );
 34
 35 //module DORITO_SYSTEM_TOP (.*);
 36
 37
 38 //var logic SYS_CLOCK, FSM_ARESET, MEM_ARESET;
 39
 40 //var logic MEM_ARESET,MEM_WRITE;
 41 logic EN;
 42
 43 //var logic [BUS_SIZE-1 : 0] MEM_DATA_OUT, /*MEM_ADDRESS,*/ MEM_DATA_IN;
 44 //var logic signed [ADDR_SIZE-1 : 0] MEM_ADDRESS; //MAKE ADDRESS 5 BIT (CAN POINT TO 32 LOCATIONS) FOR EASIER VERIFICATI    ON.
 45 DORITO_PROCESSOR_TOP PROC_TOP (.*);
 46 DORITO_MEMORY MEM (.*);
 
 48 endmodule : DORITO_SYSTEM_TOP  
