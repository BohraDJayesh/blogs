section .data
    divident dd 17 ; Just for example we're taking divident as 17.
    divisor dd 5 ; Taking divisor that can give us some remainder.
    result db "Modulus ", 0 ;

section .bss
    ; .bss sections is used for declaring uninitalized variables.
    output resb 32  ; Declaring a variable to store our output modulus result, resb represents to allocate 32 bit as buffer.

section .text
global _start

_start:
    mov eax, [divident] ; Remember the concept of square brackets ?
    move ebx, [divisor] ; 
    div ebx ; div instruction divides the register with accumulator and stores the result in edx.
    mov eax, edx ; The remainder is moved in the accumulator.

    ; Now for displaying the result we've to convert our register's data into ascii form.
    ; for that we'll be creating a function called itoa, it's just like any other label but we're naming it here function.

    mov edi, output ; allocating a pointer to the output variable to keep track of our variable.
    call conversion

    ; Prepare the output string
    mov eax, 4        ; syscall number for sys_write
    mov ebx, 1        ; file descriptor (stdout)
    mov ecx, result   ; message to display
    mov edx, edi      ; length of the message
    int 0x80

    ; Exit the program
    mov eax, 1        ; syscall number for sys_exit
    xor ebx, ebx      ; exit status 0
    int 0x80

conversion:
    ; for reference ebx is storing divisor, ecx is storing 

    ; Integer to ASCII conversion function (EDX=input, EDI=output)
    push ebx
    push ecx
    push edx

    mov ecx, 10       ; Set divisor to 10 (for decimal conversion)
    mov ebx, edi      ; Point ebx to the end of the output buffer

reverseLoop:
    xor edx, edx      ; Clear any previous remainder
    div ecx           ; Divide EDX:EAX by 10, result in EAX, remainder in EDX
    add dl, '0'       ; Convert remainder to ASCII
    dec ebx           ; Move buffer pointer backwards
    mov [ebx], dl     ; Store ASCII character in the buffer
    test eax, eax     ; Check if quotient is zero
    jnz reverseLoop   ; If not, continue loop

    mov edi, ebx      ; Set edi to point to the beginning of the string

    pop edx
    pop ecx
    pop ebx
    ret


