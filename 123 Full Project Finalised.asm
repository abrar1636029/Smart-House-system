# Smart Home System v1.0.0
# Made by:
# 1) Mohammad Syameer Imran Bin Mohd Ashrof (2015807)
# 2) Sumaio Abdullahi Rage (1713874)
# 3) Abrar Habib Haque  (1636029)
# 
# For final project of CSC 3402 COMPUTER ARCHITECTURE & ASSEMBLY LANGUAGE
#
#--------------------------------------
# Data Segment for declaring variables
#--------------------------------------

.data
#--------------------------------------------
# Variables for log-in and selection screen
#--------------------------------------------
welcomeMsg:		.asciiz "<---Welcome to Smart Home System--->\nPlease Login!!\n"
userNMsg:		.asciiz "Enter your username: "
passMsg:			.asciiz "Enter your password: "
wrongMsg:		.asciiz "Please enter correct username and password!!!\n"
menu:			.asciiz "Choose an option:\n\t1: Smart Lock \n\t2: Smart Temperature  \n\t3: Smart Security   \nYour Selection: "
wrongOpt:		.asciiz "Invalid option. Choose valid one!!!\n"
user1:			.asciiz "Abrar"
user2:			.asciiz "Sumaio"
user3:			.asciiz "Syameer"
strWrong: 		.asciiz "\n!!Wrong Input, please try again!!\n\n"
strReturn:		.asciiz "\n\nDo you want to go back to main menu?\n\tEnter 1 for Yes\n\tEnter 2 for No.\nYour Selection: "
inpReturn:		.space	2
password:		.word	54321
userName:		.space	10

#-----------------------------------------
# Variables for smart temperature section
#-----------------------------------------
tempMsg:			.asciiz "Enter temperature: "
tempStable: 		.asciiz "\n*Temperature is stable"
tempOverMsg:		.asciiz "\n*Temperature is unbalanced"
tempIs:			.asciiz "\n*Temperature is: "

#----------------------------------------
# Variables for smart lock section
#----------------------------------------
strWelcome: 	.asciiz "Welcome to Smart Lock Sensor terminal.\n"
strGuide: 	.asciiz "Please choose a door:\n\tEnter 1 for Main door\n\tEnter 2 for Back door.\nYour Selection: "
selNo1: 		.ascii "1"
selNo2: 		.ascii "2"
strSelMainDoor: 	.asciiz "You have selected the Main Door. Please choose whether to:\n\tTurn sensor on(1)\n\tTurn sensor off(2).\nPlease enter the corresponding number: "
strSelBackDoor: 	.asciiz "You have selected the Back Door. Please choose whether to:\n\tTurn sensor on(1)\n\tTurn sensor off(2).\nPlease enter the corresponding number: "
strSensorOn: 	.asciiz "*Smart sensor is on for "
strSensorOff: 	.asciiz "*Smart sensor is off for "
strMainDoor: 	.asciiz "Main Door."
strBackDoor: 	.asciiz "Back Door."
inpGuide: 	.space 4
inpSelect: 	.space 4

#----------------------------------------
# Variables for smart security section
#----------------------------------------
CAMERA_INPUT: 	.asciiz "Does Security Camera turn on?\n\tEnter 1 for YES\n\tEnter 0 for NO\nYour Selection: "
Recording: 	.asciiz "\n*Start Recording"
Secure: 		.asciiz "\n*Home is Secure"

#--------------------------------------
# Text Segment for instructions
#--------------------------------------

.text
#***********************
# Log-in section
#***********************

# display welcome message
la	$a0, welcomeMsg
jal	displayNotification

# first program phase
main:
	# display username message
	la	$a0, userNMsg
	jal	displayNotification
                 
	# read username from user
	la	$a0, userName
	li	$a1, 11			# 10 charcaters can be read from user
	jal	readStrInput

	# print password message
	la	$a0, passMsg
	jal	displayNotification

	#read password from user
	jal	readIntInput
	move	$t0, $v0		# move password into t0

