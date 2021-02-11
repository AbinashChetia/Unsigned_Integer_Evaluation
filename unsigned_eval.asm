# Author: Abinash Chetia
# Dated: 08/02/2021

.data
A: .space 11
B: .space 11
C: .space 11
D: .space 11
str1: .asciiz "\tTo perform (A*B)+(C*D):\n"
str2: .asciiz "Enter the first unsigned number, A: "
str3: .asciiz "Enter the second unsigned number, B: "
str4: .asciiz "Enter the third unsigned number, C: "
str5: .asciiz "Enter the fourth unsigned number, D: "
str6: .asciiz "Result, (A*B)+(C*D) = "
str7: .asciiz " = "
str8: .asciiz " "

.text
li $v0,4
la $a0,str1
syscall			# print str1 

li $v0,4
la $a0,str2
syscall			# print str2

li $v0,8		# input A
la $a0,A
li $a1,12
syscall
jal String2Number
move $s0,$v0

li $v0,4
la $a0,str3
syscall			# print str3

li $v0,8		# input B
la $a0,B
li $a1,12
syscall
jal String2Number
move $s1,$v0

li $v0,4
la $a0,str4
syscall			# print str4

li $v0,8		# input C
la $a0,C
li $a1,12
syscall
jal String2Number
move $s2,$v0

li $v0,4
la $a0,str5
syscall			# print str5

li $v0,8		# input D
la $a0,D
li $a1,12
syscall
jal String2Number
move $s3,$v0

move $a0,$s0		# Function Arguments
move $a1,$s1
move $a2,$s2
move $a3,$s3

jal Evaluate		# Function call

move $t8,$v0		# Restore results from function 
move $t9,$v1

li $v0,4
la $a0,str6
syscall			# print str6

li $v0,1
move $a0,$t8
syscall			# print MSB of result as decimal

li $v0,1	
move $a0,$t9
syscall			# print LSB of result as decimal

li $v0,4
la $a0,str7
syscall	

li $v0,34
move $a0,$t8
syscall			# print MSB of result as hexadecimal

li $v0,4
la $a0,str8
syscall

li $v0,34
move $a0,$t9
syscall			# print LSB of result as hexadecimal

li $v0,10
syscall			# end program

# -------Function-----------

Evaluate: multu $a0,$a1		# unsigned A*B
mfhi $t0
mflo $t1		# A*B = $t0 $t1

multu $a2,$a3		# unsigned C*D
mfhi $t2
mflo $t3		# C*D = $t2 $t3

addu $t7,$t1,$t3	# unsigned addition of LSB

not $t4,$t1
sltu $t5,$t4,$t3	# check for overflow in unsigned addition of LSB
addu $t6,$t5,$t0	# unsigned addition of first MSB and overflow bit
addu $t6,$t6,$t2	# unsigned addition of second MSB

move $v0,$t6
move $v1,$t7

jr $ra

String2Number: addiu $t1,$zero,48	# converting integer string input to unsigned integer
addiu $t2,$zero,57
addiu $t3,$zero,10
addu $t4,$zero,$zero

loopFunc: lb $t5,($a0)			# loading a single byte of the string

bltu $t5,$t1,exitFunc		
bgtu $t5,$t2,exitFunc			# checking if the input is valid

multu $t4,$t3				
mflo $t4

subiu $t5,$t5,48			# generating single integer
addu $t4,$t4,$t5			# generating the whole unsigned integer
addiu $a0,$a0,1				# incrementing to the next byte of the string
j loopFunc 

exitFunc: move $v0,$t4
jr $ra					# returning back to the main function
