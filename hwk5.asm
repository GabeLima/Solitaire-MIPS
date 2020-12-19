# erase this line and type your first and last name here in a comment
# erase this line and type your Net ID here in a comment (e.g., jmsmith)
# erase this line and type your SBU ID number here in a comment (e.g., 111234567)

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

init_list:
	move $t0, $a0 #card_list
	li $t1, 0
	sw $t1, 0($t0) #size = 0
	sw $t1, 4($t0) #head = 0
   jr $ra

append_card:
	move $t0, $a0 #card list
	move $t1, $a1 #card num
	#increment list size
	lw $t2, 0($t0) #loads size
	beqz $t2, empty_cardlist_case
	addi $t2, $t2, 1
	sw $t2, 0($t0) #increments size and stores it
	li $t4, '\0'
	move $t3, $t0 #used for the list iteration
	load_loop:
		lw $t2, 4($t3) #loads the address of the node
		beq $t2, $t4, found_null_terminator
		move $t3, $t2 #update the address if its not null...
		j load_loop
	found_null_terminator:
		li $a0, 8
		li $v0, 9
		syscall #SYSCALL 9 to store it!
		sw $v0, 4($t3) #stores the address at the proper location, no longer null
		sw $t1, 0($v0) #stores the card number at the new tail address
		sw $t4, 4($v0) #stores the null terminated character at the new tail address
		lw $v0, 0($t0) #loads size to RETURN
   		jr $ra
	empty_cardlist_case:
		addi $t2, $t2, 1
		sw $t2, 0($t0)
		li $a0, 8
		li $v0, 9
		syscall #SYSCALL 9 to store it!
		sw $v0, 4($t0) #address of new card head
		sw $t1, 0($v0) #store the card number!
		li $t9, '\0'
		sw $t9, 4($v0) #store the null terminated character!
		jr $ra
create_deck:
	addi $sp, $sp, -20 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	li $a0, 8
	li $v0, 9
	syscall
	move $a0, $v0 #address of the allocated memory we just made
	move $s0, $v0 #stores the address across a jal
	jal init_list #size = 0, head = 0
	li $t0, '\0'
	sw $t0, 4($s0) #null terminator just in case?
	#li $t0, 80
	#sw $t0, 0($s0) #size of entire thing = 80
	li $s2, 0 #keeps track of eight loop iterations
	eight_loop:
		li $t5, 9
		addi $s2, $s2, 1
		beq $s2, $t5, done_eight_loop
		li $s1, 6574896 #decimal rep of 0Sd
		li $s3, 0 #keep track of how many times we're aboutta loop in ten loop
		j ten_loop
		ten_loop: #s0 = card list, s1 = card num
			move $a0, $s0 #card list
			move $a1, $s1 #card number
			jal append_card
			addi $s1, $s1, 1 #increment card number
			addi $s3, $s3, 1 #increment how many times we've looped within the ten loop
			li $t3, 10
			blt $s3, $t3, ten_loop
			j eight_loop
	done_eight_loop:	
		# lw $a0, 0($s0) #gonna print the size
		# li $v0, 1
		# syscall	
		move $v0, $s0 #a pointer to a CardList of CardNode objects 
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20 #save s registers on stack
   jr $ra

