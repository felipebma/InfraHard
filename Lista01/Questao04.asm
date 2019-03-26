.data
#Carregando Variaveis
	S: .byte 'E','n','t','r','a','d','A'
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
ordenar:
	sub $t0, $t0, $t0    #t0 - t0 = 0
for2:
	bgt $t0,6,fim        #Se já iterou n^2 vezes a String pule
	lb $t4,S($t0)	     #Carregue o primeiro valor de comparaçao da String
for3:
	bgt $t2,6,saiFor3    #Se já iterou n vezes pule
	lb $t5,S($t2)	     #Carregue o elemento a ser comparado em t5
	ble $t4,$t5,foraIf   #Se t4 já for menor ou igual que t5 pule
	sb $t4,S($t2)	     #---------------------------------------
	sb $t5,S($t0)        # Troque os dois valores de lugar
	lb $t4,S($t2)        #---------------------------------------
	j saiFor3	     #Vá Para fora da Iteraçao Interna
foraIf:
	add $t2,$t2,1       #Some 1 ao contador t2
	j for3              #Volte para Iteraçao Interna
saiFor3:
	sub $t2,$t2,$t2     #t2 - t2 = 0
	add $t0,$t0,1       #Some 1 ao contador t0
	j for2	            #Volte para iteraço Externa
error:
	lb $v1, 1	    #ERROR

fim:
#FimCodigo