# check for usernames if they are correct
checkUserName:
	la	$a0, user1
	la	$a1, userName
	jal	strCmp		# check username and user1 are equal or not
	beqz	$v0, checkPassword	# if v0 == 0 goto checkPassword
	
	la	$a0, user2
	la	$a1, userName
	jal	strCmp		# check username and user2 are equal or not
	beqz	$v0, checkPassword	# if v0 == 0 goto checkPassword
	
	la	$a0, user3
	la	$a1, userName
	jal	strCmp		# check username and user2 are equal or not
	beqz	$v0, checkPassword	# if v0 == 0 goto checkPassword
	j	inValid			# else jump on inValid

# check for password if it is correct
checkPassword:
	lw	$t1, password		# load password into t1
	bne	$t0, $t1, inValid	# if t0 != password goto inValid


#***********************
# Menu section
#***********************

# display menu on console
DisplayMenu:
	la	$a0, menu
	jal	displayNotification

# display selection menu and user will input to go to the sensor they wanted
SelectMenu:
	li 	$v0, 5          		# user input
	syscall	
	move	$t4, $v0			# move user input into t4
	addi 	$t5, $zero, 1
	addi	$t6, $zero, 2
	addi	$t7, $zero, 3		# add each of these to use for comparison below
	beq	$t4, $t5, Smart_Lock
	beq	$t4, $t6, Smart_Temperature
	beq	$t4, $t7, Smart_Security	# comparisons to go to the specific branches
	
	li $v0, 4			# called when user entered wrong input
	la $a0, strWrong
	syscall
	j Exit
	
	
#****************************
# Smart Temperature section
#****************************	
Smart_Temperature:
	# print enter temperature message
	la	$a0, tempMsg		
	jal	displayNotification
	# read temperature from user
	jal	readIntInput	
	move	$t3, $v0			# move temperature into t3
	blt	$t3, 20,tempAlert	# if temperature < 20 goto tempAlert
	bgt	$t3, 30,tempAlert               # else if temperature > 30 goto tempAlert 
	la	$a0, tempStable	
	jal	displayNotification
	j	Exit			
	
tempAlert:
		# print temperature over loaded message
		la	$a0, tempOverMsg
		jal	displayNotification
		j	printValue	# jump on printValue
		
printValue:
	# print temperature message
	la	$a0, tempIs
	jal	displayNotification
	# print temperature value
	move	$a0, $t3
	jal	displayIntegerValue
	j Exit
 
# this function display a string on console
displayNotification:
	li	$v0, 4
	syscall
	jr	$ra	
	
# this function read string value from user
readStrInput:
	li	$v0, 8
	syscall	
	jr	$ra
				
# if username or password wrong then this block of code execute
inValid:
	# print invalid message
	la	$a0, wrongMsg
	jal	displayNotification
	#j	main	# jump on main
		
# this function read integer value from user
readIntInput:
	li	$v0, 5
	syscall	
	jr	$ra	
	
# this function print integer value on console
displayIntegerValue:
	li	$v0, 1
	syscall	
	jr	$ra
	
# this function compare two string if both strings are equal then $v0 = 0	
strCmp:
	add	$s0,$zero,$zero 	# s0 = 0
	add	$s1,$zero,$a0 		# s1 = first string address
	add	$s2,$zero,$a1 		# s2 = second string address
	loop:
		lb	$s3,0($s1) 		# load a byte from string 1
		lb	$s4,0($s2) 		# load a byte from string 2
		beq	$s3, 10, returnStrCmp
		beqz	$s3, returnStrCmp
		bne	$s3, $s4, setMinusOne 		
		li	$v0, 0
		j	nextChars
	setMinusOne:
		li	$v0, -1
	nextChars:
		addi	$s1,$s1,1 		# s1 points to the next byte of str1
		addi	$s2,$s2,1
		j	loop
returnStrCmp:
	jr	$ra
	
#****************************
# Smart Lock section
#****************************	

Smart_Lock:
	# Display the first welcome string
	li $v0, 4
	la $a0, strWelcome
	syscall

	# Display the input guide along with input variable setup
	li $v0, 4
	la $a0, strGuide
	syscall

	li $v0, 8
	la $a0, inpGuide
	li $a1, 4
	move $t0, $a0
	syscall

	# Load byte of the choices in $t1 and $t2 respectively, and load byte of first place for the user input
	lb $t1, selNo1
	lb $t2, selNo2
	lb $t0, 0($t0)

