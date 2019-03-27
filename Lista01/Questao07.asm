# Retornar em V1 o A-ésimo termo de Fibonacci
.data
	A: .word 10 
	
.text
main:
	li $a3,3
	lw $a0,A #argumento
	jal fibo
	#RETORNO DEVE ESTAR EM $v1
			
	## BLOCO Q FAZ O PROGRAMA ENCERRAR COMPLETAMENTE
exit:
	li $v0, 10
	syscall

fibo:
	blt $a0,$a3,casoBase#ARGUMENTO < 3
	#----------------------------------------------------
	#--------------------------------------fibo (a0-1)
	# GUARDA CONTEXTO LOCAL
	subu $sp,$sp,8
	sw $a0,0($sp)#ARGUMENTO
	sw $ra,4($sp)## ENDERECO DE RETORNO
		
	#CHAMA RECURSIVAMENTE FIBO DE a0-1
	subu $a0,$a0,1
	jal fibo
	move $t1,$v1#t1=fibo(a0-1)
	
	# RECUPERA CONTEXTO LOCAL
	lw $a0,0($sp)#ARGUMENTO
	lw $ra,4($sp)## ENDERECO DE RETORNO
	addu $sp,$sp,8
	
	#----------------------------------------------------
	#--------------------------------------fibo(a0-2)
	# GUARDA CONTEXTO LOCAL
	subu $sp,$sp,12
	sw $a0,0($sp)#ARGUMENTO
	sw $ra,4($sp)## ENDERECO DE RETORNO
	sw $t1,8($sp)#guarda fibo(a0-1)  pois pode ser alterado no ramo fibo(a0-2) ou em seus filhos
		
	#CHAMA RECURSIVAMENTE FIBO DE a0-2
	subu $a0,$a0,2
	jal fibo
	move $t2,$v1#t2=fibo(a-2)
	
	# RECUPERA CONTEXTO LOCAL
	lw $a0,0($sp)#ARGUMENTO
	lw $ra,4($sp)## ENDERECO DE RETORNO
	lw $t1,8($sp)#recupera fibo(a-1)
	addu $sp,$sp,12
	
	#SOMA RESULTADOS EM V1
	add $v1,$t1,$t2	#fibo(a)=fibo(a-1)+fibo(a-2)
	j fim
				
	casoBase:
		li $v1,1#fibo(a)=1 se a<3
		
fim: jr $ra
