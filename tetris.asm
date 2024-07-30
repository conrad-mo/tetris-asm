#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Conrad Mo, 1009077302, moconrad, conrad.mo@mail.utoronto.ca
# Student2: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed) 
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# Hard Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# How to play:
# (Include any instructions)
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    	# Initialize the game
    	#li $t1, 0xff0000        # $t1 = red
    	#li $t2, 0x00ff00        # $t2 = green
    	li $t1, 0x0000ff        # $t3 = blue
    	li $t4, 0x808080	# $t4 = grey
    	li $t5, 0xC0C0C0	# $t5 = light grey
    	li $t6, 0x404040	# $t6 = dark grey
    	lw $t0, ADDR_DSPL
    
    	li $t7, 0
    	li $t3, 0
    	j checker_gen_loop
    	
    	li $v0, 10
    	syscall

checker_gen_loop:
	li $t8, 512
	bgt $t7, $t8, checker_gen_end
	li $t9, 32
	rem $t2, $t7, $t9
	beq $t2, 0, new_row
	beq $t3, 0, dark_first_checker_gen
	j light_first_checker_gen
	
new_row:
	xor $t3, $t3, 1
	beq $t3, 0, dark_first_checker_gen
	j light_first_checker_gen

dark_first_checker_gen:
	sw $t5, 0($t0)
	sw $t6, 4($t0)
	addi $t7, $t7, 1
	addi $t0, $t0, 8
	j checker_gen_loop

light_first_checker_gen:
	sw $t6, 0($t0)
	sw $t5, 4($t0)
	addi $t7, $t7, 1
	addi $t0, $t0, 8
	j checker_gen_loop

checker_gen_end:
	lw $t0, ADDR_DSPL
	li $t7, 0
	#j wall_gen_loop

wall_gen_loop:
	li $t8, 32
	bge $t7, $t8, wall_gen_end
	
	sw $t4, 0($t0)
	sw $t4, 124($t0)
	addi $t0, $t0, 128
	addi $t7, $t7, 1
	
	j wall_gen_loop
	
wall_gen_end:
	lw $t0, ADDR_DSPL
	addi $t0, $t0, 3968
	li $t7, 0
	j bot_wall_gen_loop

bot_wall_gen_loop:
	li $t8, 32
	bge $t7, $t8, bot_wall_gen_end
	
	sw $t4, 0($t0)
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	
	j bot_wall_gen_loop

bot_wall_gen_end:
    	#lw $t0, ADDR_DSPL
    	#li $t7, 4
    	#li $t9, 0
    	#j checker_gen_loop
    	j game_loop

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    #lw $t0, ADDR_DSPL
    #sw $t3, 120($t0)
    b game_loop
