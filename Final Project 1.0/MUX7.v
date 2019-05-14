module MUX7(A,B,C,D,E,F,G,Sinal,Out);

input wire [31:0] A,B,C,D,E,F,G;//inputs do mux
input wire [2:0] Sinal; //Sinal de Controle
output reg [31:0] Out; //output

always @(*) begin
	case(Sinal)
		3'b000: Out = A;
	    3'b001: Out = B;
	    3'b010: Out = C;
	    3'b011: Out = D;
	    3'b100: Out = E;
	    3'b101: Out = F;
	    3'b110: Out = G;
	endcase
end

endmodule 
