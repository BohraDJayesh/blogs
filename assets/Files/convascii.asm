section .data
    integer dd 53483    ; random integer to convert it into it's ascii form.
    output  db 40       ; Buffer for the ASCII representation 

section .text
global _start

_start:
    ; Load the integer into EAX
    mov eax, [integer]

    ; Set EDI to point to the end of the buffer

    mov edi, output + 39  ; Moving the pointer to point at the end of the buffer as the buffer is of length 40.
                          ; Start from the end and move backward

    ; Null-terminate the buffer
    mov byte [edi], 0

convertLoop:

    ; Dividing EAX by 10, recall the logic discussed previously.

    mov edx, 0     ; Clearing the register as it may contain any previous remainder.
    mov ecx, 10      ; Set divisor to 10
    div ecx          ; Divide ecx by 10, result in EAX and remainder in edx.

    ; Converting the remainder to ASCII and storing it in the buffer.

    add dl, '0'      ; Convert remainder to ASCII character
    dec edi          ; Move buffer pointer backward
    mov [edi], dl    ; Store the ASCII character in the buffer, here dl is the lower bits of edx register. 
                     ; We're not using edx because then the '0's ascii value will be added to whole register and will output something else.
    
    ; Now Checking if quotient (EAX) is zero or not.

    cmp eax, eax ; cmp will not set zero flag if they both are equal otherwise 1.

    jnz convertLoop  ; If not zero, continue the loop, which means that the numeber is not finished yet.

    ; Now to calculate the length of the ASCII representation first we'll get the value of current edi, move it to eax and will calculate how much it is from output, hence getting the length of output.
    mov eax, edi      ; Set eax to the address of the last character
    sub eax, output   ; Calculate the offset from the start of the buffer
    inc eax           ; Include the null terminator

    ; Prepare the output string, ig you can do this part on your own finally !!!.
    mov eax, 4           ; syscall number for sys_write
    mov ebx, 1           ; file descriptor (stdout)
    mov ecx, edi         ; pointer to the ASCII representation in the buffer
    mov edx, 40          ; fixed length of the message (including potential leading zeros)
    
    ; Make the write system call to display the message and ASCII representation
    int 0x80

    ; Exit the program
    mov eax, 1       ; syscall number for sys_exit
    xor ebx, ebx     ; exit status 0
    int 0x80