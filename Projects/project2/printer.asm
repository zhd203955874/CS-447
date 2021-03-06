.data
                      #    # " !       ' & % $     + * ) (     / . - ,     3 2 1 0     7 6 5 4     ; : 9 8     ? > = <     C B A @     G F E D     K J I H     O N M L     S R Q P     W V U T     [ Z Y X     _ ^ ] \     c b a `     g f e d     k j i h     0 n m l     s r q p     w v u t     { z y x     | } ~ <-
	line1:	.word	0x50502000, 0x2040c020, 0x00002020, 0x00000000, 0x70702070, 0xf870f810, 0x00007070, 0x70000000,	0x70f07070, 0x70f8f8f0, 0x88087088, 0x70888880, 0x70f070f0, 0x888888f8, 0x70f88888, 0x00207000, 0x00800020, 0x00300008, 0x80102080, 0x00000060, 0x00000000, 0x00000040, 0x10000000, 0x00404020
	line2:	.word	0x50502000, 0x20a0c878, 0x20a81040, 0x08000000, 0x88886088, 0x08888030, 0x00008888, 0x88400010, 0x88888888, 0x88808088, 0x90082088, 0x8888d880, 0x88888888, 0x88888820, 0x40088888, 0x00501080, 0x00800020, 0x00400008, 0x80000080, 0x00000020, 0x00000000, 0x00000040, 0x20000000, 0x00a82020
	line3:	.word	0xf8502000, 0x20a01080, 0x20701040, 0x10000000, 0x08082098, 0x1080f050, 0x20208888, 0x0820f820, 0x80888898, 0x80808088, 0xa0082088, 0x88c8a880, 0x80888888, 0x88888820, 0x40105050, 0x00881040, 0x70f07010, 0x70e07078, 0x903060f0, 0x70f8f020, 0x78b878f0, 0xa88888f0, 0x20f88888, 0x00102020
	line4:	.word	0x50002000, 0x00402070, 0xf8d81040, 0x2000f800, 0x301020a8, 0x20f80890, 0x00007870, 0x30100040, 0x80f088a8, 0x80f0f088, 0xc00820f8, 0x88a88880, 0x70f088f0, 0x88888820, 0x40202020, 0x00001020, 0x88880800, 0x88408888, 0xa0102088, 0x8888a820, 0x80488888, 0xa8888840, 0x40108850, 0x00001020
	line5:	.word	0xf8002000, 0x00a84008, 0x20701040, 0x40000030, 0x082020c8, 0x208808f8, 0x20200888, 0x2020f820, 0x8088f898, 0xb8808088, 0xa0882088, 0x88988880, 0x08a08880, 0xa8888820, 0x40402050, 0x00001010, 0x80887800, 0x8840f888, 0xc0102088, 0x8888a820, 0x70408888, 0xa8508840, 0x20208820, 0x00002020
	line6:	.word	0x50000000, 0x009098f0, 0x20a81040, 0x80000030, 0x88402088, 0x20888810, 0x20008888, 0x00400010, 0x88888880, 0x88808088, 0x90882088, 0x88888880, 0x88909880, 0xd8508820, 0x40802088, 0x00001008, 0x80888800, 0x78408088, 0xa0102088, 0x8888a820, 0x084078f0, 0xa8508840, 0x20407850, 0x00002020
	line7:	.word	0x50002000, 0x00681820, 0x00002020, 0x00200010, 0x70f87070, 0x20707010, 0x00007070, 0x20000000, 0x70f08878, 0x7080f8f0, 0x88707088, 0x708888f8, 0x70887880, 0x88207020, 0x70f82088, 0xf8007000, 0x78f07800, 0x08407878, 0x90907088, 0x7088a870, 0xf0400880, 0x50207830, 0x10f80888, 0x00004020
	line8:	.word	0x00000000, 0x00000000, 0x00000000, 0x00000020, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xf0000000, 0x00600000, 0x00000000, 0x00000880, 0x00000000, 0x00007000, 0x00000000
	
	file: .asciiz "\nEnter a text file to be printed: "
	fileName: .space 64
	buffer:	.space	80

