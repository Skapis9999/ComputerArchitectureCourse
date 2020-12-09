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
addi $sp, $sp, -40

sw $ra, 0($sp) 	# return address
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $a0, 32($sp)		# a0 = pointer of array = v[]
sw $a1, 36($sp)	  # 4*10 positions for the array are left. a1 = size of array = n
lw $s0, 32($sp)		# s0 = v[]
lw $s1, 36($sp)	  #	s1 = n

Startif:									#Begining of if clause
add $a0, $s0, $zero
add $a1, $s1, $zero		# Orismata tis partition

jal partition

move $s2, $v0         #i produced by parition : s2 = i
sw $v0, 40($sp)			  # i produced by partition

# qsort runs. Orismata to $a0 = v = $s0 and $a1 = p dld to i = $s2
move $a0, $s0
move $a1, $s2
#add $a0, $s0, $zero                    different way for last two orders
#add $a1, $s2, $zero
jal qsort

# We wish in $a0 the address of v[p+1] and in $a1 the n-p-1
# !!! t1 and t2 are never changed by me. They are used in if-clause !!!      ????                  ??????????????????????????????????????
sll $s3, $s2, 2			# s3 = p*4
addi $s3, $s3, 4      # s3 = (p+1)*4

add $s3, $s3, $s0			# t0 = v+((p+1)*4)
move $a0, $s3         # a0 = s3 = v+((p+1)*4)     1st orisma

sub $t5, $s1, $s2		# t5 = n-p
addi $t5, $t5, -1			# t5 = n-p-1
move $a1, $t5         #2nd orisma
jal qsort

addi $t0, $zero, 1		# t0 = 1 (if clause)
slt $t0, $s1, $t1     # if( t0 < s1 ) t1 = 1
beq $t1, $t0, Startif

lw $s6, 28($sp)
lw $s5, 24($sp)
lw $s4, 20($sp)
lw $s3, 16($sp)
lw $s2, 12($sp)
lw $s1, 8($sp)
lw $s0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 40		#Apothesmefsi mnimis

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
