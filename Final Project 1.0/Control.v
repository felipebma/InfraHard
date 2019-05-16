module Controler (opcode,func,clock,Reset,PCWrite,IorD,MemWrite,MemToReg,IRWrite,PCSrc,ALUop,ALUSrcA,ALUSrcB,RegWrite,RegDst,ALUout,AWrite,BWrite,MultCtrl,DivCtrl,MDRMux,MDRWrite,StoreControl);
	input wire [5:0] opcode,func;
	input wire clock;
	output reg Reset,PCWrite,MemWrite,IRWrite,RegWrite,ALUout,AWrite,BWrite,MultCtrl,DivCtrl,MDRWrite;
	
	output reg [1:0] ALUSrcA,RegDst,MDRMux,StoreControl;
	output reg [2:0] IorD,PCSrc,ALUop,ALUSrcB;
	output reg [3:0] MemToReg;
	reg [6:0] Estado;
	
	//Estados
	reg [6:0] Fetch,Wait1,InstRead,Wait2,OpcodeRead,WriteRegALU,WriteRegALU2,ResetS,CarregaByteMDR,
	EscreveMDRemRegistrador,Wait3,SolicitaDado1,SolicitaDado2,Wait4,CarregaWordMDR,SolicitaDado3,Wait5,
	CarregaHalfWordMDR,EscreveMemoriaByte,EscreveMemoriaHalfWord,EscreveMemoriaWord;
	//OpCodes
	reg [5:0] ADDI = 6'd8, ADDIU = 6'd9, LB = 6'd32, LW = 6'd35, LH = 6'd33,SB = 6'd40, SH = 6'd41,
	SW = 6'd43;
	
	
	// Fun��es
	reg [5:0] ADD = 6'b100000, SUB = 6'b100010, AND = 6'b100100;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	initial begin 
		Estado <= 7'd0;
		ResetS <= 7'd0;
		Fetch <= 7'd1;
		Wait1 <= 7'd2;
		InstRead <= 7'd3;
		Wait2 <= 7'd4;
		OpcodeRead <= 7'd5;
		WriteRegALU <= 7'd6;
		WriteRegALU2 <= 7'd7;
		CarregaByteMDR <= 7'd8;
		EscreveMDRemRegistrador <= 7'd9;
		Wait3 <= 7'd10;
		SolicitaDado1 <= 7'd11;
		SolicitaDado2 <= 7'd12;
		Wait4 <= 7'd13;
		CarregaWordMDR <= 7'd14;
		SolicitaDado3 <= 7'd15;
		Wait5 <= 7'd16;
		CarregaHalfWordMDR <= 7'd17;
		EscreveMemoriaByte <= 7'd18;
		EscreveMemoriaHalfWord <= 7'd19;
		EscreveMemoriaWord <= 7'd20;
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
				MDRWrite <= 1'b0;
				
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
				MDRWrite <= 1'b0;
				
				ALUout <= 1'b0;
				Estado <= InstRead;
			end
			InstRead: begin //Carrega Dados da Memoria nos Registradores de Instru��o e Opera��o (A e B).
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b1;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
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
				MDRWrite <= 1'b0;
				
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
				MDRWrite <= 1'b0;
				
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
				MDRWrite <= 1'b0;
				
				MemToReg <= 4'b0000;
				RegDst <= 2'b00;
				Estado <= Fetch;
			end
			CarregaByteMDR: begin //Carrega Memory Data com dado da Memoria
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b1;
				
				MDRMux <= 2'b10;
				Estado <= EscreveMDRemRegistrador;
			end
			EscreveMDRemRegistrador: begin //Escreve Memory Data no Registrador
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b1;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				MemToReg <= 4'b0110;
				RegDst <= 2'b00;
				Estado <= Fetch;
			end
			Wait3: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				Estado <= CarregaByteMDR;
			end
			SolicitaDado1: begin //Solicita Dado vindo do ALUout a Memoria
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				IorD <= 3'b101;
				Estado <= Wait3;
			end
			SolicitaDado2: begin //Solicita Dado vindo do ALUout a Memoria
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				IorD <= 3'b101;
				Estado <= Wait4;
			end
			Wait4: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				Estado <= CarregaWordMDR;
			end
			CarregaWordMDR: begin //Carrega Memory Data com dado da Memoria
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b1;
				
				MDRMux <= 2'b00;
				Estado <= EscreveMDRemRegistrador;
			end
			SolicitaDado3: begin //Solicita Dado vindo de ALUout a Memoria
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				IorD <= 3'b101;
				Estado <= Wait5;
			end
			Wait5: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				Estado <= CarregaHalfWordMDR;
			end
			CarregaHalfWordMDR: begin //Carrega Memory Data com dado da Memoria
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b1;
				
				MDRMux <= 2'b01;
				Estado <= EscreveMDRemRegistrador;
			end
			EscreveMemoriaByte: begin //Memory[ALUout] <= byte[B]
				PCWrite <= 1'b0;
				MemWrite <= 1'b1;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				IorD <= 3'b101;
				StoreControl <= 2'b10;
				Estado <= Fetch;
			end
			EscreveMemoriaHalfWord: begin // Memory[ALUout] <= halfWord[B]
				PCWrite <= 1'b0;
				MemWrite <= 1'b1;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				IorD <= 3'b101;
				StoreControl <= 2'b01;
				Estado <= Fetch;
			end
			EscreveMemoriaWord: begin // Memory[ALUout] <= word[B]
				PCWrite <= 1'b0;
				MemWrite <= 1'b1;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				
				IorD <= 3'b101;
				StoreControl <= 2'b00;
				Estado <= Fetch;
			end
			OpcodeRead: begin
				case(opcode)
					6'd0: begin
						case(func)
							ADD: begin //Add e salva no ALUout
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b1;
								MDRWrite <= 1'b0;
								
								ALUop <= 3'b001;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
							SUB: begin //Sub e salva no ALUout
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b1;
								MDRWrite <= 1'b0;
								
								ALUop <= 3'b010;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
							AND: begin //And e salva no ALUout
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b1;
								MDRWrite <= 1'b0;
								
								ALUop <= 3'b011;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
						endcase
					end
					ADDI: begin //Addi e salva em ALUout
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
								
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= WriteRegALU2;
					end
					ADDIU: begin //Addiu e salva em ALUout
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
								
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= WriteRegALU2;	
					end
					LB: begin //Offset + RS
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= SolicitaDado1;
					end
					LW: begin //Offset + RS
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= SolicitaDado2;
					end
					LH: begin //Offset + RS
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= SolicitaDado3;
					end
					SB: begin //Offset + RS
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= EscreveMemoriaByte;
					end
					SH: begin //Offset + RS
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= EscreveMemoriaHalfWord;
					end
					SW: begin //Offset + RS
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b1;
						MDRWrite <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= EscreveMemoriaWord;
					end
				endcase
			end
				
		endcase
	end
endmodule 	