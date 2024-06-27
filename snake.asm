.data
pantalla: .space 524288 # tamaño de la pantalla 512 ancho x 256 alto
#Dirección inicial de la manzana
manzanaX: .word	20 #Dirección X de la manzana		
manzanaY: .word	13 #Dirección Y de la manzana	
#Esto es para convertir coordenadas a (x,y) en el Bitmap	
XConversion: .word 64 #Conversión X Fila=64 para el Bitmap		
YConversion: .word 4 #Conversión Y para el Bitmap
#Dirección inicial	
posiX: .word 50 #es una dirección arbitraria
posiY: .word 27 #es una dirección arbitraria
#Settear las velocidades en 0
veloX: .word 0	#Velocidad en X empieza en 0
veloY: .word 0	#Velocidad en Y empieza en 0
#Estos son sus respectivos pixeles con sus colores(Morado=0x**800080) para la dirección de la serpiente
dirSerpArriba: .word 0x00800080 
dirSerpAbajo: .word	0x01800080	
dirSerpIzquierda: .word	0x02800080	
dirSerpDerecha:	.word	0x03800080
#Dirección arbitraria de donde va a empezar la cola
cola: .word 7624

.text
main:
    la $t0,pantalla #Direccion base de pantalla
    li $t1, 8192 #La cantidad total de pixeles
    li $t2, 0x00FFFF00#Código del color Amarillo
pintarfondo:
    sw $t2,0($t0) #Pintamos del color que es
    addi $t0,$t0,4 #Pasamos a la siguiente linea 
    addi $t1,$t1,-1 #Restamos al contador
    bnez $t1,pintarfondo #si no es 0 sigue pintando

la $t0,pantalla #Direccion base de pantalla
addi $t1,$zero,64 #tamaño de la fila
li $t2, 0x0000FFFF #Color cian

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

jal dibujarManzana #Después de dibujar todo el marco dibujamos la manzana

actualizarJuego:
    lw $t3 , 0xffff0004 #Guarda las entradas de teclado en $t3

    addi $v0, $zero,32 #Damos un tiempo entre interacción
    addi $a0,$zero, 55 # 55 ms
    syscall

    beq $t3, 119, arriba #Entrada de teclado w
    beq $t3, 115, abajo #Entrada de teclado s
    beq $t3, 97, izquierda #Entrada de teclado a
    beq $t3, 100, derecha #Entrada de teclado d
    beq $t3, 0, arriba #empezar juego hacia arriba
arriba:
	lw $s3,dirSerpArriba #Dirección de la serpiente
	add $a0, $s3, $zero #Guardamos la dirección en $a0
	jal actualizarSerpiente #Actualizamos serpiente
	
	jal actualizarCabezaSerp #Actualizamos cabeza
	j salirMov #Salimos del movimiento
abajo:
	lw $s3,dirSerpAbajo #Dirección de la serpiente
	add $a0, $s3, $zero #Guardamos la dirección en $a0
	jal actualizarSerpiente #Actualizamos serpiente
	
	jal actualizarCabezaSerp #Actualizamos cabeza
	j salirMov #Salimos del movimiento
izquierda:
	lw $s3,dirSerpIzquierda	#Dirección de la serpiente
	add $a0, $s3, $zero #Guardamos la dirección en $a0
	jal actualizarSerpiente #Actualizamos serpiente
	
	jal actualizarCabezaSerp #Actualizamos cabeza
	j salirMov #Salimos del movimiento
derecha:
	lw $s3,dirSerpDerecha #Dirección de la serpiente 
	add $a0, $s3, $zero #Guardamos la dirección en $a0
	jal actualizarSerpiente #Actualizamos serpiente
	
	jal actualizarCabezaSerp #Actualizamos cabeza
	j salirMov #Salimos del movimiento
salirMov:
	j actualizarJuego #Volvemos al loop inicial


