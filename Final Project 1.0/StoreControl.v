module StoreControl(Input,MemData,Output,Sinal);

input wire [1:0] Sinal;
input wire [31:0] Input,MemData;
output reg [31:0] Output;

always @(*) begin
	case(Sinal)
		2'b00: Output <= Input;
		2'b01: begin
			Output[15:0] <= Input[15:0];
			Output[31:16] <= MemData[31:16];
		end
		2'b10: begin
			Output[7:0] <= Input[7:0];
			Output[31:8] <= MemData[31:8];
		end
	endcase
end

endmodule 