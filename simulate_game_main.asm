
# Simulate game03.txt - results in a win (some invalid moves in the moves[] array)
.data
filename: .asciiz "game03.txt"
### Deck ###
# Garbage values
deck: .word 19298388 25838983
### Board ###
# Garbage values
.data
.align 2
board:
.word card_list390186 card_list780261 card_list921603 card_list794887 card_list563648 card_list958108 card_list960311 card_list876269 card_list132614 
# column #7
.align 2
card_list876269:
.word 305340  # list's size
.word 813835 # address of list's head
# column #0
.align 2
card_list390186:
.word 712038  # list's size
.word 150979 # address of list's head
# column #2
.align 2
card_list921603:
.word 82184  # list's size
.word 864821 # address of list's head
# column #1
.align 2
card_list780261:
.word 701247  # list's size
.word 246378 # address of list's head
# column #8
.align 2
card_list132614:
.word 408168  # list's size
.word 386388 # address of list's head
# column #6
.align 2
card_list960311:
.word 687795  # list's size
.word 809975 # address of list's head
# column #5
.align 2
card_list958108:
.word 321036  # list's size
.word 153239 # address of list's head
# column #4
.align 2
card_list563648:
.word 543893  # list's size
.word 406018 # address of list's head
# column #3
.align 2
card_list794887:
.word 658005  # list's size
.word 59936 # address of list's head
# Garbage values
moves: .ascii "HkoF5VhgtOlSbFUXO7QzoJOZoYNB6T3eYrqJtrp9jNnmaQT5fAGtFelDuGeBItgWCObjqviCZVUD2thSFEwx2how97SqrKHfgaPTwx1CCyjlplPRvnUCWj0XRJpVZBxykqKx14XzISBRPaT6oEoRMoj9MwCZTNuTaPDvDQdpbqiZrlFlQXP6kpHilPrYzJEdyKAqYSQuYieoVXCPt5f6xk9Ar8XDIVENcdpjDXBogHFc62N1N6Yx2i8mobS9eeGIGEIOFsO7muZzZOPmHNn0mcQRH4mO3tr3EsiI0zuipje8xOo9xgNC2dTWbxNW2KcPNz9UXVvPgkOm0X930tPApCLOtmLvs7ELSXRq6OFxGLxkDFHePijOBVdQxzRFPnnvbnPok3NiqpBi6LGyyVm6aeVOL9TM5o96Qkpd3FvvnRzzJ96eItPXy8Sl1KBluowIULLRclWBOvXDYThbFbN7SdzekT8givPm4qpmWpCbceGnEvJiSkV9FVELQNphBgDeQVw23Q4e"











.text
.globl main
main:
la $a0, filename
la $a1, board
la $a2, deck
la $a3, moves
jal simulate_game

# Write code to check the correctness of your code!
	move $a0, $v0
	li $v0, 1
	syscall
	move $a0, $v1
	li $v0, 1
	syscall
li $v0, 10
syscall

.include "hwk5.asm"
