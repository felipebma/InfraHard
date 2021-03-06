module MUX9 (A,B,C,D,E,F,G,H,I,Sinal,Out);
	input wire [31:0] A,B,C,D,E,F,G,H,I;
	input wire [3:0] Sinal;
	output reg [31:0] Out;
	always @(*) begin
	case(Sinal)
		3'b0000: Out = A;
	    3'b0001: Out = B;
	    3'b0010: Out = C;
	    3'b0011: Out = D;
	    3'b0100: Out = E;
	    3'b0101: Out = F;
	    3'b0110: Out = G;
	    3'b0111: Out = H;
	    3'b1000: Out = I;
	endcase
end
endmodule 