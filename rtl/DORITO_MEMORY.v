 20 timeunit 1ns;
 21 timeprecision 1ps;
 22
 23 import DORITO_PKG::*;
 24
 25 module DORITO_MEMORY
 26 //`include "DORITO_PKG.v"
 27 (//input  var logic signed [4 : 0] MEM_ADDRESS,//CHNAGE
 28 //MAKE ADDRESS 5 BIT (CAN POINT TO 32 LOCATIONS) FOR EASIER VERIFICATION.
 29
 30 input  logic SYS_CLOCK,
 31 input   logic signed [ADDR_SIZE-1 : 0] MEM_ADDRESS, PC_OUT,
 32 //input var logic [BUS_SIZE-1 : 0] /*MEM_ADDRESS,*/ MEM_DATA_IN,
 33 input logic [BUS_SIZE-1 : 0] /*MEM_ADDRESS,*/ MEM_DATA_IN, //CHANGE
 34 input logic MEM_ARESET,MEM_WRITE,
 35 output  logic [BUS_SIZE-1 : 0] MEM_DATA_OUT
 36 );
 37
 38 //module DORITO_MEMORY (.*);
 39 //timeunit 1ns;
 40 //timeprecision 1ps;
 41
 42  logic [BUS_SIZE-1 : 0] MEM_ARRAY [ADDRESS_HEIGHT-1 : 0];       //CHANGE
 43 //MAKE NO. OF MEM_ARRAY ELEMENTS 32 RATHER THAN2^32 FOR EASIER VERIFICATION
 44
 45 //always_latch
 46 always_ff@(negedge SYS_CLOCK, posedge MEM_ARESET) //posedge MEM_WRITE)//posedge MEM_ARESET, posedge MEM_WRITE)
 47 begin
 48
 49         if (MEM_ARESET)  
 50         begin
 51         //                           XX
 52         //0001_____00000_______000_____000_____000_____00____0000_0000_1111
 53         //0001_0000_0000_0000_0000_0000_0000_1111
 54         //RF[0] <-- RF[0] + 15;
 55         MEM_ARRAY[0] <= 32'h1000000F;
 56
 57         //                           XX
 58         //0001_____00000_______001_____001_____000_____00____0000_0000_0100
 59         //0001_0000_0001_0010_0000_0000_0000_0110
 60         //RF[1] <-- RF[1] + 4;
 61         MEM_ARRAY[1] <= 32'h10120004;
 62
 63         //                                                         XXX             XX    XXXX_XXXX_XXXX
 64         //0000_____00101_______010_____000_____000_____00____0000_0000_0000
 65         //0000_0010_1010_0000_0000_0000_0000_0000
 66         //RF[2] <-- RF[1];
 67         MEM_ARRAY[2] <= 32'h02A00000;
 68
 69         //         XXX                XX         XXXX_XXXX_XXXX
 70         //0000_____00100_______011_____000_____000_____00____0000_0000_0000
 71         //0000_0010_0011_0000_0000_0000_0000_0000
 72         //RF[3] <-- 0;
 73         MEM_ARRAY[3] <= 32'h02300000;
 74
 75
 76
 77         //                             XX        XXXX_XXXX_XXXX
 78         //0000_____00001_______010_____010_____001_____00____0000_0000_0000
 79         //0000_0000_1010_0100_0100_0000_0000_0000   
 80         //RF[2] <-- RF[2] - RF[1];
 81         MEM_ARRAY[4] <= 32'h00A44000;
 82
 83         //                 XXX       XX   XXXX_XXXX_XXXX
 84         //0001_____00000_______011_____011_____000_____00____0000_0000_0001
 85         //0001_0000_0011_0110_0000_0000_0000_0001
 86         //RF[3] <-- RF[3] + 1;
 87         MEM_ARRAY[5] <= 32'h10360001;
 88
 89         //                                         XX    XXXX_XXXX_XXXX
 90         //0000_____00001_______100_____010_____001_____00____0000_0000_0010
 91         //0000_0000_1100_0100_0100_0000_0000_0000
 92         //RF[4] <-- RF[2] - RF[1]
 93         MEM_ARRAY[6] <= 32'h00C44000;
 94
 95         //                                 XXX     XXX
 96         //0100_____00000_______000_____000_____100_____01____1111_1111_1100
 97         //0100_0000_0000_0001_0001_1111_1111_1100
 98         //IF RF[4] IS +VE, BRANCH TO PC - 4 (PC <-- PC + (- 4));  //1111_1111_1100 = -4
 99         //CC == 01 (BRANCH IF RC = POSITIVE; HERE EVALUATION REGISTER RC = RF[4]
100         MEM_ARRAY[7] <= 32'h40011FFC;
101
102         //                  XXXXX                                                         XX     XXXX_XXXX_XXXX
103         //0011_____00000_______011_____000_____001_____00____0000_0000_0010
104         //0011_0000_0011_0000_0100_0000_0000_0000
105         //M [ RF[0] + RF[1] ] <-- RF[3]
106         MEM_ARRAY[8] <= 32'h30304000;
107
108         //   XXX           XXX     XXX                   XXXX_XXXX_XXXX
109         //0100_____00000_______000_____000_____000_____11____1111_1111_1000    
110         //0100_0000_0000_0000_0011_1111_1111_1000
111         //IF RF[4] IS +VE, BRANCH TO PC - 9 (PC <-- PC + (- 9));  //1111_1111_0110 = -10
112         //CC == 01 (BRANCH IF RC = POSITIVE; HERE EVALUATION REGISTER RC = RF[4]
113         MEM_ARRAY[9] <= 32'h40003FF6;
114         MEM_ARRAY[10] <= 32'h00000000;
115         MEM_ARRAY[11] <= 32'h00000000;
116         MEM_ARRAY[12] <= 32'h00000000;
117         MEM_ARRAY[13] <= 32'h00000000;
118         MEM_ARRAY[14] <= 32'h00000000;
119         MEM_ARRAY[15] <= 32'h00000000;
120         MEM_ARRAY[16] <= 32'h00000000;
121         MEM_ARRAY[17] <= 32'h00000000;
122         MEM_ARRAY[18] <= 32'h00000000;
123         MEM_ARRAY[19] <= 32'h00000000;
124         MEM_ARRAY[20] <= 32'h00000000;
125         MEM_ARRAY[21] <= 32'h00000000;
126         MEM_ARRAY[22] <= 32'h00000000;
127         MEM_ARRAY[23] <= 32'h00000000;
128         MEM_ARRAY[24] <= 32'h00000000;
129         MEM_ARRAY[25] <= 32'h00000000;
130         MEM_ARRAY[26] <= 32'h00000000;
131         MEM_ARRAY[27] <= 32'h00000000;
132         MEM_ARRAY[28] <= 32'h00000000;
133         MEM_ARRAY[29] <= 32'h00000000;
134         MEM_ARRAY[30] <= 32'h00000000;
135         MEM_ARRAY[31] <= 32'h00000000;
136         end
137
138         else if(MEM_WRITE)
139         begin                         
140         MEM_ARRAY[MEM_ADDRESS] <= MEM_DATA_IN;
141
142         end
143
144
145 end
146
147 assign MEM_DATA_OUT = MEM_ARRAY[MEM_ADDRESS];
148 //assign MEM_DATA_OUT = MEM_ARRAY[PC_OUT];
149
150 endmodule : DORITO_MEMORY
