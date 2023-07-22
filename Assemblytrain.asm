.data
Name: .asciiz "\n Name: MANSOUR ALDAHRI"
msgEnter : .asciiz "\nEnter array elements: "
msgEnterE : .asciiz "\nEnter the number of array elements :"
msgAvg : .asciiz "\nThe  squared avg is : "
msgMax : .asciiz "\nThe Max value is "
msgMin : .asciiz "\nThe min is "
msgCount : .asciiz "\n Countof elements is : "
msgMinD: .asciiz "\n Double of minimum: "
msgMaxH: .asciiz "\n Half of maximum: "
msgArray: .asciiz "\nThe array is:   " 
array : .word 100
nl : .asciiz "\n"
space: .asciiz " "
msgPos: .asciiz " Count of postive elements is : "
msgNeg: .asciiz "\n Count of negtive elements is : "


.text
	# print enter msg
	li $v0 , 4
	la $a0 , msgEnterE
	syscall
	li $v0 , 5
	syscall
	move $s1, $v0
	
	# print enter msg
	li $v0 , 4
	la $a0 , msgEnter
	syscall

	# start looping to enter values

	# base in $s0
	la $s0 , array
	jal EnterValues
	
	# count in s1
	move $s1 , $v0
	
	# get max 
	la $s0 , array
	addi $t0 , $zero , 0
	jal Max
	
	# s0 base , s1 count , s2 max , s3 min , s4 avg , s5 pos , s6 neg
	
	# put the first element in t0
	# get Min
	la $s0 , array
	lw $s3, 0($s0)
	addi $t0 ,$zero, 0
	jal getMinimum
	
	# get Avg
	la $s0 , array 
	addi $t0 ,$zero, 0
	jal Avg
	
	# get pos
	la $s0 , array 
	addi $t0 ,$zero, 0
	jal pos
	
	
	# sort
	jal sort
	
	#-----------------------
	li $v0 , 4
	la $a0 , Name
	syscall 
		
	#-----------------------
	li $v0 , 4
	la $a0 , Id
	syscall 
		
	#-----------------------
	li $v0 , 4
	la $a0 , msgCount
	syscall 
	
	li $v0 , 1
	move $a0 , $s1
	syscall
		


	
	#-----------------------
	li $v0 , 4
	la $a0 , msgMax
	syscall
	
	li $v0 , 1
	move $a0 , $s2
	syscall
	
	# power of max
	li $v0 , 4
	la $a0 , msgMaxH
	syscall
	

	srl $s2 , $s2 , 1
	move $a0 , $s2
	li $v0 , 1
	syscall

	#-----------------------
	li $v0 , 4 
	la $a0 , msgMin
	syscall
	li $v0 , 1
	move $a0 , $s3
	syscall

	#-----------------------
	li $v0 , 4
	la $a0 , msgAvg
	syscall
	li $v0 , 3
	syscall
	

	#-----------------------
	li $v0 , 4
	la $a0 , msgMinD
	syscall
	
	#mul * 2
			add $t1 , $0 , $0 #rest t0
		addi $t1 , $t1 , 2 # 2
		mul $s3 ,$s3 , $t1
	
	li $v0 , 1
	la $a0 , ($s3)
	syscall
	
		#-----------------------
	li $v0 , 4
	la $a0 , msgPos
	syscall
	li $v0 , 1
	move $a0 , $s5
	syscall
	

	#-----------------------
	li $v0 , 4
	la $a0 , msgArray 
	syscall
	addi $t0 ,$zero, 0
	la $s0 , array 
	jal printArray
	li $v0 , 10
	syscall
	

#--------------------------------------------------	
EnterValues:
	li $v0 , 5
	syscall
	# number in $t0
	move $t0, $v0
	beq $t0 ,$s1 returnArray
	# counter in $a0
	addi $a1 , $a1 , 1
	sw $t0 , 0($s0)

	
	#add 4 to $s0
	addi $s0 , $s0 , 4
	j EnterValues
	
	returnArray:
		# count in v0

		move $v0 , $a1
		jr $ra
#-----------------------------------------------------

