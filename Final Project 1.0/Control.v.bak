module Controler (opcode,func,clock,Reset,PCWrite,IorD,MemWrite,MemToReg,IRWrite,PCSrc,ALUop,ALUSrcA,ALUSrcB,RegWrite,RegDst,ALUout,AWrite,BWrite,MultCtrl,DivCtrl);
	input wire [5:0] opcode,func;
	input wire clock;
	reg [5:0] Fetch,Wait1,InstRead,Wait2,OpcodeRead,WriteRegALU,ResetS;
	output reg Reset,PCWrite,MemWrite,IRWrite,RegWrite,ALUout,AWrite,BWrite,MultCtrl,DivCtrl;
	
	output reg [1:0] ALUSrcA,RegDst;
	output reg [2:0] IorD,PCSrc,ALUop,ALUSrcB;
	output reg [3:0] MemToReg;
	reg [5:0] Estado;
	initial begin 
		Estado <= 6'd0;
		ResetS <= 6'd0;
		Fetch <= 6'd1;
		Wait1 <= 6'd2;
		InstRead <= 6'd3;
		Wait2 <= 6'd4;
		OpcodeRead <= 6'd5;
		WriteRegALU <= 6'd6;
		WriteRegALU2 <= 6'd7;
	end
	
		
	always @(posedge clock) begin
		case(Estado)
			ResetS: begin
				Reset <= 1'b1;
				Estado <= Fetch;
			end
			Fetch: begin //Solicita Leitura da Memoria e faz PC + 4
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b1;
				
				PCSrc <= 3'b000;
				ALUop <= 3'b001;
				ALUSrcA <= 2'b00;
				ALUSrcB <= 3'b001;
				Reset <= 1'b0;
				IorD <= 3'b100;
				MemToReg <= 4'b0000;
				RegDst <= 2'b00;
				Estado <= Wait1;				
			end
			Wait1: begin
				PCWrite <= 1'b1;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				
				ALUout <= 1'b0;
				Estado <= InstRead;
			end
			InstRead: begin //Carrega Dados da Memoria nos Registradores de Instrução e Operação (A e B).
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b1;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				
				Estado <= Wait2;
			end
			Wait2: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b1;
				BWrite <= 1'b1;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				
				Estado <= OpcodeRead;			
			end
			WriteRegALU: begin //Carrea info do ALUout no Registrador
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b1;
				ALUout <= 1'b0;
				
				MemToReg <= 4'b0000;
				RegDst <= 2'b11;
				Estado <= Fetch;
			end
			WriteRegALU2: begin //Carrega info do ALUout no Registrador (imediate)
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b1;
				ALUout <= 1'b0;
				
				MemToReg <= 4'b0000;
				RegDst <= 2'b00;
				Estado <= Fetch;
			end
			OpcodeRead: begin
				case(opcode)
					6'd0: begin
						case(func)
							6'b100000: begin //Add e salva no ALUout
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b1;
								
								ALUop <= 3'b001;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
							6'b100010: begin //Sub e salva no ALUout
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b1;
								
								ALUop <= 3'b010;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
							6'b100100: begin //And e salva no ALUout
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b1;
								
								ALUop <= 3'b011;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
						endcase
					end
					6'd8: begin //Addi e salva em ALUout
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
								
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= WriteRegALU2;
					end
					6'd9: begin //Addiu e salva em ALUout
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
								
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= WriteRegALU2;	
					end
				endcase
			end
				
		endcase
	end
endmodule 	