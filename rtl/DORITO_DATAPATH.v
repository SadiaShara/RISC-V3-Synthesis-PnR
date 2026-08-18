  timeunit 1ns;
  timeprecision 1ps;
  import DORITO_PKG::*;

  module DORITO_DATAPATH
  (input logic SYS_CLOCK,
  input  logic [BUS_SIZE-1 : 0] MEM_DATA_OUT,
  input  logic SCLR_PC, INC_PC, LOAD_PC,
  input  logic LOAD_IR,
  input  logic [REG_ADDR_SIZE-1 : 0] SEL_SOURCE_REG1, SEL_SOURCE_REG2, SEL_DEST_REG,
  input  logic REG_FILE_ARESET,LOAD_DEST_REG,
  input  logic LOAD_ACCUM_REG,
  input  logic IMM_OFFSET_SELECTOR,
  input  logic [MNEMONIC_SIZE-1 : 0] ALU_CONTROL,
  input  logic SEL_SOURCE1, SEL_SOURCE2, SEL_DATA, SEL_ADDR,
  input  logic LOAD_ADDR_REG,
  input  logic EN,        //ADDED
   
  output  logic [BUS_SIZE-1 : 0] IR_OUT,
  output  logic [BUS_SIZE-1 : 0] ACCUM_REG,
  output  logic CARRYOUT, U_OVF, S_OVF, ALU_OUT_ZERO, ALU_OUT_POS, ALU_OUT_NEG,
  output  logic signed [ADDR_SIZE-1 : 0] MEM_ADDRESS, PC_OUT,
  //MAKE ADDRESS 5 BIT (CAN POINT TO 32 LOCATIONS) FOR EASIER VERIFICATION.
  output  logic [BUS_SIZE-1 : 0] /*MEM_ADDRESS,*/ MEM_DATA_IN
  //output  wire [BUS_SIZE-1 : 0] /*MEM_ADDRESS,*/ MEM_DATA_IN //CHANGE
  );
 
  
  logic [BUS_SIZE-1 : 0] INT_DATA_BUS, SOURCE_REG1, SOURCE_REG2, IMM_OFFSET_DATA,
  logic signed [ADDR_SIZE-1 : 0] ADDR_REG_OUT; //CHANGE
 
  logic [BUS_SIZE-1 : 0] R_FILE [REGISTER_NO-1 : 0];
  always_ff @ (posedge SYS_CLOCK)
  begin : PC
  if (LOAD_PC)
  PC_OUT <= $signed(INT_DATA_BUS[4:0]);/*INT_DATA_BUS[4:0];*/
  //MAKE PC_OUT 5 BIT (CAN POINT TO 32 LOCATIONS) FOR EASIER VERIFICATION.
  else if (SCLR_PC)
  PC_OUT <= '0;
  else if (INC_PC)
  PC_OUT <= PC_OUT + 1'b1;
  end : PC
 
  always_ff @ (posedge SYS_CLOCK)
  begin : IR
  if (LOAD_IR)
  IR_OUT <= INT_DATA_BUS;
  end : IR
  always_ff @ (posedge SYS_CLOCK)
  begin : REG_FILE
  if (REG_FILE_ARESET)
  begin
  R_FILE <= '{default : '0};
  end
  else if (LOAD_DEST_REG)
  R_FILE [SEL_DEST_REG] <= INT_DATA_BUS;
  end : REG_FILE
 
 assign SOURCE_REG1 = R_FILE [SEL_SOURCE_REG1];
 assign SOURCE_REG2 = R_FILE [SEL_SOURCE_REG2];

 always_ff @ (posedge SYS_CLOCK)
 begin : ACC_REG
  if (LOAD_ACCUM_REG)
         ACCUM_REG <= ALU_OUT;
 end : ACC_REG
 
 always_comb
  begin : IMMEDIATE_DATA_OFFSET_CONTROLLER
 if (IMM_OFFSET_SELECTOR)
 IMM_OFFSET_DATA = {'0,IR_OUT[11:0]};
 else
  
end : IMMEDIATE_DATA_OFFSET_CONTROLLER

always_ff @ (posedge SYS_CLOCK)
begin : ADDRESS_REG
if (REG_FILE_ARESET)
ADDR_REG_OUT <= '0;
else
if (LOAD_ADDR_REG)
ADDR_REG_OUT <= ALU_OUT[ADDR_SIZE-1:0]; /*ALU_OUT;*/
end : ADDRESS_REG

always_comb
begin : ALU
CARRYOUT = '0; U_OVF = '0; S_OVF = '0;
ALU_OUT_W_CARRY = '0;
case (ALU_CONTROL)

ADD: begin
ALU_OUT_W_CARRY = $signed(ALU_IN1) + $signed(ALU_IN2);
ALU_OUT = ALU_OUT_W_CARRY[BUS_SIZE-1 : 0];
CARRYOUT = ALU_OUT_W_CARRY[BUS_SIZE];
U_OVF = ALU_OUT_W_CARRY[BUS_SIZE];
S_OVF = ( ~(ALU_IN1[BUS_SIZE-1] ^ ALU_IN2[BUS_SIZE-1])
&& (ALU_OUT[BUS_SIZE-1] ^ ALU_IN1[BUS_SIZE-1]) );
end
SUB : begin
ALU_OUT_W_CARRY = ALU_IN1 - ALU_IN2;
ALU_OUT = ALU_OUT_W_CARRY[BUS_SIZE-1 : 0];
CARRYOUT = ALU_OUT_W_CARRY[BUS_SIZE];
 U_OVF = ~ALU_OUT_W_CARRY[BUS_SIZE];
 S_OVF = ( (ALU_IN1[BUS_SIZE-1] ^ ALU_IN2[BUS_SIZE-1])
 && ~(ALU_OUT[BUS_SIZE-1] ^ ALU_IN2[BUS_SIZE-1]) );
 end
 INC_IN1 : begin
 ALU_OUT_W_CARRY = ALU_IN1 + 1'b1;
 ALU_OUT = ALU_OUT_W_CARRY[BUS_SIZE-1 : 0];
 CARRYOUT = ALU_OUT_W_CARRY[BUS_SIZE];
 U_OVF = ALU_OUT_W_CARRY[BUS_SIZE];
 end
 
INC_IN2 : begin
ALU_OUT_W_CARRY = ALU_IN2 + 1'b1;
ALU_OUT = ALU_OUT_W_CARRY[BUS_SIZE-1 : 0];
CARRYOUT = ALU_OUT_W_CARRY[BUS_SIZE];
U_OVF = ALU_OUT_W_CARRY[BUS_SIZE];

end
PASS_0          : ALU_OUT = '0;
PASS_IN2        : ALU_OUT = ALU_IN2;
PASS_LOW16_IN2 : ALU_OUT = ALU_IN2[(BUS_SIZE/2)-1 :0];
PASS_HIGH16_IN2 : ALU_OUT = ALU_IN2[BUS_SIZE-1 : (BUS_SIZE/2)];
AND : ALU_OUT = ALU_IN1 & ALU_IN2;
OR  : ALU_OUT = ALU_IN1 | ALU_IN2;
XOR : ALU_OUT = ALU_IN1 ^ ALU_IN2;
NAND  : ALU_OUT = ~(ALU_IN1 & ALU_IN2);
NOR  : ALU_OUT = ~(ALU_IN1 | ALU_IN2);
XNOR : ALU_OUT = ~(ALU_IN1 ^ ALU_IN2);
NOT_IN2 : ALU_OUT = ~ ALU_IN2;
L_SHIFT_IN2 : ALU_OUT = ALU_IN2 << 1;    
  R_SHIFT_IN2 : ALU_OUT = ALU_IN2 >> 1;
S_L_SHIFT_IN2 : ALU_OUT = ALU_IN2 <<< 1;
S_R_SHIFT_IN2  : ALU_OUT = ALU_IN2 >>> 1;
L_ROTATE_IN2 : ALU_OUT = {ALU_IN2[BUS_SIZE-2 : 0], ALU_IN2[BUS_SIZE-1]};
R_ROTATE_IN2    : ALU_OUT = {ALU_IN2[0],ALU_IN2[BUS_SIZE-1 : 1]};

default : ALU_OUT = 'x;
endcase
end : ALU

assign MEM_DATA_IN = ALU_OUT;
assign ALU_OUT_ZERO = ALU_OUT == '0 ? '1 : '0;
assign ALU_OUT_POS = !ALU_OUT[BUS_SIZE-1] ? '1 : '0;
assign ALU_OUT_NEG = ALU_OUT[BUS_SIZE-1] ? '1 : '0;
   
always_comb
begin : MUX_DATA

case (SEL_DATA)
1'b0 : INT_DATA_BUS = MEM_DATA_OUT;
1'b1 : INT_DATA_BUS = ALU_OUT;
default : INT_DATA_BUS = 'x;
endcase 
end : MUX_DATA

always_comb
begin : MUX_SOURCE1
case (SEL_SOURCE1)
1'b0 : ALU_IN1 = {{27{PC_OUT[4]}},PC_OUT};
1'b1 : ALU_IN1 = SOURCE_REG1;
default : ALU_IN1 = 'x;
endcase
end : MUX_SOURCE1

always_comb
begin : MUX_SOURCE2

case (SEL_SOURCE2)
1'b0 : ALU_IN2 = SOURCE_REG2;
1'b1 : ALU_IN2 = IMM_OFFSET_DATA;
default : ALU_IN2 = 'x;
endcase

end : MUX_SOURCE2

always_comb
begin : MUX_ADDR

case (SEL_ADDR)
1'b0 : MEM_ADDRESS = PC_OUT;
1'b1 : MEM_ADDRESS = ADDR_REG_OUT;
default : MEM_ADDRESS = 'x;   
endcase

end : MUX_ADDR

235 endmodule : DORITO_DATAPATH
