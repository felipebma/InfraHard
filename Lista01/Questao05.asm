# Colocar em B os primos encontrados em A

.data
# Array A contém os primos a serem avaliados, Array B é o Array de destino
A: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
B: .word 0

#Constantes do sistema, Size armazena o tamanho do Array A
Size: .word 20
um: .word 1
shift2: .word 4

.text
# Seta os iteradores dos arrays para a posição inicial
add $t0,$zero,$zero
add $t1,$zero,$zero
# Carrega o tamanho do Array A no registrador s0, e depois multiplica esse valor por 4
lw $s0,Size
lw $t2,shift2
mult $s0,$t2
mflo $s0

while:	beq $t0,$s0, end 		# Enquanto o valor do iterador do Array A não chegar no seu valor final (4*(Size-1)), ele vai avaliando os números
	lw $s1,A($t0)			# Guarda o n-ésimo elemento do Array A no registrador s1
	addi $t3,$zero,2		# Inicia o valor do divisor para o primeiro valor acima de 1
	for:	beq $t3,$s1,prime	# Caso o divisor seja igual ao número, e ele não tenha sido multiplo de nenhum outro número, ele é primo
		div $s1,$t3		# Divide o valor retirado do Array pelo n-ésimo número menor do que ele
		mfhi $t4		# Registra o resto da divisão no registrador t4
		beqz $t4,endFor		# Caso o resto da divisão seja 0, o valor em questão possui um divisor que não ele mesmo nem 1, logo não é primo
		addi $t3,$t3,1		# Passa para o próximo candidato a divisor
		blt $t3,$s1,for		# Tenta dividir novamente com o novo candidato, caso ele ainda seja menor do que o valor
		prime:			
		sw $s1,B($t1)		# Adiciona o número primo no array B
		addi $t1,$t1,4		# Passa para o próximo espaço do array B
	endFor:
	addi $t0,$t0,4			# Passa para o próximo número a ser avaliado
	j while		
end:


# t0 = iterador do Array A
# t1 = iterador do Array B
# t2 = Constante 4
# t3 = Contador para o check da divisão
# t4 = resto da divisão
# s0 = Tamanho do Array A
# s1 = Elemento do Array A