Max:

	beq $t0 , $s1 , returnMax
	# count in t0 from 0 to s1
	# element in s1
	# max s2
	lw $t1 , 0($s0)
	addi $t0 , $t0 , 1
	addi $s0 , $s0 , 4
	blt $s2 , $t1 , getMax
	j Max
	getMax:
		# store t1 in s2
		move $s2 , $t1
		j Max
	returnMax:
		jr $ra
#-----------------------------------------------------

getMinimum:

	beq $t0 , $s1 , returnMin
	# count in t0 from 0 to s1
	# element in s1
	# min s3
	lw $t1 , 0($s0)
	addi $t0 , $t0 , 1
	addi $s0 , $s0 , 4
	blt $t1,$s3 , getMin #o
	j getMinimum
	
	getMin:
		# store t1 in s3
		move $s3 , $t1
		j getMinimum
	returnMin:

		jr $ra
#----------------------------------------------------

Avg:
	beq $t0 , $s1 , returnAvg
	# avg in s4
	lw $t1 , 0($s0)
	addi $t0 , $t0 , 1
	addi $s0 , $s0 , 4
	add $s4, $s4 , $t1
	j Avg
	returnAvg:
	# sum and count to float , count in f11 , sum f12
	mtc1.d $s1, $f0
   	cvt.d.w $f0, $f0

   	mtc1.d $s4, $f12
  	cvt.d.w $f12 , $f12
   	
	div.d  $f12 , $f12 , $f0 #calculate avge
	
	mul.d $f12 , $f12 , $f12 # calculate square
	jr $ra
	
#--------------------------------------------------

sort:
 	#sp
 	addi $sp , $sp , -16
 	sw $s1 , 0($sp)
 	sw $s2 , 4($sp)
 	sw $s3 , 8($sp)
 	sw $s4 , 12($sp)
	li $s1,0 #reinitialize counter
	loopSort:
		beq $t0,$s1,exit1	 #if counter=number of element
		la $s0,array	   	 #$s0 adrs of arr
		addi $s2,$s1,1		 #$s2(2nd counter)=counter1+1
		loopTwo:
		beq $t0,$s2, exit2	 #if counter=number of element
		lw  $s3, 0($s0)           #$s3 this element of arr
		lw  $s4, 4($s0)           #$s4 next element of arr
		bgt $s4,$s3,continue	 #if $s4>$s3 continue
		sw $s4,0($s0)		 #swap $s4 $s3
		sw $s3,4($s0)
		continue:
		addi $s0,$s0,4		 #change pointer to next location
		addi $s2,$s2,1		 #increment the counter2
		j loopTwo
		exit2:
		addi $s1,$s1,1		 #increment the counter1
		j loopSort
	exit1:
 	#sp
 	
 	lw $s1 , 0($sp)
 	lw $s2 , 4($sp)
 	lw $s3 , 8($sp)
 	lw $s4 , 12($sp)
 	addi $sp , $sp , 16
jr $ra
#------------------------------------------------------
printArray:
	beq $t0 , $s1 , returnPrint
	# count in t0 from 0 to s1
	lw $a0 , 0($s0)
	li $v0 , 1
	syscall
	li $v0, 11
	li $a0, 32
	syscall

	addi $t0 , $t0 , 1
	addi $s0 , $s0 , 4
	j printArray
	returnPrint:
		jr $ra


#-----------------------------------------------------
pos:

	

	add $t0, $t0 ,$0
	
	beq $t0 , $s1 , returnpos
	# count is to
	lw $t1 , 0($s0)
	bgez $t1 , ispostive
	addi $s0 , $s0 , 4	
	j pos
	
	ispostive:
	addi $t0 , $t0 , 1
	addi $s0 , $s0 , 4
	returnpos:
	add $s5, $s5 , $t1
	
	jr $ra

#-----------------------------------------------------
neg:

	

	add $t0, $t0 ,$0
	
	beq $t0 , $s1 , returnneg
	# count is to
	lw $t1 , 0($s0)
	blez $t1 , isneg
	addi $s0 , $s0 , 4	
	j pos
	
	isneg:
	addi $t0 , $t0 , 1
	addi $s0 , $s0 , 4
	returnneg:
	add $s6, $s6 , $t1
	
	jr $ra		
	

