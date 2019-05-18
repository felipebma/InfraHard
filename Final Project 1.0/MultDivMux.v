module MultDivMux(MultDivSel, Div, Mult, Out);

	input wire MultDivSel;
	input wire[31:0] Div, Mult;
	output reg[31:0] Out;
	
	always @(*) begin
		case(MultDivSel)
			0: begin
				Out = Div;
			end
			1: begin
				Out = Mult;
			end
		endcase
	end
endmodule