deal_starting_cards:
	addi $sp, $sp, -28 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0 #array of pointers to 9 empty CardList structs
	move $s1, $a1 #Cardlist deck
	
	move $s2, $s0 #gonna mess with the addresses
	move $s3, $s1 #gonna mess with the deck
	lw $s3, 4($s3) #gets the head to start off with
	li $s5, 0 #keep track of rows
	j first_35_facedown
	first_35_facedown:
		move $s2, $s0 #reset the starting address
		li $s4, 0 #will keep track of the column we're on
		addi $s5, $s5, 1
		li $t0, 4
		blt $s5, $t0, loop_through_9_columns
		beq $s5, $t0, loop_through_8_columns
		loop_through_9_columns:
			lw $a0, 0($s2) #card_list
			lw $a1, 0($s3) #card number
			jal append_card
			lw $s3, 4($s3) #get the next card for the next iteration
			addi $s4, $s4, 1
			addi $s2, $s2, 4
			li $t0, 9
			blt $s4, $t0, loop_through_9_columns
			j first_35_facedown
		loop_through_8_columns:
			lw $a0, 0($s2) #card_list
			lw $a1, 0($s3) #card number
			jal append_card
			lw $s3, 4($s3) #get the next card for the next iteration
			addi $s4, $s4, 1
			addi $s2, $s2, 4
			li $t0, 8
			blt $s4, $t0, loop_through_8_columns
			j place_one_then_8
	place_one_then_8:
		lw $a0, 0($s2) #card_list
		lw $a1, 0($s3) #card number
		li $t0, 0x00110000
		add $a1, $a1, $t0
		# addi $a1, $a1, 1114112 #make a down card an up card								
		jal append_card
		lw $s3, 4($s3) #get the next card for the next iteration
		move $s2, $s0 #reset the starting address
		li $s4, 0 #keep track of column we're on
		li $t0, 8
		j loop_through_8_columns_up
		loop_through_8_columns_up:
			lw $a0, 0($s2) #card_list
			lw $a1, 0($s3) #card number
			li $t0, 0x00110000
			add $a1, $a1, $t0
			# addi $a1, $a1, 0x00110000
			# addi $a1, $a1, 1114112 #make a down card an up card							
			jal append_card
			lw $s3, 4($s3) #get the next card for the next iteration
			addi $s4, $s4, 1
			addi $s2, $s2, 4
			li $t0, 8
			blt $s4, $t0, loop_through_8_columns_up
			j alter_deck_head
	alter_deck_head: #s3 holds the new head address, need to alter the deck size
		sw $s3, 4($s1) #the deck
		lw $s3, 0($s1) #loads the size off the deck										
		addi $s3, $s3, -44
		sw $s3, 0($s1)														
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28 #save s registers on stack
   		jr $ra	

get_card:
	move $t0, $a0 #card list
	move $t1, $a1 #index we want
	
	lw $t2, 0($t0) #loads the size
	bge $t1, $t2, invalid_index_get_card
	move $t2, $t0 #gonna use to iterated over card list
	li $t3, -1 #will keep track of how many times we looped
	get_index_loop:
		addi $t3, $t3, 1
		lw $t2, 4($t2)
		beq $t3, $t1, got_card
		j get_index_loop
	
	got_card:
		lw $v1, 0($t2) #the number stored at the address
		li $t4, 0x00700000
		bgt $v1, $t4, face_up_card
		j face_down_card
	face_down_card:
		li $v0, 1
		j return_get_card
	face_up_card:
		li $v0, 2
		j return_get_card
	invalid_index_get_card:
		li $v0, -1
		li $v1, -1
		j return_get_card
	return_get_card:
    		jr $ra