###$sp + 0:  [guardado $fp]###
###$sp + 4:  [guardado $ra]###
###$sp + 8:  [espacio para variables locales o argumentos]###
###$sp + 12: [espacio para variables locales o argumentos]###
###$sp + 16: [espacio para variables locales o argumentos]###
###$sp + 20: [nuevo $fp]###

actualizarSerpiente:

    addiu $sp, $sp, -24 #Pedimos 24 bytes en la pila
    sw $fp, 0($sp)     #Almacenamos el framepointer
    sw $ra, 4($sp)     #Almacenar el $ra
    addiu $fp, $sp,20   #Settear el frame pointer de actualizarSerpiente


    #CABEZA
    lw $t0, posiX   #posiX de la serpiente
    lw $t1, posiY   #posiY de la serpiente
    lw $t2, XConversion  #conversion para los cálculosX(64)
    mult $t1, $t2       #PosicionY * 64
    mflo $t3    #Guardarlo en $t3
    add $t3, $t3, $t0 #Sumarle la posición en X
    lw $t2, YConversion #conversion para los cálculos en Y(4)
    mult, $t3, $t2  #Direccion calculada en $t3 por la conversión en Y
    mflo $t0    #Guardar el resultado en $t0
    
    la $t1, pantalla    # Carga la dirección de pantalla en el registro $t1.
    add $t0, $t1, $t0   # Suma el valor en $t0 con la pantalla y lo almacena en el mismo
    lw $t4, 0($t0)      # Carga la dirección contenida en $t0 en el registro $t4.
    sw $a0, 0($t0)      # Almacena $a0 en la dirección contenida en $t0.

    #Velocidad para todas direcciones
    
    lw $t2, dirSerpArriba	#Dirección de serpiente arriba
    beq $a0, $t2, velocidadArriba #Actualizamos la velocidad
    
    lw $t2,dirSerpAbajo #Dirección de serpiente Abajo
    beq $a0,$t2, velocidadAbajo #Actualizamos la velocidad
    
    lw $t2, dirSerpIzquierda #Dirección de serpiente Izquierda
    beq $a0, $t2, velocidadIzquierda #Actualizamos la velocidad
    
    lw $t2,dirSerpDerecha #Dirección de serpiente Derecha
    beq $a0,$t2, velocidadDerecha #Actualizamos la velocidad
    
    
velocidadArriba:
    addi $t5,$zero, 0 #Velocidad en X=0
    addi $t6, $zero,-1 #Velocidad en Y=-1
    #Actualizamos ambas velocidades en memoria
    sw $t5, veloX 
    sw $t6, veloY
    j salirVelo	#Salimos de actualizar la velocidad
velocidadAbajo:
    addi $t5,$zero, 0 #Velocidad en X=0
    addi $t6, $zero,1 #Velocidad en Y=1
    #Actualizamos ambas velocidades en memoria
    sw $t5, veloX
    sw $t6, veloY
    j salirVelo #Salimos de actualizar la velocidad
velocidadIzquierda:
    addi $t5,$zero, -1 #Velocidad en X=-1
    addi $t6, $zero,0 #Velocidad en Y=0
    #Actualizamos ambas velocidades en memoria
    sw $t5, veloX
    sw $t6, veloY
    j salirVelo #Salimos de actualizar la velocidad
velocidadDerecha:
    addi $t5,$zero, 1 #Velocidad en X=1
    addi $t6, $zero,0 #Velocidad en Y=0
    #Actualizamos ambas velocidades en memoria
    sw $t5, veloX
    sw $t6, veloY
    j salirVelo #Salimos de actualizar la velocidad

salirVelo:
	li $t2, 0x00FF0000	#color rojo
	bne $t2, $t4, cabezaDifManzana 
	
	
	jal nuevaManzana #Sacar coordenada para manzana nueva
	jal dibujarManzana #Dibujar la manzana
	j salirActuSerp #Dibujar serpiente actualizada
	
	
	
	
salirActuSerp:
	#Reestablece los valores y retorna
	lw $ra, 4($sp)
	lw $fp, 0($sp)
	addiu $sp,$sp,24
	jr $ra
	
	
