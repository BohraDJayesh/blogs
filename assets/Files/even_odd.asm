section .data
    evenMsg db "The number is even.", 0
    oddMsg db "The number is odd.", 0

section .text
global _start

_start:
    mov eax, 42 ; Replace with your number
    test eax, 1
    jz isEven

    ; Code for odd number
    mov ebx, oddMsg
    jmp printMessage

isEven:
    ; Code for even number
    mov ebx, evenMsg

printMessage:
    mov eax, 4
    mov ecx, ebx
    mov edx, 20 ; Adjust the message length as needed
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
