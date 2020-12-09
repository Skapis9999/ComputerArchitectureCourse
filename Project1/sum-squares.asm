.data

strError:.asciiz "0x00000000DEADBEEF"

.text

############################################################
###     Enter your code here.
###     Write function squaredSum

# Function to calculate squared sum
#
# Inputs:
#       $a0: address of array in memory (*a)
#       $a1: array size (n)
#
# Outputs:
#       $v0: low 32 bytes of result
#       $v1: high 32 bytes of result
#
# If the array is empty, then the function returns zero.
#

squaredSum:

              addi      $sp, $sp,  -12     # adjust stack for 3 items
              sw        $s2, 8($sp)       # save $s2
              sw        $s3, 4($sp)       # save $s3
              sw        $s4, 0($sp)       # save $s4
              move      $s2, $a0          # $s2 = address of array in memory (*a)
              move      $s3, $a1          # $s3 = n (array size)

              #originate value for result and i
              li      $t0, 0              # $t0 = i = 0
              li      $t1, 0              # $t1 = result = 0
              beq     $s3, $zero, L1      # if ( n == 0 )
                          # else
        LOOP: sll     $t8, $t0, 2             #t8 = i * 4
              add     $t9, $s2, $t8           #t9 = &a[i]
              move    $s4, $t9                #save $s4
              mult    $s4, $s4                # square of a[i]
              add     $a2, $zero, $t1         # a2 = result
              mflo    $t4
              add     $a3, $zero, $t4         # a3 = square of a[i]
              jal     adduover                # result + $t4
              #sw      $s0, 0($sp)            #save $s0
              #sw      $s1, 4($sp)            #save $s1
              #add     $s0, $v0, $zero        # $s0 = addition without carry
              #add     $s1, $v1, $zero        # $s1 = carry
              addi    $t0, $t0, 1       #i++
              bne     $t0, $s3, Exit    # while i < n
              j LOOP
        Exit: slt     $t2, $v0, $zero
              beq     $t2, $zero, Exit2
              la      $a0, strError
              addi    $v0, $0, 4
              syscall

              jr      $ra
      Exit2:  slt     $t2, $v1, $zero
              beq     $t2, $zero, Exit3
              la      $a0, strError
              addi    $v0, $0, 4
              syscall

              jr      $ra
       Exit3: lw      $s4, 0($sp)       # Restore $s4 from stack
              lw      $s3, 4($sp)       # Restore $s3 from stack
              lw      $s2, 8($sp)       # Restore $s2 from stack
              addi    $sp, $sp, 12      # pop 3 items from stack
              jr      $ra               # and return


        L1:   add     $v0, $zero, $zero # $v0 = 0 if array is null
              add     $v1, $zero, $zero # $v1 = 0 if array is null
              lw      $s4, 0($sp)       # Restore $s4 from stack
              lw      $s3, 4($sp)       # Restore $s3 from stack
              lw      $s2, 8($sp)       # Restore $s2 from stack
              addi    $sp, $sp, 12      # pop 3 items from stack
              jr      $ra               # and return

adduover:     #addi    $sp, $sp, -8      # adjust stack for 2 items
              #move    $t5, $a3          # $t5 = square of a[i]
              #move    $t6, $a2          # $t6 = result
              add     $t7, $a3, $a2      # $t7 = $t5 + $t6
              slt     $t8, $t7, $a3      # a + b < a If(t7<a3)
              add     $v0, $zero, $t7    # addition without carry
              beq     $t8, $zero, L2     # a + b >= a
              add     $v1, $zero, 1
              jr      $ra               # and return

          L2: add     $v1, $zero, $zero
              lw      $s4, 0($sp)       # Restore $s4 from stack
              lw      $s3, 4($sp)       # Restore $s3 from stack
              lw      $s2, 8($sp)       # Restore $s2 from stack
              addi    $sp, $sp, 12      # pop 3 items from stack
              jr      $ra               # and return

###     squaredSum ending
############################################################

############################################################
###     DO NOT CHANGE ANYTHING BELOW !!!


.data
array_a:.space  1000            # 250 integers

