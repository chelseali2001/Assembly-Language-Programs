TITLE Fibonacci Numbers    (program2.asm)

; Author: Chelsea Li
; Last Modified: 07/11/20
; OSU email address: lichel@oregonstate.edu
; Course number/section: CS271-001
; Assignment Number: 2                Due Date: 7/12/20
; Description: This program first gets the user's name. Then the program
;			   asks the user to enter the number of Fibonacci numbers 
;			   they want the program to print out. The program will
;			   check if the input is in the correct range (with a post-test loop) 
;			   and will ask the user to enter another number if their input
;			   is out of bounds. The program will then calculate
;			   the Fibonacci numbers (with a counted loop).
; EC: The program displays the numbers in aligned columns.

INCLUDE Irvine32.inc

MAXSIZE			= 100
UPPERLIMIT		= 46		; max number of Fibonacci numbers

.data
username        BYTE		MAXSIZE DUP(?), 0
n				DWORD ?																		; number of Fibonacci terms
curr			DWORD ?																		; current Fibonacci number
prev			DWORD ? 																	; previous Fibonacci number
count			DWORD ? 																	; current index in the Fibonacci sequence
temp			DWORD ? 																	; temproary value
spaces			DWORD ? 																	; number of spaces
space1			BYTE		" ", 0															; 1 space
maxspace		BYTE		"                 ", 0											; 17 spaces
programtitle	BYTE		"Fibonacci Numbers by Chelsea Li", 0
ec				BYTE		"**EC: Displays the numbers in aligned columns.", 0
nameprompt		BYTE		"What's your name? ", 0
hello		    BYTE		"Hello, ", 0
instructions	BYTE		"Enter the number of Fibonacci terms to be displayed.", 0
range			BYTE		"Provide the number as an integer in the range [1 .. 46].", 0
askTerms		BYTE		"How many Fibonacci terms do you want? ", 0
errorMessage	BYTE		"Out of range. Enter a number in [1 .. 46]", 0
bye				BYTE		"Here ya go, bye ", 0

.code
main PROC
; introduction: Introduce the program and get the user's name.
; Display title
	mov		edx, OFFSET programtitle
	call	WriteString
	call	Crlf
; Display extra credit
	mov		edx, OFFSET ec
	call	WriteString
	call	Crlf
; Get the user's name
	mov		edx, OFFSET nameprompt
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, MAXSIZE
	call	ReadString
; Display hello message
	mov		edx, OFFSET hello
	call	WriteString
	mov 	edx, OFFSET username
	call	WriteString
	call	Crlf

; displayinstructions: Display the program instructions.
; Display instructions
	mov		edx, OFFSET instructions
	call	WriteString
	call	Crlf
; Display the range the user input must be in
	mov		edx, OFFSET range
	call	WriteString

; getUserInfo: Get the number of Fibonacci terms from the user using a post-test loop to check if the user's input is valid.
; Get an integer for n
	mov		eax, 0
; Post-test loop for data validation
	postLoop: 
		call	Crlf
		mov		edx, OFFSET askTerms
		call	WriteString
		call	ReadInt
		mov		n, eax
		cmp		eax, 1
		jb		errorRange ; Checks if the input is less than 1
		cmp		eax, UPPERLIMIT
		ja		errorRange ; Checks if the input is greater than 50
		jmp		both
	; If user input is less than 1 or greater than 46
		errorRange:
			mov		edx, OFFSET errorMessage
			call	WriteString
			call	postLoop
	; If the input is within range
		both:

; displayFibs: Display the Fibonacci numbers using a counted loop to calculate and print out the Fibonacci numbers.
; Initializing the variables prev, curr, and count
	mov		prev, 1
	mov		curr, 1
	mov		count, 1
; Initialize accumulator and loop control
	mov		eax, 0		; accumulator = 0
	mov		ebx, count	; lower limit in ebx
	mov		ecx, n		; calculate number of times to execute the loop
	sub		ecx, count
	inc		ecx			; loop count is n - count + 1
; Counted loop for printing out the Fibonacci numbers
	countLoop:
		call	check_index
		call	WriteDec
		call	printSpaces
		mov		ebx, count
		mov		eax, 0
		add		eax, ebx    ; add current integer to accumulator
		inc		ebx         ; add 1 to current integer
		loop	countLoop  

; goodbye: Display goodbye statement.
; Display goodbye statement
	call	Crlf
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

; Procedure to calculate the Fibonacci number at a certain index.
; receives: count, cur, and prev are global variables
; returns: new value for the global variable prev
; preconditions:  none
; registers changed: eax, ebx, edx
check_index PROC

; Checking if the current index is equal to 1 or 2
	cmp		count, 1
	je		equal1
	cmp		count, 2
	je		equal1
	ja		greater1
; If the current index is equal to 1 or 2, then it'll print out 1
	equal1:
		mov		eax, 1
		jmp		end_check
; If the current index is greater than 2, then it'll calculate the Fibonacci number
	greater1:
		mov		eax, curr
		mov		ebx, prev
		mov		prev, eax
		add		eax, ebx
; End of the if statement
	end_check:

	ret
check_index ENDP

; Procedure to make the numbers evenly spaced.
; receives: curr and count are global variables
; returns: new value for the global variables curr, temp, spaces, count
; preconditions:  none
; registers changed: eax, ebx, edx
printSpaces PROC

	mov		curr, eax	; setting curr to the new value
; Initializing values for global variables temp and spaces			
	mov		temp, eax
	mov		spaces, 0
; Comparing the current Fibonacci number with 10
	cmp		curr, 10
	jb		print1space
	jae		fibLoop
; If the current Fibonacci number is less then 10 then print out 17 spaces
	print1space:
		mov		edx, OFFSET maxspace
		call	WriteString
		jmp		nextNum
; If the current Fibonacci number is greater than 10 then calculate the number of spaces needed to evenly space the number
	fibLoop:
		inc		spaces
		mov		eax, temp
		cdq
		mov		ebx, 10
		div		ebx			; Dividing the current Fibonacci number by 10
		mov		temp, eax
		cmp		eax, 10		; Continue the loop until the Fibonacci number is less than 10
		jae		fibLoop
; Printing out the appropriate number of spaces
	printspace:
	; Calculating the number of spaces needed
		mov		eax, 17
		mov		ebx, spaces
		sub		eax, ebx
		mov		spaces, eax
	; Printing out the spaces	
		spaceLoop:
			mov		edx, OFFSET space1
			call	WriteString
			dec		spaces
			mov		eax, spaces
			cmp		spaces, 0
			jne		spaceLoop
; Getting the next index
	nextNum:
	; Seeing if there's 4 numbers on one line
		mov		eax, count
		cdq
		mov		ebx, 4
		div		ebx
		cmp		edx, 0
		je		printnewline
		jmp		end_printSpaces
	; If there's 4 numbers on one line, print a new line
		printnewline:
			call	Crlf
	; Increase the index by 1
		end_printSpaces:
			inc		count

	ret
printSpaces ENDP

END main
