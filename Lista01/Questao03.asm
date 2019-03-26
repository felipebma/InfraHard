.data
#Variaveis na Memoria
	A: .word -2
	B: .word 3
	R: .word 0

#Contantes na Memoria
	zero: .word 0
	um: .word 1
.text
#Carregando Valores
	lw $t1, A
	lw $t2, B
	lw $t3, um
	lw $t4, zero
#Se $t1(A) for negativo inverta o sinal de $t1(A) e $t2(B)
	bgtz $t1, loop
	div $t1,$t1, -1
	div $t2,$t2, -1
loop:
#Some $t2(B) $t1(A) vezes, Subtraindo o valor 1 de $t1(A)
	bgt $t3,$t1,fim
	add $t4,$t4,$t2
	sub $t1,$t1,$t3
	b loop	
fim:
#Jogando Resposta na Memoria
	sw $t4,R
