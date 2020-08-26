TITLE Sorting Random Integers    (program4.asm)

; Author: Chelsea Li
; Last Modified: 08/02/20
; OSU email address: lichel@oregonstate.edu
; Course number/section: CS271-001
; Assignment Number: 4                Due Date: 08/02/20
; Description: This program ask the user how many random numbers they want the program is display. 
;              The program will check if the input is in the correct range and will ask the user to 
;              enter another number if their input is out of bounds. The program will then generate
;              the specified number of integers and store into a list. Then the list will be sorted
;              in descending order using selection sort and then the list will be displayed.

INCLUDE Irvine32.inc

MIN             = 15
MAX             = 200
LO              = 100
HI              = 999

.data
request         DWORD ?                                                                                         ; number of random integers to generate
array           DWORD 200 DUP (?)                                                                               ; list of random integers
num_print       DWORD ?                                                                                         ; number of integers printed                                                                                        ; divisor variables
i               DWORD ?                                                                                         ; index value
arrayi          DWORD ?                                                                                         ; an array element
arrayk          DWORD ?                                                                                         ; an array element
outerLim        DWORD ?                                                                                         ; limit for outer loop
outerCount      DWORD ?                                                                                         ; index for outer loop
innerCount      DWORD ?                                                                                         ; index for inner loop
temp            DWORD ?                                                                                         ; temporary value
progTitle     	BYTE		"Sorting Random Integers", 0
author  		BYTE		"Programmed by Chelsea Li", 0
progIntro		BYTE		"This program generates random numbers between 100 to 999, ",
                            "displays the original list, sorts the list, and calculates the median value. ",
                            "The sorted list will then be displayed in descending order.", 0
askNum  		BYTE		"How many numbers should be generated? [15 .. 200]: ", 0
errorMessage	BYTE		"Invalid input", 0
unsortMessage   BYTE        "The unsorted random numbers:", 0
medMessage      BYTE        "The median is ", 0
sortMessage     BYTE        "The sorted list:", 0
bye				BYTE		"Here ya go, bye!", 0

.code
main PROC
    push    OFFSET progTitle
    push    OFFSET author
    push    OFFSET progIntro
    call    introduction            ; Introducing the program
    push    OFFSET errorMessage
    push    OFFSET askNum
    push    OFFSET request
    call    getData                 ; Get input from user
    push    request
    push    OFFSET array
    call    fillArray               ; Put request number of random number of integers into array
    push    OFFSET array
    push    request
    push    OFFSET unsortMessage
    push    num_print 
    call    displayList             ; Print the unsorted array
    push    OFFSET array
    push    request
    push    arrayk
    push    arrayi
    push    innerCount
    push    outerCount
    push    i
    call    sortList                ; Sorting the array in descending order
    push    OFFSET array
    push    request
    push    OFFSET medMessage
    push    temp
    call    displayMedian           ; Find and print the median of the array
    push    OFFSET array
    push    request
    push    OFFSET sortMessage
    push    num_print
    call    displayList             ; Print the sorted array
	exit                            ; exit to operating system
main ENDP

; *******************************************************************************
; Procedure to introduce the program
; receives: address of progTitle, author, and progIntro on system stack
; returns: none
; preconditions: none
; registers changed: edx
; *******************************************************************************
introduction    PROC
    push    ebp
    mov     ebp, esp
; Display program title
    mov     edx, [ebp+16]    ; progTitle in edx
    call    WriteString
    call    Crlf
; Display author
    mov     edx, [ebp+12]    ; author in edx
    call    WriteString
    call    Crlf
; Display program introduction
    mov     edx, [ebp+8]     ; progIntro in edx
    call    WriteString
    call    Crlf

    pop     ebp
    ret     12
introduction    ENDP

; *******************************************************************************
; Procedure to get the user's input
; receives: address of request, askNum, and errorMessage on system stack
; returns: user input in global request
; preconditions: none
; registers changed: eax, ebx, edx
; *******************************************************************************
getData    PROC
    push    ebp
    mov     ebp, esp
; Validating user input
    checkNum:
        mov     edx, [ebp+12]    ; address of askNum in edx
        call    WriteString
        call    ReadInt
        cmp     eax, MIN
        jl      printError
        cmp     eax, MAX
        jg      printError
        jmp     returnData
    ; If the input is out of bounds, an error message will occur
        printError:
            mov     edx, [ebp+16]   ; address of errorMessage in edx
            call    WriteString
            call    Crlf
            jmp     checkNum
; Storing input into global variable
    returnData:
        mov     ebx, [ebp+8]    ; request in ebx
        mov     [ebx], eax      ; store in global variable
        pop     ebp
        ret     12
getData    ENDP

; **********************************************************************
; Procedure to fill in an array with random numbers
; receives: value of request and address of array on system stack
; returns: an array with request number of random integers
; preconditions: request is initialized, 15 <= request <= 200
; registers changed: eax, ebx, ecx, edi
; **********************************************************************
fillArray    PROC
    push  ebp
    mov   ebp, esp
    mov   edi, [ebp+8]       ; address of array in edi
    mov   ecx, [ebp+12]      ; request in ecx
    mov   ebx, MIN
    call  randomize