check_move:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board[]
	move $s1, $a1 #deck
	move $s2, $a2 #move
	##################
	li $t5, 256
	div $s2, $t5
	mflo $s2
	mfhi $t0 #byte 0 DONOR COLUMN
	div $s2, $t5
	mflo $s2
	mfhi $t1 #byte 1 DONOR ROW
	div $s2, $t5
	mflo $s2
	mfhi $t2 #byte 2 RECIP COL
	div $s2, $t5
	mflo $s2
	mfhi $t3 #byte 3  00 OR 01
	addi $sp, $sp, -16 #store the t registers on the stack for later
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	
	li $t4, 1
	beq $t3, $t4, check_for_deal_move_parameter_error
	beqz $t3, check_normal_move_paramter_errors
	j deal_move_parameter_error
	
	
	check_for_deal_move_parameter_error: #ERRROR -1
		bnez $t0, deal_move_parameter_error
		bnez $t1, deal_move_parameter_error
		bnez $t2, deal_move_parameter_error
		j check_illegal_deal_move_error
	check_illegal_deal_move_error: #ERROR -2
		#lw $t4, 4($s1) #will be a null terminator if the deck is empty
		#li $t5, '\0'
		lw $t4, 0($s1) #loads the size of the dekc
		beqz $t4, illegal_deal_move_error
		#beq $t5, $t4, illegal_deal_move_error
		#check if any of the columns are empty
		move $s3, $s0 #gonna be iterating over the board
		li $s4, 8												
		li $s5, 0 #keep track of counting how many loops we've done
		loop_over_board_check_illegal:
			move $a0, $s3 #board
			lw $a0, 0($a0) #cardlist at the board[col]
			lw $t9, 0($a0) #loads the size 
			beqz $t9, illegal_deal_move_error
			addi $s3, $s3, 4 #go to the next card
			addi $s5, $s5, 1
			blt $s5, $s4, loop_over_board_check_illegal
			j legal_deal_move
	check_normal_move_paramter_errors: #ERROR -3
		li $t4, 8
		bltz $t0, illegal_column_range
		bltz $t2, illegal_column_range
		bgt $t0, $t4, illegal_column_range
		bgt $t2, $t4, illegal_column_range
		j check_donor_row
		
	check_donor_row: #ERROR -4
		bltz $t1, illegal_donor_row
		li $t4, 4
		mul $t5, $t4, $t0 # 4 * donor column to get board[donor column]
		add $t5, $t5, $s0 #gets board [donor column]
		lw $t6, 0($t5) #loads the cardlist of the column
		lw $t6, 0($t6) #gets the size of this column
		bge $t1, $t6, illegal_donor_row #if the donor row is >= to the size, its invalid.	
		j check_same_col_values
	check_same_col_values: #ERROR -5
		beq $t0, $t2, illegal_same_column_value
		j check_face_down_donating_card
		
	check_face_down_donating_card: #ERROR -6
		li $t4, 4
		mul $t5, $t4, $t0 # 4 * donor column to get board[donor column]
		add $t5, $t5, $s0 #gets board [donor column]
		lw $a0, 0($t5) #card list
		move $a1, $t1 #row
		jal get_card
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		li $t4, 0x00700000
		blt $v1, $t4, illegal_face_down
		j check_descending_donating_cards
		
	check_descending_donating_cards: #ERROR -7
		li $t4, 4
		mul $t5, $t4, $t0 # 4 * donor column to get board[donor column]
		add $t5, $t5, $s0 #gets board [donor column]
		move $s3, $t5 #store it across a get_card
		lw $s4, 0($s3) #gets the cardlist at s3
		lw $s4, 0($s4) #stores the size of the card_list column
		move $s5, $t1 #stores the row we're starting at across get_card... gonna use to increment
		lw $a0, 0($s3)#card list
		#move $a0, $s3
		#addi $s5, $s5, 1
		move $a1, $s5 #row we're getting
		jal get_card
		move $s6, $v1 #gives us the starting card stored in s6
		move $s7, $s6 #FOR NEXT OPERATION, JUST SAVE IT (error code #8)
		addi $s6, $s6, 1 #loop purposes...
		get_card_loop_descending:
			#move $a0, $s3
			lw $a0, 0($s3)
			move $a1, $s5 #row we're getting
			jal get_card
			addi $s6, $s6, -1
			bne $s6, $v1, illegal_descent_order #expected card vs actual card we grabbed
			addi $s5, $s5, 1
			blt $s5, $s4, get_card_loop_descending #as long as we're less than the total size, keep grabbing!
			#if it makes it here its a valid descending order... fix the damn t registers
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			j check_recipient_column_validity
			
	check_recipient_column_validity: #ERROR -8
		li $t4, 4
		mul $t5, $t4, $t2 # 4 * recipient column to get board[recipient column]
		add $t5, $t5, $s0 #gets board [recipient column]
		lw $t6, 0($t5) 
		lw $t6, 0($t6) #size
		beqz $t6, legal_and_empty_recipient_column #size = 0, empty column
		#else get card value
		#move $a0, $t5
		lw $a0, 0($t5) #card list
		addi $t6, $t6, -1 #size -= 1... get the last card in the column
		move $a1, $t6
		jal get_card #s7 holds the card we're trying to add to this column
		#addi $v1, $v1, -1
		move $s7, $v1 #stores the last card in the col we're trying to add to
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
		li $t4, 4
		mul $t5, $t4, $t0 # 4 * conor col
		add $t5, $t5, $s0 #gets board [donor column]
		lw $t6, 0($t5) #card list at donor col
		move $a0, $t6 #card lsit
		move $a1, $t1 #row we're grabbing
		jal get_card
		addi $v1, $v1, 1
		beq $v1, $s7, legal_move_non_empty_recipient_column
		#else its not legal
		j illegal_rank_difference
	illegal_rank_difference:
		li $v0, -8
		j deallocate_stack_check_move
	illegal_descent_order:
		li $v0, -7
		j deallocate_stack_check_move
	illegal_face_down:
		li $v0, -6
		j deallocate_stack_check_move
	illegal_same_column_value:
		li $v0, -5
		j deallocate_stack_check_move
	illegal_donor_row:
		li $v0, -4
		j deallocate_stack_check_move
	illegal_column_range:
		li $v0, -3
		j deallocate_stack_check_move
	illegal_deal_move_error:
		li $v0, -2
		j deallocate_stack_check_move
	deal_move_parameter_error:
		li $v0, -1
		j deallocate_stack_check_move
	legal_deal_move:
		li $v0, 1
		j deallocate_stack_check_move
	legal_move_non_empty_recipient_column:
		li $v0, 3
		j deallocate_stack_check_move
	legal_and_empty_recipient_column:
		li $v0, 2
		j deallocate_stack_check_move
	deallocate_stack_check_move:
		addi $sp, $sp, 16 #get rid of t registers first
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
   		jr $ra