dibujarManzana:
	addiu 	$sp, $sp, -24	# Reserva 24 bytes en la pila	
	sw 	$fp, 0($sp) # Guarda el valor del marco de pila ($fp) en la pila	
	sw 	$ra, 4($sp) # Guarda el valor del registro de retorno ($ra) en la pila.	
	addiu 	$fp, $sp, 24	# Ajusta el marco de pila ($fp) a la nueva posición del stack pointer.
	
	lw	$t0, manzanaX	# Coordenada X de la manzana en $t0.
	lw	$t1, manzanaY	# Coordenada Y de la manzana en $t1.
	lw	$t2, XConversion	# ConversiónX en $t2
	
	
	mult	$t1, $t2	# Multiplica Y por el factor de conversión X.
	mflo	$t3		# El resultado en $t3.
	add	$t3, $t3, $t0	# Suma la coordenada X al resultado para obtener una dirección temporal	
	
	
	lw	$t2, YConversion	# Conversión Y en $t2
	mult	$t3, $t2		# Dirección parcial por el factor de conversión Y
	mflo	$t0			# El resultado en $t0
	
	
	la 	$t1, pantalla	# Dirección base de la pantalla en $t1
	add	$t0, $t1, $t0	# Dirección final sumándola a la dirección base de la pantalla
	
	
	li	$t4, 0x00FF0000	 #Color Rojo	
	sw	$t4, 0($t0)	 # Almacena el color en la dirección calculada
	
	
	lw 	$ra, 4($sp)	# Restaura el valor de $ra	
	lw 	$fp, 0($sp)	# Restaura el valor de $fp
	addiu 	$sp, $sp, 24	# Libera el espacio en la pila
	jr 	$ra		# Retorna
actualizarCabezaSerp:
	# Pedimos memoria en la pila para el framepointer
	addiu 	$sp, $sp, -24    # Ajusta el puntero de pila ($sp) para reservar espacio en la pila (24 bytes).
	sw 	$fp, 0($sp)       # Guarda el valor del frame pointer ($fp) actual en la pila.
	sw 	$ra, 4($sp)       # Guarda el valor del return address ($ra) actual en la pila.
	addiu 	$fp, $sp, 20     # Actualiza el frame pointer ($fp) al nuevo valor del puntero de pila.

	# Carga valores de memoria en registros
	lw	$t3, veloX       # Carga el valor de veloX en el registro $t3.
	lw	$t4, veloY       # Carga el valor de veloY en el registro $t4.
	lw	$t5, posiX       # Carga el valor de posiX en el registro $t5.
	lw	$t6, posiY       # Carga el valor de posiY en el registro $t6.

	# Actualiza la posición sumando la velocidad
	add	$t5, $t5, $t3    # Suma veloX a posiX y guarda el resultado en $t5.
	add	$t6, $t6, $t4    # Suma veloY a posiY y guarda el resultado en $t6.

	# Guarda los nuevos valores de posición en memoria
	sw	$t5, posiX       # Guarda el nuevo valor de posiX en la memoria.
	sw	$t6, posiY       # Guarda el nuevo valor de posiY en la memoria.

		
	#Reestablecerlos
	lw 	$ra, 4($sp)	
	lw 	$fp, 0($sp)	
	addiu 	$sp, $sp, 24	
	jr 	$ra		
cabezaDifManzana:
	li $t2, 0x00FFFF00	#color del fondo Amarillo
	beq $t2, $t4, cabezaValida #Si es amarillo es una cabeza válida y se va a cabezaValida
	jal derrota #Perdió