strSize:.asciiz "Enter array size (maximum 250)"

strInp: .asciiz "Enter next number (element "

strPower: .asciiz " * 2^(32) + "

strHex: .asciiz "0x"


.text
# Entry point for program (main function)
main:

        # original values for *a and i
        la      $s1, array_a    # $s1 = *a
        li      $t0, 0          # $t0 = i

        # display line to input size
        la      $a0, strSize
        jal     printStringln

        # get array size
        addi    $v0, $0, 5      # user input
        syscall

        move    $s0, $v0        # s0 := n

initLoop:
        beq     $t0, $s0, initDone  # jump if loop finished

        # Display line for next element input
        la      $a0, strInp
        jal     printString

        move    $a0, $t0
        jal     printInteger

        li      $a0, 41         # ')'
        jal     printASCIIln

        # Get user input (element a[i])
        addi    $v0, $0, 5
        syscall

        sw      $v0, ($s1)      # store input number in a[i]

        addi    $s1, $s1, 4     # move array pointer
        addi    $t0, $t0, 1     # increase i
        b       initLoop        # loop

initDone:
        la      $a0, array_a    # first argument is array address
        move    $a1, $s0        # second argument is size of array
        jal     squaredSum      # call squaredSum

        move    $s0, $v0        # first return output LO
        move    $s1, $v1        # second return output HI

        la      $a0, strHex
        jal     printString
        move    $a0, $s1
        jal     printHEX
        move    $a0, $s0
        jal     printHEX
        jal     printNewline

        ## move    $a0, $s1
        ## jal     printInteger

        ## # print result
        ## la      $a0, strPower
        ## jal     printString

        ## move    $a0, $s0
        ## jal     printIntegerln

        # exit
        li      $v0, 10
        syscall


# printString -- Print input string to console
#
# Inputs:
#       $a0:    Memory address of string
#
# Outputs:
#       (none)
#
printString:

        # print input string
        addi    $v0, $0, 4
        syscall

        jr      $ra

# printStringln -- Print input string to console, followed by
#  new line
#
# Inputs:
#       $a0:    Memory address of string
#
# Outputs:
#       (none)
#
printStringln:

        # print input string
        addi    $v0, $0, 4
        syscall

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra

# printInteger -- Print input integer to console
#
# Inputs:
#       $a0:    Integer value
#
# Outputs:
#       (none)
#
printInteger:

        # print integer
        addi    $v0, $0, 1
        syscall

        jr      $ra

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

# printIntegerln -- Print input integer to console, followed
#  by new line
#
# Inputs:
#       $a0:    Integer value
#
# Outputs:
#       (none)
#
printIntegerln:

        # print integer
        addi    $v0, $0, 1
        syscall

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra

# printASCII -- Print input ASCII character to console
#
# Inputs:
#       $a0:    ASCII character to print
#
# Outputs:
#       (none)
#
printASCII:

        # print ASCII
        addi    $v0, $0, 11
        syscall

        jr      $ra

# printASCIIln -- Print input ASCII character to console, followed
#  by new line
#
# Inputs:
#       $a0:    ASCII character to print
#
# Outputs:
#       (none)
#
printASCIIln:

        # print ASCII
        addi    $v0, $0, 11
        syscall

        # print new line
        addi    $v0, $0, 11     # ASCII character print
        li      $a0, 10         # ASCII character new line
        syscall

        jr      $ra


# printHEX -- Print HEX represenation of word
#
# Inputs:
#       $a0:    Word to print
#
# Outputs:
#       (none)
#
printHEX:

        move    $t1, $a0
        li      $t3, 8

LoopHEX:
        beqz    $t3, ExitHEX
        rol     $t1, $t1, 4
        and     $t4, $t1, 0xf
        ble     $t4, 9, SumHEX
        addi    $t4, $t4, 55

        b       EndHEX

SumHEX:
        addi    $t4, $t4, 48

EndHEX:
        move    $a0, $t4

        # print ASCII
        addi    $v0, $0, 11
        syscall

        addi    $t3, $t3, -1

        j       LoopHEX

ExitHEX:

        jr      $ra
