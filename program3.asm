TITLE Composite Numbers    (program3.asm)

; Author: Chelsea Li
; Last Modified: 07/22/20
; OSU email address: lichel@oregonstate.edu
; Course number/section: CS271-001
; Assignment Number: 5                Due Date: 08/14/20
; Description: 
; EC: 
INCLUDE Irvine32.inc

UPPERLIMIT		= 300		; max number of composite numbers

.data
n           	DWORD ?																		                                    ; total number of composite numbers
k               DWORD ?                                                                                                         ; current number to test and will be printed if it is composite
num_composite   DWORD ?                                                                                                         ; keeps track of the current number of composite numbers found
checkIndex      DWORD ?                                                                                                         ; used to check if the global variable k is composite
lastIndex       DWORD ?                                                                                                         ; last number used to check if the global variable k is composite
num_in_line     DWORD ?                                                                                                         ; number of composites in the current line
want_odd        DWORD ?                                                                                                         ; 0 = shows all numbers, 1 = show only composite numbers
space5			BYTE		"     ", 0															                                ; 5 spaces
welcome     	BYTE		"Welcome to the Composite Number Spreadsheet", 0
ec				BYTE		"**EC: The user is given the option to print out all composite numbers or just the odd ones.", 0
author  		BYTE		"Programmed by Chelsea Li", 0
progIntro		BYTE		"This program is capable of generating a list of composite numbers.", 0
askOdd          BYTE        "Enter 0 to show all composite numbers or 1 to show only the odd composite numbers: ", 0
progInstruct	BYTE		"Let me know how many composite numbers you would like to see.", 0
range			BYTE		"I'll accept orders for up to 300 composite numbers.", 0
askTerms		BYTE		"How many composites do you want to view? [1 .. 300]: ", 0
errorMessage	BYTE		"Out of range. Please try again.", 0
bye				BYTE		"Here ya go, bye!", 0

.code
main PROC
    call    introduction
    call    getUserData
    call    showComposites
    call    goodbye
	exit                    ; exit to operating system
main ENDP

; Procedure to introduce the program.
; receives: none
; returns: new value for global variable want_odd
; preconditions:  none
; registers changed: eax, edx
introduction PROC

; Display welcome message
    mov     edx, OFFSET welcome
    call    WriteString
    call    Crlf
; Display extra credit
    mov     edx, OFFSET ec
    call    WriteString
    call    Crlf
; Display author's name
    mov     edx, OFFSET author
    call    WriteString
    call    Crlf
; Display program introduction
    mov     edx, OFFSET progIntro
    call    WriteString
    call    Crlf
; Display program instruction
    mov     edx, OFFSET progInstruct
    call    WriteString
    call    Crlf
; Display the upperlimit of user input
    mov     edx, OFFSET range
    call    WriteString
    call    Crlf
; Get an integer for want_odd
    mov     edx, OFFSET askOdd
    call    WriteString
    call    ReadInt
    mov     want_odd, eax

	ret
introduction ENDP

; Procedure to get the number of composite numbers to print
; receives: none
; returns: user input value for global variable n
; preconditions:  none
; registers changed: eax, edx
getUserData PROC

; Get an integer for n
    mov     edx, OFFSET askTerms
    call    WriteString
    call    ReadInt
    mov     n, eax
; Validating the user input
    call    validate

	ret
getUserData ENDP

; Procedure to check the user input
; receives: n is a global variable
; returns: none
; preconditions:  none
; registers changed: edx
validate PROC

; Check if the input is between 1 and 300
    cmp     n, 1           ; Checking if the input is less than 1
    jl      error
    cmp     n, UPPERLIMIT  ; Checking if the input is greater than 300
    jg      error
    jmp     valid_input
; Prints out an error message when the input is less than 1 or greater than 300
    error:
        mov     edx, OFFSET errorMessage
        call    WriteString
        call    Crlf
        call    getUserData
; Called when the input is within range
    valid_input:

	ret
validate ENDP

; Procedure to show the composite numbers
; receives: k, num_composite, and num_in_line are global variables
; returns: new value for the global variables k, num_composite, and num_in_line
; preconditions:  1 <= k <= 300
; registers changed: eax, ebx, ecx, edx
showComposites PROC

; Initializing values for global variables k, num_composite, and num_in_line
    mov     k, 4
    mov     num_composite, 1
    mov     num_in_line, 1
; Initialize accumulator and loop control
	mov		eax, 0		        ; accumulator = 0
	mov		ebx, num_composite 	; lower limit in ebx
	mov		ecx, n         	    ; calculate number of times to execute the loop
	sub		ecx, num_composite
	inc		ecx			        ; loop count is n - num_composite + 1
; Print out the composite numbers
    printLoop:
        call	isComposite
		mov     eax, k
        call    WriteDec
    ; Printing spaces
        mov     edx, OFFSET space5
        call    WriteString
        mov		eax, num_in_line
        cdq
        mov		ebx, 10
        div		ebx
        cmp     edx, 0
        je      next_line
        jmp     next_val
    ; Printing out a new line
        next_line:
            call    Crlf
            mov     num_in_line, 0
    ; Getting the new values to check and increasing loop counter
        next_val:
            inc     k
            inc     num_in_line
            mov		ebx, num_composite
            mov		eax, 0
            add		eax, ebx            ; add current integer to accumulator
            inc		ebx                 ; add 1 to current integer
            loop	printLoop    

	ret
showComposites ENDP

; Procedure to check if a number is composite
; receives: k, checkIndex, lastIndex, want_odd are global variables
; returns: new value for the global variables k, checkIndex, lastIndex
; preconditions:  none
; registers changed: eax, ebx, edx
isComposite PROC

; Initializing values for global variables checkIndex and lastIndex
    mov     checkIndex, 1
    mov     eax, k
    mov     ebx, 1
    sub     eax, ebx
    mov     lastIndex, eax
; Checking if the global variable k is a composite number by dividing it by the global variable checkIndex and checking the remainder
    checkLoop:
    ; If the global variable k is divisible by the global variable checkIndex then it is composite
        inc     checkIndex
        mov		eax, k
        cdq
        mov		ebx, checkIndex
        div		ebx
        cmp     edx, 0
        je      check_want_odd
        jmp     next_num
    ; Checking if the user wants to print only the odd composite numbers
        check_want_odd:    
            mov     eax, want_odd
            cmp     eax, 0
            je      end_proc
        ; Checking if the composite number is odd
            mov     eax, k
            cdq
            mov     ebx, 2
            div     ebx
            cmp     edx, 0
            jne     end_proc 
    ; Getting the next number to test if the global variable k is composite
        next_num:
            mov     eax, checkIndex
            cmp     eax, lastIndex
            jl      checkLoop
; Getting a new number to test to see if it is composite
    inc     k
    call    isComposite
; Called if the global variable k is the right composite number (the number in the global variable k will be printed).
    end_proc:

	ret
isComposite ENDP

; Procedure to print out the goodbye statement
; receives: none
; returns: none
; preconditions:  none
; registers changed: edx
goodbye PROC

; Display goodbye message
    call    Crlf
    mov     edx, OFFSET bye
    call    WriteString
    call    Crlf

	ret
goodbye ENDP

END main