.text
	addi $v0, $zero, 4		#Print text
	la   $a0, file
	syscall	
	la $a0, fileName
	addi $a1, $zero, 999		#Sets number of characters read in
	addi $v0, $zero, 8		#Scanin
	syscall	
removeN:
	lb $t1, fileName($t0)		# Set t1 equal to the t0 char of string
	addi $t0, $t0, 1		# counter++
	bne $t1, $zero, removeN 	# Restart loop until null is reached
	beq $a1, $s0, next
	subi $t0, $t0, 2
	sb $zero, fileName($t0)
next:	
	addi $v0, $zero, 13		# Open File
	la $a0, fileName     		# input file name
	li $a1, 0       		# Open for reading (flags are 0: read, 1: write)
	li $a2, 1      			# mode is ignored
	syscall
	move $s6, $v0			# save the file descriptor

main:
	li $t0, 0			# Set counter to 0
	move $a0, $s6			# file descriptor 
	la $a1, buffer			# address of buffer from which to read
	jal _readLine
	
	la $a0, buffer
	jal _printBuffer
	li $t0, 0			# Set counter to 0
	jal _printSpaceBetweenLine
	
	#j finish			# Test to print just 1 line
	beq $v0, 1, finish		# If readline detects the end of the file, end program
	j main

_readLine:

					# This function should take two arguments, a file descriptor and an address of 80-byte bu↵er
					# Return 1 if it encounters the end of file else return 0
					# Should always fill up the 80-byte bu↵er
					# Read the file one byte at a time
			
	li $v0, 14			# Read from file
	li $a2, 1			# reads 1 char in
	syscall	
	lb $t1, ($a1)			# Stores byte to buffer
	beq $t1, 0, fileEnd		# if the char just read in == end of file (ASCII value 0) jump to fileEnd
	beq $t1, 10, newLine		# if the char just read in == new line character (ASCII value 10) jump to newline
	addi $a1, $a1, 1		# Set buffer++
	j _readLine
	addi $t0, $t0, 1		# Set counter++	
newLine:
	li $v0, 0
	j fill
fileEnd:
	li $v0, 1
	j fill
fill:					# Takes the buffer, and fills the rest of the 80 bytes with spaces
	li $t3, 32			# Set t3 to ASCII space
	sb $t3, ($a1)			# Add a space to the end of buffer	
	beq $t0, 80, done		# Fill until count hits 80, which means we hit the end of the buffer
	addi $a1, $a1, 1		# Set buffer++
	addi $t0, $t0, 1		# Set counter++	
	j fill
done:
	jr $ra