# Check for which door is choosen. Display wrong string if wrong input is given
Check_Door:
	beq $t0, $t1, Main_Door
	beq $t0, $t2, Back_Door
	li $v0, 4
	la $a0, strWrong
	syscall
	j Smart_Lock

# Main Door Branch
Main_Door:
	# Display the selection text for Main Door
	li $v0, 4
	la $a0, strSelMainDoor
	syscall
	
	# Getting input from user
	li $v0, 5
	la $a0, inpSelect
	li $a1, 4
	move $t0, $a0
	syscall
	
	# Load word for comparison purpose
	lb $t1, selNo1
	lb $t2, selNo2
	lb $t0, 0($t0)
	
	# Set a memory so that next branch would know which door
	la $a0, strMainDoor
	move $s0, $a0
	
	# Check if user want to turn on or off
	beq $t0, $t1, Turn_On
	beq $t0, $t2, Turn_Off
	li $v0, 4
	la $a0, strWrong
	syscall
	j Main_Door

# Back Door Branch
Back_Door:
	#Display the selection text for Back Door
	li $v0, 4
	la $a0, strSelBackDoor
	syscall
	
	# Getting input from user
	li $v0, 8
	la $a0, inpSelect
	li $a1, 4
	move $t0, $a0
	syscall
	
	# Load word for comparison purpose
	lb $t1, selNo1
	lb $t2, selNo2
	lb $t0, 0($t0)
	
	# Set a memory so that next branch would know which door
	la $a0, strBackDoor
	move $s0, $a0
	
	# Check if user want to turn on or off
	beq $t0, $t1, Turn_On
	beq $t0, $t2, Turn_Off
	li $v0, 4
	la $a0, strWrong
	syscall
	j Back_Door

# Branch for turning on the sensor	
Turn_On:
	# Display that the sensor is on
	li $v0, 4
	la $a0, strSensorOn
	syscall
	
	# For the door that is store in here
	li $v0, 4
	move $a0, $s0
	syscall
	
	# Jump to exit
	j Exit

# Branch for turning off the sensor
Turn_Off:
	# Display that the sensor is off
	li $v0, 4
	la $a0, strSensorOff
	syscall
	
	# For the door that is store in here
	li $v0, 4
	move $a0, $s0
	syscall
	
	# Jump to exit
	j Exit

#****************************
# Smart Security section
#****************************	

Smart_Security:
	#Smart_security_Sensor:
	li $v0, 4                     # system call code for printing string = 4
	la $a0, CAMERA_INPUT           # load address of string to be printed into $a0
	syscall
	li $v0, 5                     # user input
	syscall
	move $t0, $v0                 # transfering it to other register

	# Perform addition to register t1 and t2 for comparison purpose
	addi $t1, $zero, 1
	addi $t2, $zero, 2

	beq $t0, $t1, Record_Branch 	# use $t1 because it has integer 1 in there
	beq $t0, $zero, Secure_Branch	# use $t2 because it has integer 2 in there
	la $v0, 4                     # system call code for printing string = 4
	la $a0, strWrong         # print wrong string and then exit the program
	syscall
	j Smart_Security

Record_Branch:
	li $v0, 4                     # system call code for printing string = 4
	la $a0, Recording             # load address of string to be printed into $a0
	syscall
	j Exit

Secure_Branch:
	li $v0, 4                     # system call code for printing string = 4
	la $a0, Secure      	     # load address of string to be printed into $a0
	syscall
	j Exit
	
Exit:
	# Print the instruction for going back to menu and ask for user input
	li $v0, 4		                     
	la $a0, strReturn
	syscall				
	li $v0, 5
	syscall		
	# Go to Menu if user input 1 or go to Terminate if user input 2		
	move $t0, $v0			
	addi $t1, $zero, 1		
	beq  $t0, $t1, DisplayMenu	
	beq  $t0, $t2, Terminate	
	la $v0, 4                  
	la $a0, strWrong         
	syscall
	j Exit

# Quit the program
Terminate:
	li $v0, 10
	syscall

