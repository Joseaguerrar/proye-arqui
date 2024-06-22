.data
pantalla: .space 524288 # tamaño de la pantalla 512 ancho x 256 alto



.text
main:
    la $t0,pantalla
    li $t1, 8192
    li $t2, A52A2A #Código del color rojo
pintarfondo:
    sw,0($t0)
    addi $t0,$t0,4
    addi $t1,$t1,-1
    bnez $t1,pintarfondo #si no es 0 sigue pintando

la $t0,pantalla
addi $t1,$zero,64 #tamaño de la fila
li $t2, 0x00000000

pintarBordeArriba:
    sw $t2,0($t0)
    addi $t0,$t0,4
    addi $t1,$t1,-1
    bnez $t1,pintarBordeArriba #si no es 0 sigue pintando


la $t0,pantalla
addi $t0, $t0, 7936
addi $t1,$zero,64

pintarBordeAbajo:
    sw $t2,0($t0)
    addi $t0,$t0,4
    addi $t1,$t1,-1
    bnez $t1,pintarBordeAbajo #si no es 0 sigue pintando

la $t0,pantalla
addi $t1,$zero,256

pintarBordeIzq:
    sw $t2,0($t0)
    addi $t0,$t0,256
    addi $t1,$t1,-1
    bnez $t1, pintarBordeIzq

la $t0,pantalla
addi $t0, $t0,508
addi, $t1,$zero,255

pintarBordeDere:
    sw $t2,0($t0)
    addi $t0, $t0,256
    addi $t1,$t1,-1
    bnez $t1,pintarBordeDere
