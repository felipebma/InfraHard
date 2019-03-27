# int a = ...;
# int b = ...;
# x = 0;
# if ( a >= 0 && a < b )
# x = 1;
# else if( a < 0 && a > b )
#	x = 2;
# else
#	x = 3;


.data

#variáveis na memoria
A:.word -10
B:.word 30
X:.word 0

#constantes na memória
um: .word 1
dois: .word 2
tres: .word 3


.text

lw $t1, A	#Carrega o valor de A em t1
lw $t2, B	#Carrega o valor de B em t2
lw $t3, X	#Carrega o valor de A em t3

if: 	bgt $zero, $t1, elseIf	# Caso 0 seja maior que t1(a) pula para o elseIf
	bgt $t2,$t1, entrouIf	# Caso t2(b) seja maior do que t1(a), entra no if, caso contrário vai para o elseIf

elseIf:		bgt $zero,$t1,elseIf2			# Caso 0 seja maior do que t1(a) vai para a segunda condição do else if
		b else					# Caso contrário, pula para o else
elseIf2:	bgt $t1,$t2, entrouElseIf	# Caso t1(a) seja maior do que t2(b) entra no else if

else:	lw $t3,tres	# Atribui a constante 3 em t3(x)	
    	b end		# Pula os outros casos direto para o end

entrouElseIf:	lw $t3,dois	# Atribui a constante 2 em t3(x)
	      	b end		# Pula o outro caso direto para o end
		
entrouIf:	lw $t3,um	# Atribui a constante 1 em t3(x)
	  
end:
#Joga os valores de volta para a memória	
sw $t1, A
sw $t2, B
sw $t3, X
