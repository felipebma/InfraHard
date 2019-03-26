.data

#variáveis na memoria
A: .word 2
B: .word 1
M: .word 3

.text

lw $t1, A	#Carrega o valor de A em t1
lw $t2, B	#Carrega o valor de B em t2
lw $t3, M	#Carrega o valor de M em t3

add $t3, $t1, $zero #Atribui o valor de t1(a) em t3(m)

bgt $t3,$t2, if #Caso t3(m) seja maior que t2(b) dá um branch para o if

else:	add $t3, $zero, $zero	# Atribui o valor 0 a t3(m)
	b end			# Pula o label if direto para o fim do programa

if: 	add $t3, $t2, $zero	# Atribui o valor de t2(b) em t3(m)

end:

#Joga os valores de volta para a memória
sw $t1, A
sw $t2, B
sw $t3, M