clear_full_straight:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
		
	move $s0, $a0 #board
	move $t0, $a1 #col number
	bltz $t0, invalid_col_number
	li $t1, 8
	bgt $t0, $t1, invalid_col_number
	#else its a valid col number
	li $t1, 4
	mul $t2, $t1, $t0 #col number * 4
	add $s0, $s0, $t2 #board at the column number we want.
	
	
	lw $s1, 0($s0) #loads the actual column into s1
	lw $s2, 0($s1) #column size
	li $t1, 10
	blt $s2, $t1, too_small_to_clear #col size < 10
	move $a0, $s1 #a0 holds the card_list
	addi $s2, $s2, -1 #											
	move $a1, $s2 #get the last card 
	jal get_card# get the last card
	move $s3, $v1 #s3 holds the starting card value
	li $t4, 0x00700000
	blt $s3, $t4, cannot_clear_straight
	addi $s2, $s2, -1 #get the last card -1
	li $s4, 9 #gotta loop through 9 more times
	j attempt_to_clear
	attempt_to_clear:
		move $a0, $s1 #a0 holds the cardlist
		move $a1, $s2 #get the last card-ith loop
		jal get_card
		addi $s3, $s3, 1
		bne $s3, $v1, cannot_clear_straight
		addi $s2, $s2, -1 #decrement card we're grabbing
		addi $s4, $s4, -1
		bgtz $s4, attempt_to_clear
		#else we're done clearing
		addi $s2, $s2, 1 #go from 0 indexing back to regular indexing
		move $t0, $s1 #for next method purposes
		sw $s2, 0($s1) #store the new size in the card_list
		beqz $s2, clear_entire_list
		addi $s2, $s2, -1
		j clear_remaining_cards
		
	clear_entire_list: #the size is already = 0, just set the pointer of the head to 0
		li $t0, '\0'
		sw $t0, 4($s1) #head = 0
		#lw $a0, 0($t0)	
		j column_empty_of_cards
	clear_remaining_cards: #s2 holds the card number which should become the tail now... aka set the tails pointer to null
		lw $t0, 4($t0) #gets the head to start off with... then the next node...
		addi $s2, $s2, -1
		bgez $s2, clear_remaining_cards #if s2 is >= 0, keep getting the next address
		#s2 = 0, set this ones tail to null
		#lw $a0, 0($t0)											
		#li $v1, 34
		#syscall													
		li $t1, '\0'
		sw $t1, 4($t0) #sets next pointer to null
		lw $t1, 0($t0) #load the card value								
		li $t9, 0x00700000
		blt $t1, $t9, add_offset_and_cry
		j return_here_after_crying
		add_offset_and_cry:
			li $t9, 0x00110000
			add $t1, $t1, $t9
			sw $t1, 0($t0)
		return_here_after_crying:
		#lw $t0, 0($s1) #grab the size again
		#beqz $t0, column_empty_of_cards
		j at_least_one_card_in_col
	column_empty_of_cards:
		li $v0, 2
		j deallocate_stack_clear_full_straight
	at_least_one_card_in_col:	
		li $v0, 1
		j deallocate_stack_clear_full_straight
	invalid_col_number:
		li $v0, -1
		j deallocate_stack_clear_full_straight
	too_small_to_clear:
		li $v0, -2
		j deallocate_stack_clear_full_straight
	cannot_clear_straight:
		li $v0, -3
		j deallocate_stack_clear_full_straight
	deallocate_stack_clear_full_straight:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24
    		jr $ra

deal_move:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)

	move $s0, $a0 #board[] pointer
	move $s1, $a1 #cardlist deck
					lw $t9, 0($s1) #loads the size of the deck#test 
	move $s2, $s1 #c0py deck 
	#lw $s2, 0($s1) #load start of deck
	li $s3, 0 #keep track of how many times we looped through the column
	#lw $s0, 0($s0) #loads the pointer to start off with...
	nine_column_loop:	
		lw $a0, 0($s0) #send the proper pointer into the fn #this is right
		lw $s2, 4($s2) #loads the card address
		lw $a1, 0($s2) #loads the card number
		#gotta add the offset to make it an up-facing card
		li $t4, 0x00700000
		blt $a1, $t4, add_offset_and_return
		j return_here_after_offset
		add_offset_and_return:	
			li $t1, 0x00110000								
			add $a1, $a1, $t1 #goes from down facing to upfacing
			sw $a1, 0($s2)
		return_here_after_offset:
		jal append_card
		#lw $s2, 4($s2) #get the next card addresss
		addi $s0, $s0, 4 #updates which board[col] we're getting
		addi $s3, $s3, 1 #update loop counter
		li $t1, 9
		blt $s3, $t1, nine_column_loop
		j remove_cards_from_deck
		
		
		remove_cards_from_deck: #s2 holds the new head of the list
		lw $s2, 4($s2) #loads the card address #Increment card by one											
		sw $s2, 4($s1) #updates the head, essentially removing every other card.... #gotta update the size
		lw $s2, 0($s1) #grabs the size											
		addi $s2, $s2, -9 #decrements it by the 9 cards we added
		sw $s2, 0($s1) #stores the new size									
		j deallocate_stack_deal_move
		
		
		deallocate_stack_deal_move:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
  		jr $ra

