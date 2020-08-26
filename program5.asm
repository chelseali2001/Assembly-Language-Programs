TITLE Final Project    (program5.asm)

; Author: Chelsea Li
; Last Modified: 08/12/20
; OSU email address: lichel@oregonstate.edu
; Course number/section: CS271-001
; Assignment Number: 5                Due Date: 08/14/20
; Description: This program performs a variety of different operations that the user can request.
;              There is a decoy operation that calculates the sum of two 16-bit operands, an
;              encryption mode that will encrypt the requested plaintext message, and a decryption
;              mode that will decrypt the requested encrypted message.
; EC: The decoy mode correctly returns the sum of any signed 16 bit numbers and the key generation mode is implemented.

INCLUDE Irvine32.inc

.code
main PROC
	exit                            ; exit to operating system
main ENDP

;*****************************************************************************************************************
; Procedure to call the requested operation
; receives: address of dest and the addresses and values needed for the requested operation on system stack
; returns: new value for dest, message, or newKey depending on the operation
; preconditions: -3 <= dest <= 0
; registers changed: ax, cx, eax, ebx, edx
;*****************************************************************************************************************
compute PROC
    push    ebp
    mov     ebp, esp
    mov     ebx, [ebp+8]    ; address of dest in ebx
    mov     eax, [ebx]
; Determine which operation to call
    cmp     eax, 0
    je      callDecoy
    cmp     eax, -1
    je      callEncrypt
    cmp     eax, -2
    je      callDecrypt
    cmp     eax, -3
    je      callKey
    jmp     endCompute
; Calling the decoy mode of operation
    callDecoy:
        mov     ax, [ebp+14]
        push    eax
        mov     cx, [ebp+12]
        push    cx
        push    ebx
        call    decoyProc
        jmp     endCompute
; Calling the encryption mode of operation
    callEncrypt:
        mov     eax, [ebp+16]
        push    eax
        mov     edx, [ebp+12]
        push    edx
        call    encryptProc
        jmp     endCompute
; Calling the decryption mode of operation
    callDecrypt:
        mov     eax, [ebp+16]
        push    eax
        mov     edx, [ebp+12]
        push    edx
        call    decryptProc
        jmp     endCompute
; Calling the key generation mode of operation
    callKey:
        mov     eax, [ebp+12]
        push    eax
        call    keyProc
        jmp     endCompute
; Called when the operation is done
    endCompute:
        pop     ebp
        ret     12
compute ENDP

;****************************************************************************************
; Procedure to calculate the sum of two operands
; receives: value of operand1 and operand2 and address of dest on system stack
; returns: sum of operand1 and operand2 in global dest
; preconditions: dest == 0
; registers changed: ax, eax, ebx, ecx
;****************************************************************************************
decoyProc     PROC
    push    eax
    push    ecx
    push    ebx
    push    ebp
    mov     ebp, esp
; Converting the value of operand1 to a signed integer
    mov     ax, [ebp+26]    ; address of operand1 in ax
    cmp     eax, 32768
    jl      checkSecondNum
    sub     eax, 65536
; Converting the value of operand2 to a signed integer
    checkSecondNum:
        mov     ecx, eax
        mov     eax, 0
        mov     ax, [ebp+24]    ; address of operand2 in ax
        cmp     eax, 32768
        jl      returnDest
        sub     eax, 65536
; Calculating the sum of operand1 and operand2
    returnDest:
        add     eax, ecx
        mov     ebx, [ebp+20]   ; address of dest in ebx
        mov     [ebx], eax      ; store in global variable
        pop     ebp
        pop     ebx
        pop     ecx
        pop     eax
        ret     10
decoyProc     ENDP

