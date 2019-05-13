module MUXMDR(e00, e01,e10,Sinal, Out);

input wire [31:0] e00,e01,e10; // entradas
input wire [1:0] Sinal; // controle
output reg [31:0] Out; // saída

always @(*) begin
	case(Sinal)
		32'b00: Out = e00;
		32'b01: Out = e01;
		32'b10: Out = e10;
	endcase
end
endmodule 