move_card:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #board[]
	move $s1, $a1 #deck
	move $s2, $a2 #move
	
	jal check_move
	bltz $v0, some_illegal_move
		li $t5, 256
		div $s2, $t5
		mflo $s2
		mfhi $s3 #byte 0 DONOR COLUMN = s3
		div $s2, $t5
		mflo $s2
		mfhi $s4 #byte 1 DONOR ROW = s4
		div $s2, $t5
		mflo $s2
		mfhi $s2 #byte 2 RECIPIENT COLUMN = s2
	li $t0, 1
	beq $v0, $t0, legal_deal_move_card
	j legal_move_recip_empty
	
	legal_deal_move_card:
		move $a0, $s0 #board
		move $a1, $s1  #deck
		jal deal_move
		li $v0, 1
		j attempt_clear_on_board
	legal_move_recip_empty:
		
		#get to board[donor col], we have s5, s6, and s7 to work with
		li $t0, 4
		mul $t0, $t0, $s3 # 4 * donor col
		move $s5, $s0 #copy board[], s5 will denote donor col
		add $s5, $s5, $t0 # s5 = board[donor col]
		lw $s5, 0($s5) #s5 = card_list at DONOR col
		lw $s6, 0($s5) #s6 = donor col size
		li $t0, -1 #used to keep track of loop
		get_to_starting_row_loop:
			lw $s5, 4($s5) #gets next address node... starting with head
			addi $t0, $t0, 1 #increemnts t0 by 1... starts at -1 to account for starting row being the head
			blt $t0, $s4, get_to_starting_row_loop
			#else we made it to the starting node
			j starting_node_to_size
		starting_node_to_size:
			li $t0, 4
			mul $t0, $t0, $s2 # 4 * recipient column
			move $s7, $s0 #copy the board[]
			add $s7, $s7, $t0 #get pointer to board[recip ocl]
			lw $s7, 0($s7) #get the actual card_list at recip col
			sub $s6, $s6, $s4 #S6 DENOTES HOW MANY TIMES WE HAVE TO DO THE BELOW LOOP, S4 IS PRESERVED AS A RESULT
			starting_node_to_size_loop:
				move $a0, $s7 #card lsit of recip col
				lw $a1, 0($s5) #the card value at the node
				jal append_card
				addi $s6, $s6, -1
				blez $s6, done_with_append_card_loop
				lw $s5, 4($s5) #loads next node
				j starting_node_to_size_loop
				
			done_with_append_card_loop: #S4 HOLDS THE NEW SIZE, THE NODE AT S4-1 IS THE NEW TAIL
				li $t0, 4
				mul $t0, $t0, $s3 # 4 * donor col
				move $s5, $s0 #copy board[], s5 will denote donor col
				add $s5, $s5, $t0 # s5 = board[donor col]
				lw $s5, 0($s5) #gets the actual card_list
				sw $s4, 0($s5) #stores the updated size
				li $t0, -1 #loop tracker
				addi $s4, $s4, -1
				find_new_tail_loop:
					lw $s5, 4($s5) #loads new node starting wth head
					addi $t0, $t0, 1
					blt $t0, $s4, find_new_tail_loop
					#else we're at the tail
					li $t0, '\0'
					sw $t0, 4($s5) #set the address pointer at the tail to null.
					lw $t1, 0($s5) #loads the value at tail
					li $t2, 0x00700000
					blt $t1, $t2, flip_tail_upside
					j attempt_clear_on_board
					
					flip_tail_upside:
						li $t3, 0x00110000
						add $t1, $t1, $t3 #goes from down to up
						sw $t1, 0($s5)
						j attempt_clear_on_board
						
	attempt_clear_on_board:
		li $s3, 0 #keep track of the loop, act as col_num
		attempt_clear_loop:
			move $a0, $s0 #board[]
			move $a1, $s3 #col num
			jal clear_full_straight
			addi $s3, $s3, 1
			li $t0, 9
			blt $s3, $t0, attempt_clear_loop
	li $v0, 1
	j deallocate_stack_move_card
	
	#legal_move_recip_non_empty:
	
	some_illegal_move:
		li $v0, -1
		j deallocate_stack_move_card
	deallocate_stack_move_card:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
    		jr $ra

