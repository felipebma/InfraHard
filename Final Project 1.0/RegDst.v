module MUXRegDst(e00, e11, Sinal, Out);

input wire [4:0] e00, e11; // entradas
input wire [1:0] Sinal; // controle
output reg [4:0] Out; // saída

always @(*) begin
	case(Sinal)
		2'b00: Out = e00;
		2'b01: Out = 5'd29;
		2'b10: Out = 5'd31;
		2'b11: Out = e11;
	endcase
end
endmodule 