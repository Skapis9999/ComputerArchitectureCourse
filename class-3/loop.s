.data

array_a:
        .space  1000            # 250 integers

strSize:
        .asciiz "Enter array size (maximum 250)\n"

strInp:
        .asciiz "Enter next number (element "


.text
# Entry point for program (main function)
main:
        # $s1 contains pointer to array
        la      $s1, array_a

        # initialize i in $t1
        li      $t0, 0

        # display line to input size
        addi    $v0, $0, 4
        la      $a0, strSize
        
        syscall

        # get array size
        addi    $v0, $0, 5
        syscall

        # $s0 contains array size
        move    $s0, $v0

initlp: beq     $t0, $s0, initdn  # jump if loop finished

        # Display line for next element input
        addi    $v0, $0, 4
        la      $a0, strInp
        syscall

        # Display i
        addi    $v0, $0, 1
        move    $a0, $t0
        syscall

        # Display right parentheses
        addi    $v0, $0, 11
        li      $a0, 41
        syscall

        # Change line
        addi    $v0, $0, 11
        li      $a0, 10
        syscall

        # Get user input (element a[i])
        addi    $v0, $0, 5
        syscall

        # store input number in a[i]
        sw      $v0, ($s1)

        # move array pointer
        addi    $s1, $s1, 4

        # increase i
        addi    $t0, $t0, 1

        # loop
        b       initlp

initdn:
        # prepare arguments
        la      $a0, array_a
        move    $a1, $s0
        jal     printArray

        li      $v0, 10
        syscall



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
         addi   $v0, $0, 11
         li     $a0, 32
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

         jr     $ra