load_game:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #string filename
	move $s1, $a1 #board[]
	move $s2, $a2 #Deck
	move $s3, $a3 #int[] moves
	#lw $s3, 0($s3) #go from pointer to the actual buffer
	
	move $a0, $s0 #load the filename into a0
	li $a1, 0 #flag to read the file
	li $a2, 0 # mode is ignore
	li $v0, 13 #open the file
	syscall
	#if the file descriptor is -1 jump
	move $s4, $v0 #s4 saves file descriptor
	bltz $s4, couldnt_open_file
	
	move $a0, $s2 #card_list dekc
	jal init_list #initialize deck
	read_starting_deck_loop:
	###############################
		li $t1, '\n' #character to skip over	
		addi $sp, $sp, -1 #make space on the stack
		move $a0, $s4 #file descriptor
		move $a1, $sp #where we save the byte
		li $a2, 1 #1 character at a time
		li $v0, 14
		syscall
		lb $t4, 0($sp) #grabs what we read and stores it in t4
		addi $sp, $sp, 1
		beq $t4, $t1, done_reading_deck
		#else its a valid pair... load next and jal append card to deck
		addi $sp, $sp, -1 #make space on the stack
		move $a0, $s4 #file descriptor
		move $a1, $sp #where we save the byte
		li $a2, 1 #1 character at a time
		li $v0, 14
		syscall
		lb $t5, 0($sp) #grabs what we read and stores it in t5
		addi $sp, $sp, 1
		addi $sp, $sp, -4
		#T4 HOLDS number, T5 holds up/down
		li $t6, 'S'
		sb $t4, 0($sp) #store number at byte 0
		sb $t6, 1($sp) #store S at byte 1
		sb $t5, 2($sp) #store u/d at byte 2
		li $t7, 0
		sb $t7, 3($sp)
		
		move $a0, $s2 #cardlist deck
		lw $a1, 0($sp) #load card into a1
		addi $sp, $sp, 4#deallocate stack
		jal append_card
		j read_starting_deck_loop
		#############
	done_reading_deck:
		#lw $s7, 0($s2) #checks the size of the deck
		li $s7, 0
		li $t1, '\n' #character to skip over	
		addi $sp, $sp, -1 #make space on the stack
		move $a0, $s4 #file descriptor
		move $a1, $sp #where we save the byte
		li $a2, 1 #1 character at a time
		li $v0, 14
		syscall #we're gonna check if the first one is /n or not
		lb $t4, 0($sp) #grabs what we read and stores it in t4
		beq $t4, $t1, done_reading_moves
		addi $t4, $t4, -48
			#li $t9, 10
			#mul $t4, $t4, $t9
			#mul $t4, $t4, $t9
			#mul $t4, $t4, $9 # t4 *= 1000
		#else read the next 3
		move $a0, $s4 #file descriptor
		move $a1, $sp #where we save the byte
		li $a2, 1 #3 character at a time
		li $v0, 14
		syscall #we're gonna check if the first one is /n or not
		lb $t5, 0($sp)
		addi $t5, $t5, -48
		#mul $t5, $t5, $t9
		#mul $t5, $t5, $t9 #t5 *= 100
		#add $t4, $t4, $t5 # 1000 + 100
		
		move $a0, $s4 #file descriptor
		move $a1, $sp #where we save the byte
		li $a2, 1 #3 character at a time
		li $v0, 14
		syscall #we're gonna check if the first one is /n or not
		lb $t6, 0($sp)
		addi $t6, $t6, -48
		#mul $t5, $t5, $t9 #t5 *= 10
		#add $t4, $t4, $t5 # 1000 + 100 + 10
		
		move $a0, $s4 #file descriptor
		move $a1, $sp #where we save the byte
		li $a2, 1 #3 character at a time
		li $v0, 14
		syscall #we're gonna check if the first one is /n or not
		lb $t7, 0($sp)
		addi $t7, $t7, -48
		#add $t4, $t4, $t5 # 1000 + 100 + 10 + 1
		addi $sp, $sp, 1 #deallocates mini stack
		addi $sp, $sp, -4
		sb $t4, 0($sp)
		sb $t5, 1($sp)
		sb $t6, 2($sp)
		sb $t7, 3($sp)
		lw $t7, 0($sp)
		addi $sp, $sp, 4
		sw $t7, 0($s3) #stores the first move in the move array
		addi $s3, $s3, 4 #increment moves[i] to store the next...
		addi $s7, $s7, 1 #increment number moves we added
		load_one_then_four_loop:
			li $t1, '\n' #character to skip over
			addi $sp, $sp, -1 #make space on the stack
			move $a0, $s4 #file descriptor
			move $a1, $sp #where we save the byte
			li $a2, 1 #1 character at a time
			li $v0, 14
			syscall #we're gonna check if the first one is /n or not
			lb $t4, 0($sp) #grabs what we read and stores it in t4
			beq $t1, $t4, done_reading_moves
			addi $sp, $sp, 1
			addi $sp, $sp, -4
			#else we read the next 4 more characters then start the loop again...
			move $a0, $s4 #file descriptor
			move $a1, $sp #where we save the byte
			li $a2, 4 #4 character at a time
			li $v0, 14
			syscall #we're gonna check if the first one is /n or not
			
			lb $t4, 3($sp)
			addi $t4, $t4, -48
			lb $t5, 2($sp)
			addi $t5, $t5, -48
			lb $t6, 1($sp)
			addi $t6, $t6, -48
			lb $t7, 0($sp)
			addi $t7, $t7, -48
			
			sb $t4, 3($sp)
			sb $t5, 2($sp)
			sb $t6, 1($sp)
			sb $t7, 0($sp)
			lw $t7, 0($sp)
			
			
			
			#li $t8, 1000
         	 	#mul $t7, $t7, $t8 # 1000
          		#li $t8, 100
           		#mul $t6, $t6, $t8 # 100
            		#add $t7, $t7, $t6 #1000 + 100
            		#li $t8, 10
            		#mul $t5, $t5, $t8 # 10
            		#add $t7, $t7, $t5 #1000 + 100 + 10
           		#add $t7, $t7, $t4 #1000 + 100 + 10 + 1

            		sw $t7, 0($s3) #stores it in the moves[]
            		#lw $t7, 0($s3) #sanity check												
			#sw $t4, 0($s3) #stores it in the moves[]	
			addi $s3, $s3, 4 #increment moves[i] to store the next...
			addi $sp, $sp, 4 #deallocate the stack we made...
			addi $s7, $s7, 1 #increment number moves we added
			j load_one_then_four_loop
	done_reading_moves:
		addi $sp, $sp, 1 #deallocates mini stack
		#init list on entire board
		li $s5, -1 #keep track of which board[] col we're at
		init_list_board_loop:
			addi $s5, $s5, 1
			li $t8, 4
			mul $t8, $t8, $s5 #col * 4
			add $a0, $s1, $t8 #gets board[col]
			lw $a0, 0($a0) #gets the card_list at board[col]						
			jal init_list
			li $t8, 8
			blt $s5, $t8, init_list_board_loop
			j read_board_start_loop
		read_board_start_loop:
		li $s5, -1 #keep track of which board[] col we're at
		read_board_loop:
			addi $s5, $s5, 1
			li $t1, '\n' #character to skip over	
			addi $sp, $sp, -1 #make space on the stack						
			move $a0, $s4 #file descriptor
			move $a1, $sp #where we save the byte
			li $a2, 1 #1 character at a time
			li $v0, 14
			syscall
			beqz $v0, finished_reading_from_file
			lb $t4, 0($sp) #grabs what we read and stores it in t4
			beq $t4, $t1, start_new_line_loop
			li $t5, ' '
			beq $t5, $t4, read_next_dont_append
			addi $sp, $sp, 1									
			#else its a valid pair... load next and jal append card to deck
			addi $sp, $sp, -1 #make space on the stack						
			move $a0, $s4 #file descriptor
			move $a1, $sp #where we save the byte
			li $a2, 1 #1 character at a time
			li $v0, 14
			syscall
			lb $t5, 0($sp) #grabs what we read and stores it in t5
			addi $sp, $sp, 1									
			addi $sp, $sp, -4									
			#T4 HOLDS number, T5 holds up/down
			li $t6, 'S'
			sb $t4, 0($sp) #store number at byte 0
			sb $t6, 1($sp) #store S at byte 1
			sb $t5, 2($sp) #store u/d at byte 2
			li $t7, 0
			sb $t7, 3($sp)
			#move $a0, $s2 #cardlist deck
			li $t8, 4
			mul $t8, $s5, $t8 #t8 = 4 * board col
			add $a0, $t8, $s1 #loads pointer to board[col]
			lw $a0, 0($a0) #give a0 the proper pointer
			lw $a1, 0($sp) #load card into a1
			addi $sp, $sp, 4#deallocate stack							
			jal append_card
			j read_board_loop
			read_next_dont_append:
				move $a0, $s4 #file descriptor
				move $a1, $sp #where we save the byte
				li $a2, 1 #1 character at a time
				li $v0, 14
				syscall
				addi $sp, $sp, 1#deallocate stack						
				j read_board_loop
			start_new_line_loop:
				addi $sp, $sp, 1
				j read_board_start_loop
	finished_reading_from_file: #Gotta close file
		li $v0, 16
		move $a0, $s4 #file descriptor 
		syscall #clsoes the file out
		addi $sp, $sp, 1
		li $v0, 1 #file was opened successfully
		move $v1, $s7 #number moves
		j deallocate_stack_load_game
	couldnt_open_file:
		li $v0, -1
		li $v1, -1
		j deallocate_stack_load_game
	deallocate_stack_load_game:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
    		jr $ra

