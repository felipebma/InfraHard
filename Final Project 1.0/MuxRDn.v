module MuxRDn(e0, e1,Sinal, Out);

input wire [31:0] e0; // entradas
input wire [15:0] e1;
input wire Sinal; // controle
output reg [4:0] Out; // sa�da

always @(*) begin
	case(Sinal)
		1'b0: Out <= e0[4:0];
		1'b1: Out <= e1[10:6];
	endcase
end
endmodule 