module Extensor16_32(Input,Output);

input wire [15:0] Input;
output reg [31:0] Output;

always @(*) begin
	Output[15:0] <= Input;
end
endmodule 