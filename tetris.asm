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
debug: .asciiz "Hello, MIPS World!\n"
debugtwo: .asciiz "??? done this\n"

##############################################################################
# Mutable Data
##############################################################################
location: .word 56, 184, 312, 440
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
    	li $t1, 0x0000ff        # $t1 = blue
    	li $t4, 0x808080	# $t4 = grey
    	li $t5, 0xC0C0C0	# $t5 = light grey
    	li $t6, 0x404040	# $t6 = dark grey
    	lw $t0, ADDR_DSPL
	
    	li $t7, 0
    	li $t3, 0
    	jal checker_gen_loop
    	
    	j game_loop

checker_gen_loop:
	li $t8, 512
	bgt $t7, $t8, checker_gen_end
	li $t9, 16
	rem $t2, $t7, $t9
	beq $t2, 0, new_row
	beq $t3, 0, dark_first_checker_gen
	j light_first_checker_gen
	
new_row:
	xor $t3, $t3, 1
	beq $t3, 0, dark_first_checker_gen
	j light_first_checker_gen

dark_first_checker_gen:
	sw $t6, 0($t0)
	sw $t5, 4($t0)
	addi $t7, $t7, 1
	addi $t0, $t0, 8
	j checker_gen_loop

light_first_checker_gen:
	sw $t5, 0($t0)
	sw $t6, 4($t0)
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

spawn_block:
	move $a0, $t0  # Move the value of $t0 into $a0
    	li $v0, 1      # Syscall code for print integer
    	syscall
	lw $t0, ADDR_DSPL
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	
	addi $sp, $sp, -16
	sw $s3, 0($sp)
	sw $s2, 4($sp)
	sw $s1, 8($sp)
	sw $s0, 12($sp)
	
	add $s0, $zero, $zero
	add $s1, $zero, $zero
	add $s2, $zero, $zero
	add $s3, $zero, $zero
	j game_loop

bot_wall_gen_end:
    	lw $t0, ADDR_DSPL
    	lw $t2, ADDR_KBRD
    	lw $t2, 60($t0)
    	#sw $t6, 0($t0)
    	#beq $t2, $t6, collide
    	
    	
    	addi $sp, $sp, -32
    	addi $t0, $t0, 60
    	lw $t2, 0($t0)
    	sw $t2, 16($sp)
    	lw $t0, ADDR_DSPL
    	addi $t0, $t0, 188
    	lw $t2, 0($t0)
    	sw $t2, 20($sp)
    	lw $t0, ADDR_DSPL
    	addi $t0, $t0, 316
    	lw $t2, 0($t0)
    	sw $t2, 24($sp)
    	lw $t0, ADDR_DSPL
    	addi $t0, $t0, 444
    	lw $t2, 0($t0)
    	sw $t2, 28($sp)
    	lw $t0, ADDR_DSPL
    	
    	addi $t2, $zero, 60
    	sw $t2, 0($sp)
    	addi $t2, $zero, 188
    	sw $t2, 4($sp)
    	addi $t2, $zero, 316
    	sw $t2, 8($sp)
    	addi $t2, $zero, 444
    	sw $t2, 12($sp)
    	j spawn_block
    	#li $t7, 4
    	#li $t9, 0
    	#j checker_gen_loop
    	#j game_loop

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    	lw $t0, ADDR_DSPL
    	lw $t2, ADDR_KBRD
    	lw $t3, 0($t2)
    	beq $t3, 1, keyboard_input
    	b game_loop

keyboard_input:
    	lw $a0, 4($t2)                  # Load second word from keyboard
    	beq $a0, 0x77, respond_to_W
    	beq $a0, 0x61, respond_to_A
    	beq $a0, 0x73, respond_to_S
    	beq $a0, 0x64, respond_to_D
    	beq $a0, 0x71, respond_to_Q
    	li $v0, 1                       # ask system to print $a0
    	syscall

    	b game_loop

respond_to_W:
	li $v0, 10                      # Quit gracefully
	syscall

