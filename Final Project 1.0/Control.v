module Controler (opcode,func,clock,Reset,PCWrite,IorD,MemWrite,MemToReg,IRWrite,PCSrc,ALUop,ALUSrcA,
	ALUSrcB,RegWrite,RegDst,ALUout,AWrite,BWrite,MultCtrl,DivCtrl,MDRMux,MDRWrite,StoreControl,
	PCWriteCond,ALUcond,Shift,RDn,RDx,MultCtrl,DivCtrl, HiLoCtrl, MultDivSel, EPCWrite);
	
	input wire [5:0] opcode,func;
	input wire clock;
	output reg Reset,PCWrite,MemWrite,IRWrite,RegWrite,ALUout,AWrite,BWrite,MultCtrl,DivCtrl,MDRWrite,
	PCWriteCond,RDn,RDx, HiLoCtrl, MultDivSel, EPCWrite;
	
	output reg [1:0] ALUSrcA,RegDst,MDRMux,StoreControl,ALUcond;
	output reg [2:0] IorD,PCSrc,ALUop,ALUSrcB,Shift;
	output reg [3:0] MemToReg;
	reg [6:0] Estado, counter;
	reg div0;
	
	//Estados
	reg [6:0] Fetch,Wait1,InstRead,Branch,OpcodeRead,WriteRegALU,WriteRegALU2,ResetS,CarregaByteMDR,
	EscreveMDRemRegistrador,Wait3,SolicitaDado1,SolicitaDado2,Wait4,CarregaWordMDR,SolicitaDado3,Wait5,
	CarregaHalfWordMDR,EscreveMemoriaByte,EscreveMemoriaHalfWord,EscreveMemoriaWord,WriteRegRD,Shift1,
	Shift2,Shift3,SolicitaDado4,Wait6,SolicitaDado5,Wait7, Mult, MultWait, Mult2, Div, DivWait, Div2, Div0, Exception, Mfhi, Mflo;
	//OpCodes
	reg [5:0] ADDI = 6'd8, ADDIU = 6'd9, LB = 6'd32, LW = 6'd35, LH = 6'd33,SB = 6'd40, SH = 6'd41,
	SW = 6'd43, BEQ = 6'd4, BNE = 6'd5, BLE = 6'd6, BGT = 6'd7;
	
	
	// Fun��es
	reg [5:0] ADD = 6'b100000, SUB = 6'b100010, AND = 6'b100100,SLL = 6'd0,SLLV = 6'd4,SRA = 6'd3,
	SRAV = 6'd7,SRL = 6'd2, MULT = 6'h18, DIV = 6'h1A, MFHI = 6'h10, MFLO = 6'h12;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	initial begin 
		Estado <= 7'd0;
		ResetS <= 7'd0;
		Fetch <= 7'd1;
		Wait1 <= 7'd2;
		InstRead <= 7'd3;
		Branch <= 7'd4;
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
		WriteRegRD <= 7'd21;
		Shift1 <= 7'd22;
		Shift2 <= 7'd23;
		Shift3 <= 7'd24;
		SolicitaDado4 <= 7'd25;
		Wait6 <= 7'd26;
		SolicitaDado5 <= 7'd27;
		Wait7 <= 7'd28;
		Mult <= 7'd29; 
		MultWait <= 7'd30;
		Mult2 <= 7'd31;
		Div <= 7'd32;
		DivWait <= 7'd33;
		Div2 <= 7'd34;
		Div0 = 7'd35;
		Mfhi <= 7'd36;
		Mflo <= 7'd37;
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				HiLoCtrl <= 0;
				
				Estado <= Branch;
			end
			Branch: begin //Offset + PC + 4
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b1;
				BWrite <= 1'b1;
				RegWrite <= 1'b0;
				ALUout <= 1'b1;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				ALUSrcA <= 2'b00;
				ALUSrcB <= 3'b010;
				ALUop <= 3'b001;
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
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
				PCWriteCond <= 1'b0;
				
				IorD <= 3'b101;
				StoreControl <= 2'b10;
				Estado <= Fetch;
			end
			SolicitaDado5: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				IorD <= 3'b101;
				Estado <= Wait7;
			end
			Wait7: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				Estado <= EscreveMemoriaByte;
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
				PCWriteCond <= 1'b0;
				
				IorD <= 3'b101;
				StoreControl <= 2'b01;
				Estado <= Fetch;
			end
			SolicitaDado4: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				IorD <= 3'b101;
				Estado <= Wait6;
			end
			Wait6: begin
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				Estado <= EscreveMemoriaHalfWord;
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
				PCWriteCond <= 1'b0;
				
				IorD <= 3'b101;
				StoreControl <= 2'b00;
				Estado <= Fetch;
			end
			WriteRegRD: begin // Escreve no Registrador o valor entregue por RD
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b1;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				MemToReg <= 4'b0010;
				RegDst <= 2'b11;
				Estado <= Fetch;
			end
			Shift1: begin //Shift Left n vezes
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				Shift <= 3'b010;
				Estado <= WriteRegRD;
			end
			Shift2: begin //Shift Rigth aritimetico n vezes
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				Shift <= 3'b100;
				Estado <= WriteRegRD;
			end
			Shift3: begin //Shift Rigth Logico n vezes
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
				AWrite <= 1'b0;
				BWrite <= 1'b0;
				RegWrite <= 1'b0;
				ALUout <= 1'b0;
				MDRWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				
				Shift <= 3'b011;
				Estado <= WriteRegRD;
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
								PCWriteCond <= 1'b0;
								
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
								PCWriteCond <= 1'b0;
								
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
								PCWriteCond <= 1'b0;
								
								ALUop <= 3'b011;
								ALUSrcA <= 2'b10;
								ALUSrcB <= 3'b000;
								Estado <= WriteRegALU;
							end
							SLL: begin //Carrega dados no RD
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b0;
								MDRWrite <= 1'b0;
								PCWriteCond <= 1'b0;
								
								RDn <= 1'b1;
								RDx <= 1'b0;
								Shift <= 3'b001;
								Estado <= Shift1;
							end
							SLLV: begin //Carrega dados no RD
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b0;
								MDRWrite <= 1'b0;
								PCWriteCond <= 1'b0;
								
								RDn <= 1'b0;
								RDx <= 1'b1;
								Shift <= 3'b001;
								Estado <= Shift1;
							end
							SRA: begin //Carrega dados no RD
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b0;
								MDRWrite <= 1'b0;
								PCWriteCond <= 1'b0;
								
								RDn <= 1'b1;
								RDx <= 1'b0;
								Shift <= 3'b001;
								Estado <= Shift2;
							end
							SRAV: begin //Carrega dados no RD
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b0;
								MDRWrite <= 1'b0;
								PCWriteCond <= 1'b0;
								
								RDn <= 1'b0;
								RDx <= 1'b1;
								Shift <= 3'b001;
								Estado <= Shift2;
							end
							SRL: begin //Carrega dados no RD
								PCWrite <= 1'b0;
								MemWrite <= 1'b0;
								IRWrite <= 1'b0;
								AWrite <= 1'b0;
								BWrite <= 1'b0;
								RegWrite <= 1'b0;
								ALUout <= 1'b0;
								MDRWrite <= 1'b0;
								PCWriteCond <= 1'b0;
								
								RDn <= 1'b1;
								RDx <= 1'b0;
								Shift <= 3'b001;
								Estado <= Shift3;
							end
							MULT:begin 
								Estado <= Mult;
							end	
							DIV:begin
								Estado <= Div;
							end							
							MFHI:begin
								Estado <= Mfhi;
							end							
							MFLO:begin
								Estado <= Mflo;
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
						PCWriteCond <= 1'b0;
								
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
						PCWriteCond <= 1'b0;
								
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
						PCWriteCond <= 1'b0;
						
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
						PCWriteCond <= 1'b0;
						
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
						PCWriteCond <= 1'b0;
						
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
						PCWriteCond <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= SolicitaDado5;
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
						PCWriteCond <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= SolicitaDado4;
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
						PCWriteCond <= 1'b0;
						
						RegDst <= 2'b00;
						ALUop <= 3'b001;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 3'b010;
						Estado <= EscreveMemoriaWord;
					end
					BEQ: begin // Verifica Condicional e escreve em PC
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b0;
						MDRWrite <= 1'b0;
						PCWriteCond <= 1'b1;
						
						ALUop <= 3'b111;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 2'b000;
						PCSrc <= 3'b000;
						ALUcond <= 2'b11;
						Estado <= Fetch;
					end
					BNE: begin // Verifica Condicional e escreve em PC
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b0;
						MDRWrite <= 1'b0;
						PCWriteCond <= 1'b1;
						
						ALUop <= 3'b111;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 2'b000;
						PCSrc <= 3'b000;
						ALUcond <= 2'b10;
						Estado <= Fetch;
					end
					BLE: begin // Verifica Condicional e escreve em PC
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b0;
						MDRWrite <= 1'b0;
						PCWriteCond <= 1'b1;
						
						ALUop <= 3'b111;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 2'b000;
						PCSrc <= 3'b000;
						ALUcond <= 2'b00;
						Estado <= Fetch;
					end
					BGT: begin //Verifica Condicional e escreve em PC
						PCWrite <= 1'b0;
						MemWrite <= 1'b0;
						IRWrite <= 1'b0;
						AWrite <= 1'b0;
						BWrite <= 1'b0;
						RegWrite <= 1'b0;
						ALUout <= 1'b0;
						MDRWrite <= 1'b0;
						PCWriteCond <= 1'b1;
						
						ALUop <= 3'b111;
						ALUSrcA <= 2'b10;
						ALUSrcB <= 2'b000;
						PCSrc <= 3'b000;
						ALUcond <= 2'b01;
						Estado <= Fetch;
					end
					Div: begin
					DivCtrl <= 1;
					
					Estado <= DivWait;
					end
					DivWait: begin
						DivCtrl <= 0;
					
						if(counter == 32) begin
							Estado <= Div2;
						end else begin 
							counter = counter + 1;
							Estado <= DivWait;
						end
					end
					Div2: begin
						MultDivSel <= 0;
						HiLoCtrl <= 1;
					
						if(div0 == 1) begin
							Estado <= Div0;
						end else begin
							Estado <= Fetch;
						end
					end
					Div0: begin
						ALUSrcA <= 2'b00;
						ALUSrcB <= 3'b001;
						ALUop <= 2;
						EPCWrite <= 1;
						IorD <= 3;
						MemWrite <= 0;
					
						Estado <= Exception;
					end
					Exception: begin
						PCSrc <= 4;
						PCWrite <= 1;
					
						Estado <= Fetch;
					end
					Mult: begin
						MultCtrl <= 1;
					
						Estado <= MultWait;
					end
					MultWait: begin
						MultCtrl <= 0;
					
						if(counter == 32) begin
							Estado <= Mult2;
						end else begin 
							counter = counter + 1;
							Estado <= MultWait;
						end
					end
					Mult2: begin
						MultDivSel <= 1;
						HiLoCtrl <= 1;
					
						Estado <= Fetch;
					end
					Mfhi: begin
						RegDst <= 3;
						MemToReg <= 4;
						RegWrite <= 1;
					
						Estado <= Fetch;
					end
					Mflo: begin
						RegDst <= 3;
						MemToReg <= 5;
						RegWrite <= 1;
					
						Estado <= Fetch;
					end
				endcase
			end
				
		endcase
	end
endmodule 	