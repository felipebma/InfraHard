module Mux2(A, B, Sinal, Out);

input wire [31:0] A, B; // entradas
input wire Sinal; // controle
output reg [31:0] Out; // sa�da

always @(*) begin
	case(Sinal)
		1'b0: Out = A;
		1'b1: Out = B;
	endcase
end
endmodule 