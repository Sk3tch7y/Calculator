.data

res: .asciiz "result: "
welc: .asciiz "Welcome to Adams Calculator program. for bulk input press b and hit enter, or just hit enter for individual input \n"
bulk1: .asciiz "For bulk input do not use spaces and type using standard programming signage (+, - , * , /, ^, and () for isolated instructions )" 
calc1: .asciiz "The calculator is capable of many things say what you would like to do and the calculator will comply. say ( to start a bracket section \n"
fac1: .asciiz "input a number to calculate the factorial of \n"
add1: .asciiz "Input a number to add to your total \n"
sub1: .asciiz "Input a number to subtract from your total \n"
mult1: .asciiz "multiply your total by an integer \n"
div1: .asciiz "divide your total by an integer \n"
mark: .byte  #stores calc status
total: .space 8 #saves space for value from bulk input
.text
main:
	la $a0, welc
	li $v0, 4
	syscall
	la $v0, 8
	syscall
	bne $a0, 98, calc
	j bulkIn
	
calc:
	la $a0, calc1
	li $v0, 4
	syscall
	
	j end
bulkIn:
	la $a0, bulk1
	li $v0, 4
	syscall

	
brc:
	
add:

sub:

mult:
	mult $a1, $a2 
	mflo $v1 #output stored in v1
	#no error processing for this line
div:
	div $a1, $a2
	mflo $v1 #output stored in $v1
	mfhi $t1
	bnez $t1, divError #program proper error print out for remainder
	j 
factorial:
	la $a0, Fac1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	la $a2, ($v0)
	li $v1, 1 # sets $v1 to 1 to avoid intial error
	facLoop:
		beq $a2, 1, facExit #checks that its being multiplied by a valid number and skipping 
		mult $v1, $a2
		mflo $v1
		addi $a2, $a2, -1
		j facLoop	
	facExit:
	j calc

divError:

end: 	
	
	li $v0, 10
	syscall