# simple example

.data
str:    .asciiz "Hello World!\n"

.text
.globl main

main:  	li      $v0, 4          # print string
	la      $a0, str        # load address of Hello World

	syscall
        
        jr      $ra             # jump to calling
