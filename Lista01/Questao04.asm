# Ordenar caracteres de uma string colocando-os em lowercase
# Caso algum caractere n seja letra, armazenar o valor 1 em V1 e encerrar o programa.

.data
#Carregando Variaveis
	S: .byte 'E','n','t','r','a','d','A'
	#S: .byte 'A','C','B'
	Last: .byte 6
	um: .byte 1
.text
	lb $t1, S     #Leitura da String
	lb $t3, Last  #Ultima Posiçao -1
for:
	blt $t1, 65, error #erros menores que as letras
	bgt $t1, 122,error #erros maiores que as letras
	bgt $t1, 90, min   #Se já sao minusculas pule
	add $t1,$t1, 32	   #Transforme em minuscula
min:
	sb $t1,S($t0)	     #Mude o valor da String na memoria
 	bge $t0,$t3,ordenar  #Se já verificou todos os valores pule
 	add $t0,$t0,1        #Some 1 a t0
 	lb $t1, S($t0)       #Carregue o prox char da STring em t1
 	b for		     #Volte para o laço
 
ordenar: 	#BubbleSort
	forOrd:		
		add $t0,$zero,$zero	#Zera o valor de $t0
		add $t1,$t0,$zero       #$t1 = $t0
		forOrd2:	
			addi $t2,$t1,1  #$t2 = $t1+1(prox. letra)
			lb $a0,S($t1)   #Carrega char da posiçao $t1 em $a0
			lb $a1,S($t2)   #Carrega char da posiçao $t2 em $a1
			if:	bge $a1,$a0,endIf  #Se $a1 for menor que $a0 troca eles de lugar
				sb $a0,S($t2)      #troca de lugar na String
				sb $a1,S($t1)      #troca de lugar na String
			endIf:	
			addi $t1,$t1,1       #Soma o contador $t1 em 1
			blt $t1,$t3,forOrd2  #Se não tiver no final da String volte pro ForOrd2
		subi $t3,$t3,1       #Diminui o tamanho de percorrer a String
		addi $t0,$t0,1       #Soma 1 no contador $t0
		blt $t0,$t3,forOrd   #Se Ainda não percorreu tudo volte para o ForOrd
	j fim                        #Pule o ERROR
		
error:
	lb $v1, 1	    #ERROR

fim:
#FimCodigo
