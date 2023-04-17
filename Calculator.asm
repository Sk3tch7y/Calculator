.data

invalid1: .asciiz "invalid input. Exiting program...\n"
res: .asciiz "\nresult: "

welc: .asciiz "Welcome to Adams Calculator program. for bulk input press b and hit enter, or just hit enter for individual input \n"
welc2: .asciiz "What is your initial value?\n"

bulk1: .asciiz "\nFor bulk input do not use spaces and type using standard programming signage (+, - , * , /, ^, and () for isolated instructions )\n" 

calc1: .asciiz "\nThe calculator is capable of many things say what you would like to do and the calculator will comply."
calc2: .asciiz "\nWhat is the magnitude of your calculation. Value is irrelevant for factorial input. Use ( to start a isolated equation)\n"
calc3: .asciiz "\nWhat operation would you like to perform\n"
val: .asciiz "+, -, *, /, ^, !, = are all valid inputs\n"

add1: .asciiz "\nInput a number to add to your total \n"
sub1: .asciiz "\nInput a number to subtract from your total \n"
mult1: .asciiz "\nmultiply your total by an integer \n"
div1: .asciiz "\ndivide your total by an integer \n"


mark: .align  0 
	.space 1 #stores calc status
total: .align 2
	.space 8 #saves space for value from bulk input
folOp: .align 0
	.space 2
bulkBytes: .align 2
	.space 32 # saves space
	
.text
main:
	
	la $a0, welc
	li $v0, 4
	syscall # Prints welcome message
	
	la $v0, 12
	syscall #checks the calculator is not in bulk input mode
	beq $v0, 98, bulkIn
brac:
	la $a0, welc2
	li $v0, 4
	syscall #promots starter value
	
	li $v0, 5
	syscall #gets starter value
	la $a1, ($v0) #loads initial value as input parameter
calc:
	lb $t0, mark
	bnez, $t0, bulkSkip #checks if bulk mode is enabled
	
	la $a0, calc1
	li $v0, 4
	syscall	#prints cheesy calculator welcome
	
	la $a0, calc3 #Prompts operation
	li $v0, 4
	syscall	
	
	li $v0, 12
	syscall
	la $t0, ($v0) #saves operation
	
	la $a0, calc2 #Prompts action
	li $v0, 4
	syscall
	
	li $v0, 12 
	syscall
	sub $v0, $v0, 48
	
	la $a2, ($v0)#passes action and magnitude to next procedure
	la $a0, ($t0)
	j func
bulkSkip:
	
	lb $a1, bulkBytes($s0)
	lb $a0, bulkBytes+1($s0)
	lb $a2, bulkBytes+2($s0)
	addi $s0, $s0, 3
	
func:
	
	la $v0, ($a0) #Checks operation and branches accordingly 
	la $v1, ($a2) #Checks secondary
	beq $v1, -8, brcOpen
	beq $v1, -7, brcClose
	beq $v0, 43, addr
	beq $v0, 45, subr
	beq $v0, 42, multr
	beq $v0, 47, divr
	beq $v0, 33, factorial
	beq $v0, 61, equalF
	beq $v0, 94, pow
	j invalid #prints invalid 
	
bulkIn: 

	la $a0, bulk1 
	li $v0, 4
	syscall #welcome message
	li $v0, 5
	la $a0, bulkBytes
	li $a1, 31
	syscall #prompts for equation
	
brcOpen:

	sw $a2, total # stores value
	sb $a0, folOp
	j brac
	
brcClose:

	lw $a2, total 
	lb $a0, folOp
	j func
	
addr:
	
	add $v0, $a1, $a2
	j equal # prints output
	
subr:

	sub $v0, $a1, $a2
	j equal # prints output
	
multr:

	mult $a1, $a2 
	mflo $v1 #output stored in v1
	j equal
	#no error processing for this line
	
divr:
	div $a1, $a2
	mflo $v1 #output stored in $v1
	mfhi $t1
	bnez $t1, divError #program proper error print out for remainder
	j equal
	
factorial:
	li $v1, 1 # sets $v1 to 1 to avoid intial error
	facLoop: #increments starting value and repeats to calculate factorial
		beq $a1, 1, facExit #checks that its being multiplied by a valid number and skipping 
		mult $v1, $a1
		mflo $v1
		addi $a1, $a1, -1
		j facLoop	
	facExit:
	j calc
	
pow:
	la $v0, ($a1)
	powLoop: #loops to multiply by the operand
		beq $a2, 1, equal
		mult $v0, $a1
		mflo $v0
		addi $a2, $a2, -1
	j powLoop
	
equal: #prints after each operation then quits
	lb $t0, mark
	bne $t0, 0, calc
	la $t0, ($v0)
	la $a0, res
	li $v0, 4
	syscall
	
	la $a0, ($t0)
	li $v0, 1
	syscall
	
	la $v0, ($t0)
	j calc
	
equalF: #function print and quit

	la $a0, res
	li $v0, 4
	syscall
	
	la $a0, ($a1)
	li $v0, 1
	syscall
	
	j end
	
divError: #overflow error
	
end: 	#exit
	
	li $v0, 10
	syscall
	
invalid: #invalid input
	
	li $v0, 4
	la $a0, invalid1
	syscall
	
	li $v0, 10
	syscall
