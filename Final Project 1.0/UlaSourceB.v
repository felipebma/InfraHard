module MUXUlaSourceB(e000, e010, e100, Sinal, Out);

input wire [31:0] e000, e010, e100; // entradas
input wire [2:0] Sinal; // controle
output reg [31:0] Out; // saída

always @(*) begin
	case(Sinal)
		3'b000: Out = e000;
		3'b001: Out = 32'd4;
		3'b010: Out = e010;
		3'b011: Out = 32'd1;
		3'b100: Out = e100;
	endcase
end
endmodule 