TITLE Elementary Arithmetic    (program1.asm)

; Author: Chelsea Li
; Last Modified: 6/30/20
; OSU email address: lichel@oregonstate.edu
; Course number/section: CS271-001
; Assignment Number: 1                Due Date: 7/5/20
; Description: This program first gets two integers from the user.
;			   Then the program will calculate the square of the two integers
;			   and checks if the second number is less than the first.
;			   If the first number is greater than or equal to the second, 
;			   then the program will calculate the sum, difference, product,
;			   quotient, and remainder of the two numbers.
; EC: The program also verifies second number less than first and calculates the square of both numbers.

INCLUDE Irvine32.inc

.data
a				DWORD ?		; first number
b				DWORD ?		; second number
Sum				DWORD ?		; sum of the two numbers
Difference		DWORD ?		; difference of the two numbers
Product			DWORD ?		; product of the two numbers
Quotient		DWORD ?		; quotient of the two nubmers
Remainder		DWORD ?		; remainder of the two numbers
squarea			DWORD ?		; square of the first number
squareb			DWORD ?		; square of the second number
programtitle	BYTE		"Elementary Arithmetic by Chelsea Li", 0
ec				BYTE		"**EC: Program verifies second number less than first and calculates the square of both numbers.", 0
prompt			BYTE		"Enter 2 numbers, the program will print out the sum, difference, product, quotient, and remainder.", 0
invalid			BYTE		"The second number must be less than the first!", 0
firstnum		BYTE		"First number: ", 0
secondnum		BYTE		"Second number: ", 0
plus			BYTE		" + ", 0
minus			BYTE		" - ", 0
mult			BYTE		" x ", 0
divide			BYTE		" / ", 0
modu			BYTE		" remainder ", 0	; modu stands for modulus
square			BYTE		"Square of ", 0
equal			BYTE		" = ", 0
bye				BYTE		"Here ya go, bye!", 0

.code
main PROC
; Introduction
; Display title
	mov		edx, OFFSET programtitle
	call	WriteString
	call	Crlf
; Display extra credit
	mov		edx, OFFSET ec
	call	WriteString
	call	Crlf
; Display instructions
	mov		edx, OFFSET prompt
	call	WriteString
	call	Crlf

; Get the data
; Get an integer for a
	mov		edx, OFFSET firstnum
	call	WriteString
	call	ReadInt
	mov		a, eax
; Get an integer for b
	mov		edx, OFFSET secondnum
	call	WriteString
	call	ReadInt
	mov		b, eax

; Calculate the square of the numbers
; Get the square of a
	mov		eax, a
	mov		ebx, a
	mul		ebx
	mov		squarea, eax
; Get the square of b
	mov		eax, b
	mov		ebx, b
	mul		ebx
	mov		squareb, eax

; Display the square of the numbers
; Display the square of a
	mov		edx, OFFSET square
	call	WriteString
	mov		eax, a
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, squarea
	call	WriteDec
	call	Crlf
; Display the square of b
	mov		edx, OFFSET square
	call	WriteString
	mov		eax, b
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, squareb
	call	WriteDec
	call	Crlf

; Checking if the second number is less than the first
; Jump to check_second_num
	jmp		check_second_num

check_second_num:
; Comparing the two numbers
	mov		eax, a
	mov		ebx, b
	cmp		eax, ebx
	jb		less_than			; called if the second number is less than the first
	jae		greater_than_equal	; called if the first number is greater than or equal to the second

less_than:
	; Display the error message
	mov		edx, OFFSET invalid
	call	WriteString
	call	Crlf
	jmp		both	; prevents greater_than_equal from being called

greater_than_equal:
	; Calculate the required values
	; Get the sum of a and b
		mov		eax, a
		mov		ebx, b
		add		eax, ebx
		mov		Sum, eax
	; Get the difference of a and b
		mov		eax, a
		mov		ebx, b
		sub		eax, ebx
		mov		Difference, eax
	; Get the product of a and b
		mov		eax, a
		mov		ebx, b
		mul		ebx
		mov		Product, eax
	; Get the quotient and remainder of a and b
		mov		eax, a
		cdq
		mov		ebx, b
		div		ebx
		mov		Quotient, eax
		mov		Remainder, edx

	; Display the results
	; Display the sum
		mov		eax, a
		call	WriteDec
		mov		edx, OFFSET plus
		call	WriteString
		mov		eax, b
		call	WriteDec
		mov		edx, OFFSET equal
		call	WriteString
		mov		eax, Sum
		call	WriteDec
		call	Crlf
	; Display the difference
		mov		eax, a
		call	WriteDec
		mov		edx, OFFSET minus
		call	WriteString
		mov		eax, b
		call	WriteDec
		mov		edx, OFFSET equal
		call	WriteString
		mov		eax, Difference
		call	WriteDec
		call	Crlf
	; Display the product
		mov		eax, a
		call	WriteDec
		mov		edx, OFFSET mult
		call	WriteString
		mov		eax, b
		call	WriteDec
		mov		edx, OFFSET equal
		call	WriteString
		mov		eax, Product
		call	WriteDec
		call	Crlf
	; Display the quotient and remainder
		mov		eax, a
		call	WriteDec
		mov		edx, OFFSET divide
		call	WriteString
		mov		eax, b
		call	WriteDec
		mov		edx, OFFSET equal
		call	WriteString
		mov		eax, Quotient
		call	WriteDec
		mov		edx, OFFSET modu
		call	WriteString
		mov		eax, Remainder
		call	WriteDec
		call	Crlf

both:

; Saying goodbye
; End program
	mov		edx, OFFSET bye
	call	WriteString
	call	Crlf
	exit	; exit to operating system
main ENDP

END main