; Generating random numbers and storing the values into an array
    loopArray:
    ; Generating a random number
        mov   eax, HI
        sub   eax, LO
        inc   eax
        call  RandomRange
        add   eax, LO 
    ; Storing the value into the array
        mov   [edi], eax
        add   edi, 4
        inc   ebx
        loop  loopArray
        pop   ebp
        ret   8
fillArray    ENDP

; ***********************************************************************************************************************
; Procedure to sort list
; receives: address of array; and value of request, i, outerCount, innerCount, arrayi, and arrayk on system stack
; returns: array with sorted integers in descending order
; preconditions: array has a list of integers
; registers changed: eax, ebx, ecx, edx, esi
; ***********************************************************************************************************************
sortList    PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp+32]    ; address of array in esi
    mov     eax, 0
    mov     [ebp+12], eax
; Selection sort to sort the list of numbers
    outerLoop:
    ; Getting the value of outerCount to store in i and increment to store in innerCount
        mov     eax, [ebp+12]  
        mov     [ebp+8], eax
        inc     eax
        mov     [ebp+16], eax        
    ; Comparing values in the array
        innerLoop:
            mov     ebx, [ebp+8]         
            mov     eax, [esi+ebx*4]     ; Getting the first array value to compare
            mov     [ebp+20], eax           
            mov     ebx, [ebp+16]        
            mov     eax, [esi+ebx*4]     ; Getting the second array value to compare
        ; Comparing the two array elements
            cmp     eax, [ebp+20]
            jg      setIndex
            jmp     nextNum    
        ; If the second element is greater than the other
            setIndex:
                mov     eax, [ebp+16]  
                mov     [ebp+8], eax
        ; Testing the next array element
            nextNum:
                mov     ebx, [ebp+16]
                inc     ebx
                mov     [ebp+16], ebx
                cmp     ebx, [ebp+28]
                jl      innerLoop               
    ; Getting the array elements to swap
        mov     ebx, [ebp+8]          
        mov     eax, [esi+ebx*4]
        mov     [ebp+20], eax         
        mov     ebx, [ebp+12]         
        mov     eax, [esi+ebx*4]    
        mov     [ebp+24], eax
    ; Swapping array elements
        mov     ebx, [ebp+12]         
        mov     eax, [ebp+20]         
        mov     [esi+ebx*4], eax      
        mov     ebx, [ebp+8]         
        mov     eax, [ebp+24]        
        mov     [esi+ebx*4], eax
    ; Resetting the inner loop and getting a new array element to test
        mov     ebx, [ebp+12]
        inc     ebx
        mov     [ebp+12], ebx
        mov     eax, [ebp+28]   ; value of request in eax
        dec     eax
        cmp     ebx, eax
        jl      outerLoop

        call    Crlf
        pop     ebp
        ret     28
sortList    ENDP

; **********************************************************************************************
; Procedure to display the median of the list
; receives: address of array and medMessage and value of request and temp on system stack
; returns: none
; preconditions: array is sorted in descending order
; registers changed: eax, ebx, edx, esi
; **********************************************************************************************
displayMedian    PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp+20]     ; address of array in esi
; Finding the median of the list
    mov     edx, [ebp+12]        
    call    WriteString
    mov     eax, [ebp+16]        
    cdq
    mov     ebx, 2
    div     ebx
    cmp     edx, 0
    je      getAvg
    mov     eax, [esi+eax*4]     ; median of array in eax
    call    WriteDec
    jmp     endPro
; Getting the average of the two middle numbers of the list if there's an even number of integers
    getAvg:
        mov     ebx, [esi+eax*4]    ; first middle number of array in ebx
        mov     [ebp+8], ebx
        dec     eax
        mov     ebx, [esi+eax*4]    ; second middle number of array in ebx
        mov     eax, [ebp+8]        
        add     eax, ebx
        cdq
        mov     ebx, 2
        div     ebx
        cmp     edx, 0
        jne     roundMed
        jmp     printMed
    ; Rounding the average/median
        roundMed:
            inc     eax
    ; Printing the median
        printMed:
            call    WriteDec
; End of procedure
    endPro:
        call    Crlf
        pop     ebp
        ret     16
displayMedian    ENDP

; *****************************************************************************************************
; Procedure to display list
; receives: value of request and num_print and address of array and title on system stack
; returns: none
; preconditions: array has request number of integers
; registers changed: eax, ebx, ecx, edx, esi
; *****************************************************************************************************
displayList    PROC
    push  ebp
    mov   ebp, esp
    mov   edx, [ebp+12]     ; address title in edx
    call  WriteString
    call  Crlf
    mov   ecx, [ebp+16]     ; request in ecx    
    mov   esi, [ebp+20]     ; address of array in esi
    mov   ebx, 0
; Printing the elements in array
    printArray:
        mov     eax, [esi]    ; array element in eax
        call    WriteDec 
        add     esi, 4
        mov     eax, ' '
        call    WriteChar
        call    WriteChar
        call    WriteChar
    ; Seeing how many numbers there are in one line (if there are 10 then there will be a new line)
        inc     ebx
        mov     [ebp+8], ebx
        mov     eax, ebx
        cdq
        mov     ebx, 10
        div     ebx
        cmp     edx, 0
        jne     nextNum
        call    Crlf       
    ; Resetting the loop for the next number to print
        nextNum:
            mov     ebx, [ebp+8]    ; num_print in ebx
            loop    printArray
            pop     ebp
            ret     16
displayList    ENDP

END main