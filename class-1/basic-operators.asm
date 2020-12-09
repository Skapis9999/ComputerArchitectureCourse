# simple example

.data
L1:     .word 0x2345            # arbitrary value
L2:     .word 0x33667           # arbitrary value
Res:    .space 4                # result

.text
.globl main

main:  lw       $t0, L1         # load first value

       la       $t3, L2         # load address of second
       lw       $t1, 0($t3)     # load second value
       
       or       $t2, $t0, $t1   # perform bitwise or
       sw       $t2, Res        # store result

       li       $v0, 1          # print result
       move     $a0, $t2
       syscall

       jr       $ra
