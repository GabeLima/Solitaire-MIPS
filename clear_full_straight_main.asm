# Column contains a straight and some additional cards below
.data
.align 2
col_num: .word 0
##### Board #####
.data
.align 2
board:
.word card_list560132 card_list945704 card_list766049 card_list29596 card_list873231 card_list909275 card_list415041 card_list881161 card_list132232 
# column #4
.align 2
card_list873231:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #5
.align 2
card_list909275:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #8
.align 2
card_list132232:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #7
.align 2
card_list881161:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #2
.align 2
card_list766049:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #0
.align 2
card_list560132:
.word 13  # list's size
.word node639371 # address of list's head
node360076:
.word 7689011
.word node729581
node639371:
.word 6574898
.word node665618
node729581:
.word 7689010
.word node613023
node128258:
.word 7689008
.word 0
node518495:
.word 7689012
.word node360076
node832348:
.word 7689016
.word node828927
node665618:
.word 6574896
.word node6251
node630402:
.word 7689014
.word node638749
node941903:
.word 7689017
.word node832348
node638749:
.word 7689013
.word node518495
node6251:
.word 7689014
.word node941903
node828927:
.word 7689015
.word node630402
node613023:
.word 7689009
.word node128258
# column #3
.align 2
card_list29596:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #1
.align 2
card_list945704:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #6
.align 2
card_list415041:
.word 0  # list's size
.word 0  # address of list's head (null)


.text
.globl main
main:
la $a0, board
lw $a1, col_num
jal clear_full_straight

# Write code to check the correctness of your code!
	move $a0, $v0
	li $v0, 1
	syscall
li $v0, 10
syscall

.include "hwk5.asm"