simulate_game:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #string filename
	move $s1, $a1 #board[]
	move $s2, $a2 #cardlist deck
	move $s3, $a3 #int[] moves
	
	jal load_game #everything is already loaded
	move $s4, $v1 #number of moves
	#test FN
	#move $a0, $s1
	#jal print_board_size
	#move $a0, $s1
	#li $a1, -1
	#jal print_entire_board
	
	bltz $v0, failed_to_load_game
	li $s5, 0 #will keep track of the number of legal moves we're doing
	j check_moves_loop
	check_moves_loop:
		beqz $s4, done_checking_moves
		move $a0, $s1 #board[]
		move $a1, $s2 #cardlist deck
		lw $a2, 0($s3) #int[] moves
		jal check_move
		bgtz $v0, some_legal_move_found
				#move $a0, $s1									
				#lw $a1, 0($s3) #int[] moves
				#jal print_entire_board									
		addi $s4, $s4, -1 #decrement number moves remaining by one
		addi $s3, $s3, 4 #go to next moves[i]
		j check_moves_loop
		
		some_legal_move_found: #move_card(board, deck, move)
				#move $a0, $s1									
				#lw $a1, 0($s3) #int[] moves
				#jal print_entire_board									
			move $a0, $s1 #board
			move $a1, $s2 #deck
			lw $a2, 0($s3) #int[] moves
			jal move_card
				#move $a0, $s1									
				#li $a1, 0 
				#jal print_entire_board									
			addi $s5, $s5, 1 #increment number valid moves done
			addi $s4, $s4, -1 #decrement number moves remaining by one
			addi $s3, $s3, 4 #go to next moves[i]
			li $s7, 0#used to determine where we return in check game loop
			j check_if_game_is_won
		
		check_if_game_is_won:
			move $s6, $s1 #copy of boards
			li $t0, 8 #max times we loop
			li $t1, -1
			iterating_board_loop:
				addi $t1, $t1, 1
				lw $t4, 0($s6)
				lw $t4, 0($t4) #loads size
				addi $s6, $s6, 4
				bnez $t4, check_moves_loop
				blt $t1, $t0, iterating_board_loop
				#check deck
				lw $t4, 0($s2) #loads size of deck
				beqz $t4, won_game
				beqz $s7, check_moves_loop
				j return_here_after_check_win
		check_if_game_is_won_after_moves:
			move $s6, $s1 #copy of boards
			li $t0, 8 #max times we loop
			li $t1, -1
			iterating_board_loop_num2:
				addi $t1, $t1, 1
				lw $t4, 0($s6)
				lw $t4, 0($t4) #loads size
				addi $s6, $s6, 4
				bnez $t4, return_here_after_check_win
				blt $t1, $t0, iterating_board_loop_num2
				#check deck
				lw $t4, 0($s2) #loads size of deck
				beqz $t4, won_game
				j return_here_after_check_win
	done_checking_moves:
			#li $s7, 1 #used to determine where we return in check game loop
			#move $a0, $s1
			#jal print_board_size
		j check_if_game_is_won_after_moves
		return_here_after_check_win: #implies the game was NOT won
			move $v0, $s5
			li $v1, -2
			j deallocate_stack_simulate_game
	won_game:
		move $v0, $s5
		li $v1, 1
		j deallocate_stack_simulate_game
	failed_to_load_game:
		li $v0, -1
		li $v1, -1
		j deallocate_stack_simulate_game
	deallocate_stack_simulate_game:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
   		jr $ra
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
