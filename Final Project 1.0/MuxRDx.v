module MuxRDx(e0, e1,Sinal, Out);

input wire [31:0] e0, e1; // entradas
input wire Sinal; // controle
output reg [31:0] Out; // saída

always @(*) begin
	case(Sinal)
		1'b0: Out <= e0;
		1'b1: Out <= e1;
	endcase
end
endmodule 