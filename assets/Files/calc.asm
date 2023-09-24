section .data 
    buffer db 20 ; buffer to store the input.
    buf_len equ $ - buffer ; Calculating the length of the buffer.
    prompt db "Enter your choice :", 0xA, "1. Add", 0xA, "2. Sub", 0xA, "3. Multiply", 0xA, "4. Divide", 0 ; 0xA represent newline character in your ass.
    input1 db "Enter first variable : ", 0
    input2 db "Enter second variable : ", 0
    inp1_len equ $ - input1
    inp2_len equ $ - input2
    prompt_len equ $ - prompt
    result db "Answer ", 0 ;

section .bss 
    choice resd 1 ; reserved space for the integer choice input.
    inp1 resd 32 ; input 1 for operation.
    inp2 resd 32 ; input 2 for further operation.
    outis resd 32


section .text
global _start


_start:
    ; The first step being displaying options and asking user to enter their choice.
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Now reading input1 from the user.
    mov eax, 3 ; syscall number for sys_read
    mov ebx, 0 ; file descriptor (stdin)
    mov ecx, buffer
    mov edx, buf_len
    int 0x80

    ; Now converting the input string to an integer.

    mov eax, buffer ; Getting the address of the input string.
    call str2int ; Calling our function that can convert string to integer.
    mov [choice], eax ; storing the integer value in the choice variable.

    ; As our choice is stored in the choice variable now we will start with taking input for both of them. 
    ; Taking input for variable inp1
    
    mov eax, 4
    mov ebx, 1
    mov ecx, input1
    mov edx, inp1_len
    int 0x80

    ; Reading the first input.
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, buf_len
    int 0x80

    ; Same converting string into integer.
    mov eax, buffer
    call str2int
    mov [inp1], eax 

    ; Taking input for second variable.
    mov eax, 4
    mov ebx, 1
    mov ecx, input2
    mov edx, inp2_len
    int 0x80

    ; Reading the second input.
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, buf_len
    int 0x80

    ; Same converting string into integer.
    mov eax, buffer
    call str2int
    mov [inp2], eax 


    ; Making Labels for Arithmetic operations.
    mov eax, 1
    cmp eax, choice
    jz addition

    mov eax, 2
    cmp eax, choice
    jz subtraction

    mov eax, 3
    cmp eax, choice
    jz multiply

    mov eax, 4
    cmp eax, choice
    jz divide

addition:
    mov eax, inp1
    add eax, [inp2]
    mov [outis], eax
    mov edi, outis ; allocating a pointer to the output variable to keep track of our variable.
    call conversion
    jmp output


substraction:
    mov eax, inp1
    sub eax, inp2
    mov [outis], eax
    mov edi, outis ; allocating a pointer to the output variable to keep track of our variable.
    call conversion
    jmp output


multiply:
    mov eax, inp1
    mul dword [inp2]
    mov [outis], eax
    mov edi, outis ; allocating a pointer to the output variable to keep track of our variable.
    call conversion
    jmp output


divide:
    mov eax, inp1
    div inp2
    mov [outis], eax
    mov edi, outis ; allocating a pointer to the output variable to keep track of our variable.
    call conversion
    jmp output

; Now defining our functions.

; Converting Integer into String variable for ascii. IG you can now do this on your own.

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


; Converting String to Integer.

str2int:
    pushad ; Basically or general purpose registers are pushed into the stack so that they can be used later.
    mov eax, 0
    mov ecx, 0

char_loop:
    ; we're going to convert each char of string into integer, why ? to use this function later as well.
    ; Generally ascii char are of 8 bits so to store them in register we're moving them with movzx to extend it's bit.

    movzx edx, byte[edi + ecx] ; movzx takes the char byte and after setting remaining bites zero moves it to greater bytes register.
  
    ; At first section we point edi towards the end section of the output, now you know why we did that.
    ; Why edi + ecx ? basically it's used for address calculation, a common practice you'll see very often.

    test dl, dl ; again we're dealing with 8 bytes of data so instead of edx we're just using dl, and it tests if null is set.
    jz done ; If they're the zero flag will be set hence jump.

    ; In test dl, dl we're checking if it's null terminated string or not. If it is jump to done section.

    sub dl, '0'
    
    imul eax, eax, 10 ; imul is used to mulitply registers with some value, here we're multiplying it by 10 and storing in eax.
  
    ; When the char is converted into digit, say in 12345 it's 1, we multiply the value stored with 10 so 0*10 = 0, and now 
    ; it contains 1. When the next digit i.e 2 came, the result stored is 1 we multiply it with 10 and adds2 so we get 
    ; 1*10 +2 = 12. Now for the next digit 3, we multiply the 12 with 10 and adds 3, so 120 + 3 i.e 123 and the process is repeated
    ; to get our full integer. It's just like what we do in C/C++ programming but with interacting directly with registers.
   
    add eax, edx 
    inc ecx
    jmp char_loop

done:
    popad ; Restoring our original data registers before the conversion process.
    ret

    ; Now will output for the final output.
    ; Prepare the output string

output:
    mov eax, 4        ; syscall number for sys_write
    mov ebx, 1        ; file descriptor (stdout)
    mov ecx, result   ; message to display
    mov edx, edi      ; length of the message
    int 0x80


    ; Exit the program
    mov eax, 1        ; syscall number for sys_exit
    xor ebx, ebx      ; exit status 0
    int 0x80


