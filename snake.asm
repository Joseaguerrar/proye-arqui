.data
pantalla: .space 524288 # tamaño de la pantalla 512 ancho x 256 alto
appleX:		.word	20 #Dirección X de la manzana		
appleY:		.word	13 #Dirección Y de la manzana		
xConversion:	.word	64 #Conversión X Fila=64		
yConversion:	.word	4 #Conversión Y cada uno tiene 4	


.text
main:
    la $t0,pantalla #Direccion base de pantalla
    li $t1, 8192 #La cantidad total de pixeles
    li $t2, 0x00FF0000#Código del color rojo
pintarfondo:
    sw $t2,0($t0) #Pintamos del color que es
    addi $t0,$t0,4 #Pasamos al siguiente
    addi $t1,$t1,-1 #Restamos al contador
    bnez $t1,pintarfondo #si no es 0 sigue pintando

la $t0,pantalla #Direccion base de pantalla
addi $t1,$zero,64 #tamaño de la fila
li $t2, 0x00000000 #Color negro

pintarBordeArriba:
    sw $t2,0($t0) #Empezando en la base, pintamos
    addi $t0,$t0,4 #Incrementamos para pasar al siguiente pixel
    addi $t1,$t1,-1 #Restamos en el contador
    bnez $t1,pintarBordeArriba #si no es 0 sigue pintando


la $t0,pantalla #Dirección base de pantalla
addi $t0, $t0, 7936 #Nos movemos al pixel que empieza en la última fila
addi $t1,$zero,64 #Tamaño de la fila

pintarBordeAbajo:
    sw $t2,0($t0) #Pintamos del color que es
    addi $t0,$t0,4 #Pasamos al siguiente
    addi $t1,$t1,-1 #Restamos 1
    bnez $t1,pintarBordeAbajo #si no es 0 sigue pintando

la $t0,pantalla  #Dirección base de pantalla
addi $t1,$zero,256 #Pasamos a la siguiente fila

pintarBordeIzq:
    sw $t2,0($t0)#Desde el primero lo pintamos del color que es
    addi $t0,$t0,256 #Pasamos a la siguiente fila
    addi $t1,$t1,-1 #Restamos
    bnez $t1, pintarBordeIzq #Si es 0 paramos, si no vuelve a hacerlo

la $t0,pantalla #Dirección base de pantalla
addi $t0, $t0,508#De una vez pasamos a la segunda fila y empezamos de deracha a izq entonces le restamos 4
addi, $t1,$zero,255 #Nos movemos al último pixel de la primera fila

pintarBordeDere:
    sw $t2,0($t0)#Empezando en la base, pintamos
    addi $t0, $t0,256 #Nos movemos al último pixel de la primera fila
    addi $t1,$t1,-1#Restamos 1
    bnez $t1,pintarBordeDere #Si es 0 paramos, si no vuelve a hacerlo

dibujarManzana:
	addiu 	$sp, $sp, -24	# Reserva 24 bytes en la pila	
	sw 	$fp, 0($sp) # Guarda el valor del marco de pila ($fp) en la pila	
	sw 	$ra, 4($sp) # Guarda el valor del registro de retorno ($ra) en la pila.	
	addiu 	$fp, $sp, 24	# Ajusta el marco de pila ($fp) a la nueva posición del stack pointer.
	
	lw	$t0, appleX	# Coordenada X de la manzana en $t0.
	lw	$t1, appleY	# Coordenada Y de la manzana en $t1.
	lw	$t2, xConversion	# ConversiónX en $t2
	
	
	mult	$t1, $t2	# Multiplica Y por el factor de conversión X.
	mflo	$t3		# El resultado en $t3.
	add	$t3, $t3, $t0	# Suma la coordenada X al resultado para obtener una dirección temporal	
	
	
	lw	$t2, yConversion	# Conversión Y en $t2
	mult	$t3, $t2		# Dirección parcial por el factor de conversión Y
	mflo	$t0			# El resultado en $t0
	
	
	la 	$t1, pantalla	# Dirección base de la pantalla en $t1
	add	$t0, $t1, $t0	# Dirección final sumándola a la dirección base de la pantalla
	
	
	li	$t4, 0x00000000	 #Color negro	
	sw	$t4, 0($t0)	# Almacena el color en la dirección calculada
	
	
	lw 	$ra, 4($sp)	# Restaura el valor de $ra	
	lw 	$fp, 0($sp)	# Restaura el valor de $fp
	addiu 	$sp, $sp, 24	# Libera el espacio en la pila
	jr 	$ra		# Retorna	
