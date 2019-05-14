module Mux3(A, B, C, Sinal, Out);

input wire [31:0] A, B, C; // entradas
input wire [1:0] Sinal; // controle
output reg [31:0] Out; // saída

always @(*) begin
	case(Sinal)
		2'b00: Out = A;
		2'b01: Out = B;
		2'b10: Out = C;
	endcase
end
endmodule 