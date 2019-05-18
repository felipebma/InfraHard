module Div(Hi, Lo, A, B, clock, DivReset, DivCtrl, Div0);
	
	// Algoritmo pego pelo livro e deste site: https://www.pitt.edu/~kmram/CoE0147/lectures/division.pdf
	
	input wire clock, DivReset, DivCtrl;
	input wire[31:0] A, B;
	output reg[31:0] Hi, Lo;
	output reg Div0;
	
	integer Shifts;
	reg[31:0] TempA, TempB;
	reg[64:0] remainder, divisor;
	
	always @(posedge clock) begin
		if(DivReset == 1) begin
			Hi = 32'b0;
			Lo = 32'b0;
			remainder = 64'b0;
			divisor = 64'b0;
			Div0 = 0;
			Shifts = 0;
		end
		
		if (B==0) begin
			Div0 = 1;
		end else begin
			Div0 = 0;
		end
		
		if(DivCtrl == 1) begin
			Hi = 32'b0;
			Lo = 32'b0;
			TempA = -A;
			TempB = -B;
			if(A[31] == 0) begin
				remainder = {33'b0, A};
			end else begin
				remainder = {33'b0, TempA};
			end
			if(B[31] == 0) begin
				divisor = {1'b0, B, 32'b0};
			end else begin
				divisor = {1'b0, TempB, 32'b0};
			end
			Div0 = 0;
			Shifts = 0;
			remainder = remainder << 1;
		end
		
		if(Shifts < 32) begin
			remainder = remainder - divisor;
			
			if(remainder[64] == 1) begin
				remainder = divisor + remainder;
				remainder = remainder<< 1;
			end else begin
				remainder = remainder << 1;
				remainder[0] = 1;
			end
			Shifts = Shifts + 1;
		end
		
		if(Shifts == 32) begin
			Hi = remainder[63:32];
			Hi = Hi >> 1;
			Lo = remainder[31:0];
			Shifts = Shifts + 1;
			if(A[31] == 1 && B[31] == 1) begin
				Hi = -Hi;
			end else if(A[31] == 0 && B[31] == 1) begin
				Lo = -Lo;
			end else if(A[31] == 1 && B[31] == 0) begin
				Hi = -Hi;
				Lo = -Lo;
			end
			
		end
	end
endmodule