cabezaValida:
	#Quitar cola
	lw $t0, cola # t0 = cola
	la $t1, pantalla # cargar la dirección de pantalla
	add $t2, $t0, $t1  # t2 = ubicación de cola en bitmap display
	li $t3, 0x00FFFF00 #color del fondo Amarillo
	lw $t4, 0($t2) #t4 = dirección de cola y color
	sw  $t3, 0($t2) # reemplazar cola con color de fondo
	
	#Nueva cola  	
	lw $t5,dirSerpArriba # carga la palabra dirSerpArriba = 0x00800080
	beq $t5, $t4,nuevaColaArriba # si la dirección de la cola y el color == serpiente hacia arriba para establecer Nueva cola arriba
	
	lw $t5,dirSerpAbajo # carga la palabra dirSerpAbajo = 0x01800080
	beq $t5, $t4,nuevaColaAbajo # si la dirección de la cola y el color == serpiente hacia arriba para establecer Nueva cola arriba
	
	lw $t5,dirSerpIzquierda # carga la palabra dirSerpIzquierda = 0x02800080
	beq $t5, $t4,nuevaColaIzquierda # si la dirección de la cola y el color == serpiente hacia Izquierda para establecer Nueva cola Izquierda
	
	lw $t5,dirSerpDerecha # carga la palabra dirSerpDerecha = 0x03800080
	beq $t5, $t4,nuevaColaDerecha # si la dirección de la cola y el color == serpiente hacia Derecha para establecer Nueva cola Derecha
	
nuevaColaArriba:
	addi $t0,$t0,-256 #cola=cola-256
	sw $t0,cola #Guardar cola en memoria
	j salirActuSerp
nuevaColaAbajo:
	addi $t0,$t0,256 #cola=cola+256
	sw $t0,cola #Guardar cola en memoria
	j salirActuSerp
nuevaColaIzquierda:
	addi $t0,$t0,-4 #cola=cola-4
	sw $t0,cola #Guardar cola en memoria
	j salirActuSerp
nuevaColaDerecha:
	addi $t0,$t0,4 #cola=cola+4
	sw $t0,cola #Guardar cola en memoria 
	j salirActuSerp
nuevaManzana:
	addiu 	$sp, $sp, -24	# Reserva 24 bytes en la pila	
	sw 	$fp, 0($sp) # Guarda el valor del marco de pila ($fp) en la pila	
	sw 	$ra, 4($sp) # Guarda el valor del registro de retorno ($ra) en la pila.	
	addiu 	$fp, $sp, 20	# Ajusta el marco de pila ($fp) a la nueva posición del stack pointer.
otroRandom:
	addi	$v0, $zero, 42	# random  
	addi	$a1, $zero, 63	# límite del random
	syscall
	add	$t1, $zero, $a0	# random coordenada x de manzana
	
	addi	$v0, $zero, 42	# random  
	addi	$a1, $zero, 31	# límite del random
	syscall
	add	$t2, $zero, $a0	# random coordenada y de manzana
	
	lw	$t3, XConversion	# t3 = 64
	mult	$t2, $t3		# random manzanaY * 64
	mflo	$t4			# t4 = random manzanaY * 64
	add	$t4, $t4, $t1		# t4 = random manzana * 64 + random manzanaX
	lw	$t3, YConversion	# t3 = 4
	mult	$t3, $t4		# (random manzanaY * 64 + random manzanaX) * 4
	mflo	$t4			# t1 = (random manzanaY * 64 + random manzanaX) * 4
	
	la 	$t0, pantalla	# cargar la pantalla
	add	$t0, $t4, $t0		# t0 = (manzanaY * 64 + manzanaX) * 4 + dirección de pantall
	lw	$t5, 0($t0)		# t5 = valor del pixel en t0
	
	li	$t6, 0x00FFFF00	# Amarillo
	beq	$t5, $t6, manzanaValida	#si la ubicación es valida salta a manzanaValida
	j otroRandom
manzanaValida:
	#Guarda las coordenadas
	sw	$t1, manzanaX
	sw	$t2, manzanaY	

	lw 	$ra, 4($sp)	# Restaura el valor de $ra
	lw 	$fp, 0($sp)	# Restaura el valor de $fp
	addiu 	$sp, $sp, 24	# Libera el espacio en la pila
	jr 	$ra		# retorna
derrota:
	li $v0, 10
	syscall
	
		