_printLine:
	
	li $t1, 0			# Set counter2 to 0
	# PRINT A (6 + 6 + 6 + 6 + 6 + 2)
	printA:
	lb $t5, ($a0)			# Set t5 to beginning of buffer
	subi $t5, $t5, 32		# - 32 from ascii value
	add $t5, $t5, $a1		# 
	lbu $t6, ($t5)			# set t6 to ascii value of buffer
	srl $t6, $t6, 2			# Makes t6 only 6 bits
	or $t7, $t7, $t6		# ORs t7 and t6
	addi $a0, $a0, 1		# buffer++
	addi $t1, $t1, 1		# counter++
	beq $t1, 5, finishPrintA	# This way it doesn't shift 6 when it should only shift 2
	sll $t7, $t7, 6			# shifts t7 down 6 places
	j printA

	# Last 2 bits
	finishPrintA:
	sll $t7, $t7, 2			# shifts t7 down 2 places
	lb $t5, ($a0)
	subi $t5, $t5, 32
	add $t5, $t5, $a1
	lbu $t6, ($t5)
	srl $t6, $t6, 6			# shift right 6 times so you only get the last 2 bits
	or $t7, $t7, $t6		
	
	# End of printA
	move $t8, $t7
	li $t7, 0
	li $t9, 1
	
	# PRINT B (4 + 6 + 6 + 6 + 6 + 4)
	
	# other 4 bits
	lbu $t6, ($t5)
	#srl $t6, $t6, 2			# 
	#andi $t6, $t6, 15
	sll $t7, $t6, 4	
	
	addi $a0, $a0, 1		# Buffer++
	li $t1, 0			# Set counter2 to 0
	
	# 4 6 bits
	printB:
	lb $t5, ($a0)			# Set t5 to beginning of buffer
	subi $t5, $t5, 32		# - 32 from ascii value
	add $t5, $t5, $a1		# 
	lbu $t6, ($t5)			# set t6 to ascii value of buffer
	srl $t6, $t6, 2			# Makes t6 only 6 bits
	or $t7, $t7, $t6		# ORs t7 and t6
	addi $a0, $a0, 1		# buffer++
	addi $t1, $t1, 1		# counter++
	beq $t1, 4, finishPrintB	# Loops 4 times for the 4 sixes
	sll $t7, $t7, 6			# shifts t7 down 6 places
	j printB
	
	# Last 4 bits
	finishPrintB:
	sll $t7, $t7, 4			# shifts t7 down 4 places
	lb $t5, ($a0)
	subi $t5, $t5, 32
	add $t5, $t5, $a1
	lbu $t6, ($t5)
	srl $t6, $t6, 4			# shift right 4 times and back to get 4 bits
	or $t7, $t7, $t6
		
	li $t1, 0				# Set counter2 to 0
	move $t8, $t7
	li $t9, 1
	li $t7, 0
	
	# PRINT C (2 + 6 + 6 + 6 + 6 + 6)
	# Print last 2 bits
	lbu $t6, ($t5)
	srl $t6, $t6, 2
	andi $t6, $t6, 3
	sll $t7, $t6, 6
	addi $a0, $a0, 1		# Buffer++
	li $t1, 0				# Set counter2 to 0
	
	# Print 5 6 bits
	printC:
	lb $t5, ($a0)			# Set t5 to beginning of buffer
	subi $t5, $t5, 32		# - 32 from ascii value
	add $t5, $t5, $a1		# 
	lbu $t6, ($t5)			# set t6 to ascii value of buffer
	srl $t6, $t6, 2			# Makes t6 only 6 bits
	or $t7, $t7, $t6		# ORs t8 and t6
	addi $a0, $a0, 1		# buffer++
	addi $t1, $t1, 1		# counter++
	beq $t1, 5, finishPrintC	# Loops 5 times for the 5 sixes
	sll $t7, $t7, 6			# shifts t8 down 6 places
	j printC
	
	finishPrintC:
	move $t8, $t7
	li $t9, 1
	li $t7, 0
	addi $t0, $t0, 1
	bne $t0, 5, _printLine		# 3 * 5 * 32 = 480 bits

	jr $ra


_printBuffer:
	add $t2, $zero, $ra
	
	move $s7, $a0
	move $a0, $s7
	la $a1, line1
	li $t0, 0			# Set counter to 0
	jal _printLine
	move $a0, $s7
	la $a1, line2
	li $t0, 0			# Set counter to 0
	jal _printLine
	move $a0, $s7
	la $a1, line3
	li $t0, 0			# Set counter to 0
	jal _printLine
	move $a0, $s7
	la $a1, line4
	li $t0, 0			# Set counter to 0
	jal _printLine
	move $a0, $s7
	la $a1, line5
	li $t0, 0			# Set counter to 0
	jal _printLine
	move $a0, $s7
	la $a1, line6
	li $t0, 0			# Set counter to 0
	jal _printLine
	move $a0, $s7
	la $a1, line7
	li $t0, 0			# Set counter to 0
	jal _printLine	
	move $a0, $s7
	la $a1, line8
	li $t0, 0			# Set counter to 0
	jal _printLine
	add $ra, $zero, $t2
	jr $ra
_printSpaceBetweenLine:
	addi $t8, $zero, 0x00000000
	addi $t9, $zero, 1	
	addi $t0, $t0, 1		# Set counter++	
	bne $t0, 75, _printSpaceBetweenLine
	jr $ra

finish:
	li   $v0, 16       # close file
	move $a0, $s6      # file descriptor to close
	syscall 
	addi $v0, $zero, 10
	syscall