respond_to_A:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	
	addi $s0, $s0, -4
	addi $s1, $s1, -4
	addi $s2, $s2, -4
	addi $s3, $s3, -4
	
	#Check collision 
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	lw $a0, 0($t0)
	beq $a0, $t4, collide_left
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	lw $a0, 0($t0)
	beq $a0, $t4, collide_left
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	lw $a0, 0($t0)
	beq $a0, $t4, collide_left
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	lw $a0, 0($t0)
	beq $a0, $t4, collide_left
	
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3, $s3, 4
	
	#Erase shape
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $s5, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $s6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $s7, 0($t0)
	
	addi $s0, $s0, -4
	addi $s1, $s1, -4
	addi $s2, $s2, -4
	addi $s3, $s3, -4
	
	#Save new colours
	addi $sp, $sp, -32
	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s0
    	lw $t2, 0($t0)
    	sw $t2, 16($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s1
    	lw $t2, 0($t0)
    	sw $t2, 20($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s2
    	lw $t2, 0($t0)
    	sw $t2, 24($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s3
    	lw $t2, 0($t0)
    	sw $t2, 28($sp)
    	lw $t0, ADDR_DSPL
	
	#Redraw
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $t1, 0($t0)
	
	#Save coordinates
	sw $s3, 0($sp)
	sw $s2, 4($sp)
	sw $s1, 8($sp)
	sw $s0, 12($sp)
	
	b game_loop
	
respond_to_S:
	li $v0, 10                      # Quit gracefully
	syscall
	
respond_to_D:
	j redraw_block

respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall
	
redraw_block:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3, $s3, 4
	
	#Check collision 
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	lw $a0, 0($t0)
	beq $a0, $t4, collide_right
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	lw $a0, 0($t0)
	beq $a0, $t4, collide_right
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	lw $a0, 0($t0)
	beq $a0, $t4, collide_right
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	lw $a0, 0($t0)
	beq $a0, $t4, collide_right
	
	addi $s0, $s0, -4
	addi $s1, $s1, -4
	addi $s2, $s2, -4
	addi $s3, $s3, -4
	
	#Erase shape
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $s5, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $s6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $s7, 0($t0)
	
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3, $s3, 4
	
	#Save new colours
	addi $sp, $sp, -32
	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s0
    	lw $t2, 0($t0)
    	sw $t2, 16($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s1
    	lw $t2, 0($t0)
    	sw $t2, 20($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s2
    	lw $t2, 0($t0)
    	sw $t2, 24($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s3
    	lw $t2, 0($t0)
    	sw $t2, 28($sp)
    	lw $t0, ADDR_DSPL
	
	#Redraw
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $t1, 0($t0)
	
	#Save coordinates
	sw $s3, 0($sp)
	sw $s2, 4($sp)
	sw $s1, 8($sp)
	sw $s0, 12($sp)
	
	b game_loop

collide_right:
	addi $s0, $s0, -4
	addi $s1, $s1, -4
	addi $s2, $s2, -4
	addi $s3, $s3, -4
	
	#Erase shape
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $s5, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $s6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $s7, 0($t0)
    	
    	#Redraw
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $t1, 0($t0)
    	
    	sw $s3, 0($sp)
	sw $s2, 4($sp)
	sw $s1, 8($sp)
	sw $s0, 12($sp)
    	b game_loop
    	
collide_left:
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3, $s3, 4
	
	#Erase shape
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $s5, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $s6, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $s7, 0($t0)
	
	#Save colours
	addi $sp, $sp, -32
    	add $t0, $t0, $s0
    	lw $t2, 0($t0)
    	sw $t2, 16($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s1
    	lw $t2, 0($t0)
    	sw $t2, 20($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s2
    	#beq $t2, $t5, thing
    	lw $t2, 0($t0)
    	sw $t2, 24($sp)
    	lw $t0, ADDR_DSPL
    	add $t0, $t0, $s3
    	lw $t2, 0($t0)
    	sw $t2, 28($sp)
    	lw $t0, ADDR_DSPL
    	
    	#Redraw
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s3
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s2
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s1
	sw $t1, 0($t0)
	lw $t0, ADDR_DSPL
	add $t0, $t0, $s0
	sw $t1, 0($t0)
    	
    	sw $s3, 0($sp)
	sw $s2, 4($sp)
	sw $s1, 8($sp)
	sw $s0, 12($sp)
    	b game_loop

thing:
	li $v0, 10                      # Quit gracefully
	syscall