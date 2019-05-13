module Extensor8_32(Input,Output);

input wire [7:0] Input;
output reg [31:0] Output;

always @(*) begin
	Output[7:0] <= Input;
end
endmodule 