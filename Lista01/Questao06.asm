.data

A: .word 1
B: .word 10

.text
lw $a0, A
lw $a1, B

bgt  $a0, $a1, INVALID # testa se a > b
beq $a0, $a1, EQUAL # testa se a == b, nesse caso o resultado é apenas a + b

jal REC # executa o procedimento
j END # fim

REC:
addi $sp, $sp, -8 # reserva espaço para 2 itens na pilha
sw $ra, 4($sp) # endereço de retorno
sw $a0, 0($sp) # guardando apenas o primeiro argumento já que o segundo permanece o mesmo a cada chamada

seq $t0, $a0, $a1 # testa se a == b
beq $t0, $zero, MAIN # recursão não acabou

add $v0, $a0, $zero # como a == b retorna a
addi $sp, $sp, 8 # faz pop de 2 items da pilha
jr $ra # retorna

MAIN:
addi $a0, $a0, 1 # avança a
jal REC # entra na recursão
lw $a0, 0($sp) # recursao acabou, começando a desempilhar e efetuar o cálculo
lw $ra, 4($sp)
addi $sp, $sp, 8
add $v0, $v0, $a0 # acumulando o valor final em $v0
jr $ra # no final volta para onde o procedimento foi chamado

INVALID:
addi $v1, $zero, 1 # inválido porque b > a
j END

EQUAL:
add $v0, $zero, $a0 # no caso de serem iguais retorna o próprio valor

END:
break
