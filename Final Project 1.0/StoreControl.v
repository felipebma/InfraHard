module StoreControl(Input,Output,Sinal);

input wire [1:0] Sinal;
input wire [31:0] Input;
output reg [31:0] Output;

always @(*) begin
	case(Sinal)
		2'b00: Output <= Input;
		2'b01: Output[15:0] <= Input[15:0];
		2'b10: Output[7:0] <= Input[7:0];
	endcase
end

endmodule 