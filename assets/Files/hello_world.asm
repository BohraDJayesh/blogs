section .data
    message db "Hello world !", 0 ; db is used to define character strings and 0 is used to end string with null char.
    message_length dd 12 ; 

section .text
global _start

_start:
    ; In the .text section we've declare an entry point _start to where the actual execution begins.
    mov eax, 0x4 ; In x86 to make system call we have to assign a number to accumulator and to call write function it's 4.
    mov ebx, 0x1 ; ebx is set to 1 to represent stdout (standard output).
    mov ecx, message ; assigning pointer to our variable to know where to start.
    mov edx, message_length ; assigning each parameter to a register so that it can be used during execution.

; Now making the system call.
    int 0x80 ; int stands for interrupt so making an interrupt to invoke kernal i.e 0x80, which will write o/p to stdout.

; Now exiting the porgarm by making system call for sys_exit
    mov eax, 1 ; 1 is the system call for sys_exit.
    mov ebx, 0 ; setting the status of the program to zero, specifying it runned successfully.
    int 0x80 ; Again making the system call to kernal which will usse sys_exit, with exit status 0.

; And voilla ! We've written our first "Hello World" program in assembly language.