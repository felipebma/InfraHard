module MUXIorD(e000,e100,e101,e110,Sinal,Out);

input wire [31:0] e000,e100,e101,e110;//inputs do mux
input wire [2:0] Sinal; //Sinal de Controle
output reg [31:0] Out; //output

always @(*) begin
	case(Sinal)
		3'b000: Out = e000;
	    3'b001: Out = 32'd253;
	    3'b010: Out = 32'd254;
	    3'b011: Out = 32'd255;
	    3'b100: Out = e100;
	    3'b101: Out = e101;
	    3'b110: Out = e101;
	endcase
end

endmodule 