;****************************************************************************************
; Procedure to encrypt the requested message
; receives: address of myKey and message on system stack
; returns: converted message
; preconditions: dest == -1
; registers changed: al, bl, eax, edx, esi
;****************************************************************************************
encryptProc     PROC
    push    eax
    push    edx
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp+16]   ; address of message in esi
; Converting each letter in message
    messageLoop:
        mov     al, [esi]   ; address of current character of message in al
        cmp     al, 0
        je      endEncrypt
        cmp     al, 97
        jb      nextChar
        cmp     al, 122
        ja      nextChar
        mov     bl, 97
        mov     ecx, 0
; Getting the encrypted letter to swap in the plaintext message
        getIndex:
            cmp     al, bl
            je      swapChar
            inc     bl
            inc     ecx
            jmp     getIndex
; Swapping the letter in the plaintext message with the encrypted letter
        swapChar:
            mov     edx, [ebp+20]
            mov     al, [edx+ecx]
            mov     [esi], al
; Moving on to the next character in message
        nextChar:
            inc     esi
            jmp     messageLoop
; End of the procedure
    endEncrypt:
        pop     ebp
        pop     edx
        pop     eax
        ret     8
encryptProc     ENDP

;****************************************************************************************
; Procedure to decrypt the requested message
; receives: address of myKey and message on system stack
; returns: converted message
; preconditions: dest == -2
; registers changed: al, bl, eax, edx, esi
;****************************************************************************************
decryptProc     PROC
    push    eax
    push    edx
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp+16]   ; address of message in essi
; Converting each letter in message
    messageLoop:
        mov     al, [esi]   ; address of current character of message in al
        cmp     al, 0
        je      endDecrypt
        cmp     al, 97
        jb      nextChar
        cmp     al, 122
        ja      nextChar
        mov     edx, [ebp+20]
        mov     bl, 97
; Getting the decrypted letter to swap in the encrypted message
        getIndex:
            cmp     al, [edx]
            je      swapChar
            inc     edx
            inc     bl
            jmp     getIndex
; Swapping the letter in the encrypted message with the decrypted letter
        swapChar:
            mov     [esi], bl
; Moving on to the next character in message
        nextChar:
            inc     esi
            jmp     messageLoop
; End of the procedure
    endDecrypt:
        pop     ebp
        pop     edx
        pop     eax
        ret     8
decryptProc     ENDP

;****************************************************************************************
; Procedure to generate a character string with the alphabet arranged in random order
; receives: address of newKey  on system stack
; returns: newKey with the alphabet arranged in random order
; preconditions: dest == -3
; registers changed: al, eax, ecx, edx, edi
;****************************************************************************************
keyProc     PROC
    push    eax
    push    edx
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp+16]   ; address of newKey in edi
    mov     edx, 0
; Adding the first random letter into newKey
    call    randomize
    mov     eax, 25
    call    RandomRange
    add     al, 97
    mov     [edi], al
; Filling in the rest of the alphabet
    fillKey:
    ; Generate a random letter
        generateChar:
            mov     eax, 25
            call    RandomRange
            add     al, 97
            mov     ecx, 0
    ; Checking if the randomly generated letter already exists in newKey
        validateChar:
            cmp     al, [edi+ecx]
            je      getNextAlpha
            inc     ecx
            cmp     ecx, edx
            jle     validateChar
            jmp     nextChar
    ; If the randomly generated letter already exists, then the next letter in the alphabet that hasn't been added yet will be added
        getNextAlpha:
            mov     al, 96
            ; Getting the letter in the alphabet
            getAlpha:
                mov     ecx, 0
                inc     al
                jmp     validateAlpha
            ; Checking if the letter already exists in newKey
            validateAlpha:
                cmp     al, [edi+ecx]   
                je      getAlpha
                inc     ecx
                cmp     ecx, edx
                jle     validateAlpha
    ; Adding the generated letter into newKey and resetting the loop
        nextChar:
            inc     edx
            mov     [edi+edx], al
            cmp     edx, 25
            jl      fillKey
            mov     al, 0
            mov     [edi+edx+1], al     ; Adding the null terminated character
            pop     ebp
            pop     edx
            pop     eax
            ret     4
keyProc     ENDP

END main