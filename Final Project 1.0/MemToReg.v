module MUXMemToReg (e0000,e0001,e0010,e0011,e0100,e0101,e0110,e0111,e1000,Sinal,Out);
	input wire [31:0] e0000,e0001,e0010,e0011,e0100,e0101,e0110,e0111,e1000;
	input wire [3:0] Sinal;
	output reg [31:0] Out;
	always @(*) begin
	case(Sinal)
		3'b0000: Out = e0000;
	    3'b0001: Out = e0001;
	    3'b0010: Out = e0010;
	    3'b0011: Out = e0011;
	    3'b0100: Out = e0100;
	    3'b0101: Out = e0101;
	    3'b0110: Out = e0110;
	    3'b0111: Out = e0111;
	    3'b1000: Out = e1000;
	endcase
end
endmodule 