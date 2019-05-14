module MuxB(A,C,D,E, Sinal, Out);

input wire [32:0] A, C, D, E; // entradas
input wire [2:0] Sinal; // controle
output reg [32:0] Out; // saída

always @(*) begin
	case(Sinal)
		3'b000: Out = A;
		3'b001: Out = 32'd4;
		3'b010: Out = C;
		3'b011: Out = D;
		3'b100: Out = E;
	endcase
end
endmodule 