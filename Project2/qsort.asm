	.globl	v #instrCount
	.data
	.align	2
v:
	.word	3
	.word	10
	.word	8
	.word	2
	.word	7
	.word	1
	.word	5
	.word	9
	.word	6
	.word	4
	.text
#instrCount:
#	.word 0
swap:
#$a2								2o stixeio
#$a1,            1o stixeio
#$a0          difthinsi pinaka
		sll $t0, $a1, 2					#k*4
		sll $t1, $a2, 2					#l*4

		add $t2, $a0, $t0			#t2 = v+k*4
		add $t3, $a0, $t1			#t3 = v+l*4

		lw $t4, 0($t2)				#t4=v[k]
		lw $t5, 0($t3)				#t5=v[l]

		sw $t5, 0($t2)
		sw $t4, 0($t3)
		    # <<YOUR-CODE-HERE>>
	j	$ra
	nop


partition:
	addiu	$sp,$sp,-52
	sw	$ra,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$v1,52($fp)
	li	$v0,1073676288			# 0x3fff0000
	ori	$v0,$v0,0xffff
	addu	$v0,$v1,$v0
	sll	$v0,$v0,2
	lw	$v1,48($fp)
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	sw	$v0,36($fp)
	sw	$0,28($fp)
	sw	$0,32($fp)
	b	part_loop
	nop

part_for:
	lw	$v0,32($fp)
	sll	$v0,$v0,2
	lw	$v1,48($fp)
	addu	$v0,$v1,$v0
	lw	$v1,0($v0)
	lw	$v0,36($fp)
	slt	$v0,$v1,$v0
	beq	$v0,$0,part_noswap
	nop

	lw	$v0,28($fp)
	addiu	$v1,$v0,1
	sw	$v1,28($fp)
	lw	$a2,32($fp)
	move	$a1,$v0
	lw	$a0,48($fp)

	jal	swap

part_noswap:
	lw	$v0,32($fp)
	addiu	$v0,$v0,1
	sw	$v0,32($fp)
part_loop:
	lw	$v0,52($fp)
	addiu	$v1,$v0,-1
	lw	$v0,32($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$0,part_for
	nop

	lw	$v0,52($fp)
	addiu	$v0,$v0,-1
	move	$a2,$v0								#2o stxeio
	lw	$a1,28($fp)            #1o stixio
	lw	$a0,48($fp)           #difthinsi pinaka

	jal	swap

	lw	$v0,28($fp)
	move	$sp,$fp
	lw	$ra,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,52
	j	$ra


qsort:
        # <<YOUR-CODE-HERE>>
	addi $sp, $sp, -106

	sw $ra, 54($sp) 	# return address
	sw $a0, 58($sp)		# a0 = pointer of array = v[]
	sw $a1, 102($sp)	# 4*10 positions for the array are left. a1 = size of array = n
	lw $t0, 58($sp)		# t0 = v[]
	lw $t1, 102($sp)	#	t1 = n

Startif:									#Begining of if clause
	add $a0, $t0, $zero
	add $a1, $t1, $zero		# Orismata tis partition

	jal partition

	sw $v0, 106($sp)			# i produced by partition
	lw $t4, 106($sp)			# t4 = i Ara p = t4
	# qsort runs. Orismata to $a0 = v = $t0 and $a1 = p = $t4
	add $a0, $t0, $zero
	add $a1, $t4, $zero
	jal qsort

	# We wish in $a0 the address of v[p+1] and in $a1 the n-p-1
	# !!! t1 and t2 are never changed by me. They are used in if-clause !!!
	lw $t0, 106($sp)		# t0 = p
	sll $t0, $t0, 2			# t0 = p*4

	lw $t3, 98($sp)				# t3 = v
	add $t0, $t0, $t3			# t0 = v+(p*4)

	lw $t4, 4($sp)				# t4 = v[p+1]
	la $a0, $t4						# a0 = &v[p+1]

	lw $t6, 102($sp)			# n
	lw $t7, 106($sp)			# p
	sub $t5, $t6, $t7			# t5 = n-p
	addi $t5, $t5, -1			# t5 = n-p-1
	addi $a1, $t5, $zero 	# 2nd orisma

	jal qsort

	addi $t3, $zero, 1		# t3 = 1 (if clause)
	slt $t2, $t3, t1
	beq $t2, $zero, Startif

	addi $sp, $sp, 106		#Apothesmefsi mnimis

	j	$ra

main:
	addiu	$sp,$sp,-40
	sw	$ra,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	li	$v0,10			# 0xa
        move    $s0, $v0
	sw	$v0,28($fp)
	lw	$a1,28($fp)																						##s0 was v0 which was 10 which is array's size.
        la      $a0, v																			#v is the array

        jal     printArray

        lw	$a1,28($fp)
        la      $a0, v

	jal	qsort

        la      $a0, v
        move    $a1, $s0
        jal     printArray

	move	$v0,$0
	move	$sp,$fp
	lw	$ra,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$ra


# printArray -- Function to print an array
#
# Inputs:
#       $a0:    Array pointer
#       $a1:    Array length
#
# Outputs:
#       (none)
#
printArray:
        # initialize i
        li     $t0, 0
        move   $t1, $a0

        # print [
        addi   $v0, $0, 11
        li     $a0, 91
        syscall

        # print space
        addi    $v0, $0, 11
        li      $a0, 32
        syscall



loopPrint:
        beq    $t0, $a1, loopEnd

        # print element a[i]
        li     $v0, 1
        lw     $a0, ($t1)
        syscall

        # print space
        addi   $v0, $0, 11
        li     $a0, 32
        syscall

        addi   $t1, $t1, 4
        addi   $t0, $t0, 1

        b      loopPrint


loopEnd:

        # print ]
        addi   $v0, $0, 11
        li     $a0, 93
        syscall

        move   $t0, $ra
        jal    printNewline
        move   $ra, $t0

        jr     $ra


# printNewline -- Print new line
#
# Inputs:
#       (none)
#
# Outputs:
#       (none)
#
printNewline:

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra
