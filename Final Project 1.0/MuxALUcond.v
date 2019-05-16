module ALUcond(e00, e01, e10, e11, Sinal, Out);

input wire e00, e01, e10, e11; // entradas
input wire [1:0] Sinal; // controle
output reg Out; // saída

always @(*) begin
	case(Sinal)
		3'b00: Out = e00;
		3'b01: Out = e01;
		3'b10: Out = e10;
		3'b11: Out = e11;
	endcase
end
endmodule 