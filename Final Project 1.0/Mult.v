module Mult(Hi, Lo, A, B, clock, MultReset, MultCtrl);
	
	// Algoritmo inspirado neste site: https://www.studytonight.com/computer-architecture/booth-multiplication-algorithm
	
	input wire clock, MultReset, MultCtrl;
	input wire[31:0] A, B;
	output reg[31:0] Hi, Lo;
	integer Shifts;
	reg[64:0] Prod, A65b;
	
	always @(posedge clock) begin
		if (MultReset == 1) begin
			Hi = 32'b0;
			Lo = 32'b0;
			A65b = 65'b0;
			Prod = 65'b0;
			Shifts = 0;
		end
		if (MultCtrl == 1) begin
			Hi = 32'b0;
			Lo = 32'b0;
			A65b = {A, 33'b0};
			Prod = {32'b0, B, 1'b0};
			Shifts = 0;
		end
		case(Prod[1:0])
			2'b11: begin
				if (Shifts < 32) begin
					Prod = Prod >> 1;
					Shifts = Shifts + 1;
				end
			end
			2'b00: begin
				if (Shifts < 32) begin
					Prod = Prod >> 1;
					Shifts = Shifts + 1;
				end
			end
			2'b01: begin
				if (Shifts < 32) begin
					Prod = Prod + A65b;
					Prod = Prod >> 1;
					Shifts = Shifts + 1;
				end
			end
			2'b10: begin
				if (Shifts < 32) begin
					Prod = Prod - A65b;
					Prod = Prod >> 1;
					Shifts = Shifts + 1;
				end
			end
		endcase
		if(Prod[63] == 1) begin // Garantir que seja negativo
			Prod[64] = 1;
		end
		if(Shifts == 32) begin
			Hi = Prod[64:33];
			Lo = Prod[32:1];
		end
	end
endmodule