---
# layout: post
title:  "Reverse Engineering 101"
tags: ["Reverse Engineering"]
---

<script src="/_site/assets/gif-control.js"></script>


# Theory
Reverse Engineering 101 consists of two main components: the Theory section, which covers all the essential theoretical concepts necessary for our journey in reverse engineering, and the Labs section. In the Labs, we will learn hands-on demonstrations of the theory we've learned and follow step-by-step tutorials to kickstart our reverse engineering journey. We will delve into practical exercises, reverse engineer small challenges, create logical solutions, and explore various problem-solving approaches.

## Introduction 
Getting started with anything has always been a bit challenging for me, where to start, how to start, where to look for and what not, I did a lot of 'em and specially the last one.  So, here I am, ready to chat about all these things — what I've tried (which you might want to avoid) and what I should've tried (but didn't).  It might be a mouthful, but no worries. <br> 

### The Initiation
This module is going to be quite extensive, but it will be packed with information to give you a strong start in Reverse Engineering. I'll share everything I know that gave my Reverse Engineering journey a push ( Well I'm still am at base level but anyways ), so you won't have to scour the entire internet for each next step. And yes, I consider myself a beginner in RE, and I'll stay that way until I achieve something significant in this field.
**Let's Get started .**

#### What you'll learn
- Setting up a safe virtual environment. ([Note](#) We will only talk about reversing basic application in this project, but still safety first.)
- <>
- < >
- < >
- <another point>
<br>

Let's cover the basics first, So what exactly is reverse engineering ? and who exactly is a Reverse Engineer ?
<br>
- A Reverse engineering is akin to disassembling a device to uncover its inner workings and understand how it functions. 
- A reverse engineer is an individual who practices this [ART](#) Dismantling objects to unravel their workings, enjoying the challenge of puzzles, devising experiments and tools, embracing unconventional thinking, and maintaining a thirst for continual learning.
<br>

The first question that popped up in my head is, "Why are we doing this?" Well, it's because the executable code we receive is written in machine language, which isn't easily readable by humans. So, when we look at the program, it's like trying to read a secret code that we don't know. As I mentioned before, it's in the form of machine code, and our task is to perform Reverse Engineering on this machine code to gain insights into what the original code might have been like. This helps us understand what the program was supposed to do in a language we can understand. That's what reverse engineering is all about.<br>
But again -

### Why we're doing this ?
![GIF 1](/blogs/assets/BlogImages/WindowArch.gif){: height="400"}<br>
<small>Source - Malware Unicorn</small><br>
<br>
By "Why we're doing this" I mean why depending on compilers and various intermediate code ? and not communicating with hardware directly ?<br>
The simple and to the point to this question would be **Because we are not capable to do so**. If you take a look at my blog post on [x86 assembly language](#), you'll come to understand that writing assembly language (one of the lowest-level programming languages) is highly complex. It involves various components, each with its own set of instructions and protocols. Writing assembly code for every hardware component would be impractical and error-prone. High-level languages abstract these complexities, providing simpler and more human-readable code. Most importantly, they don't compromise our productivity at all. We just have to follow their syntax, and we can accomplish our tasks without writing pages of code for simple calculations<br>
For your reference [this](https://gist.github.com/BohraDJayesh/b35c49ec16237c6746c21f75ccd7dcfa) is the code of calculator in assembly languages.



## Executables
Executables are basically stand alone files which we can run as a process in an operating system. Let's take an example to understand the concept of executables better. <br>
Let's take a simple **C** Hello world program - 

```c++
#include<iostream.h>
int main()
{
    printf("Hello World");
    return 0;
}
```
To compile it we will use - 
```c++
$ gcc -o firstc firstc.c
```
Which we can run by first giving the permission to be executed - 

```c++
$ chmod +x firstc
```
and then running it - 

```c++
$ ./firstc

$ Hello World
```
If we check the type of file we've got using **file** command, (file is a command in Unix based environment which tells us more about the type of file, it's format, on which system it was built to run, it's permission for different groups and users etc.)

```bash
$ file firstc
```
We will get output as - 

```bash
$ firstprog: ELF 64-bit ELF executable, x86-64, version 1 (SYSV), dynamically linked, interpreter
 /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX, stripped

```
What we've got here is a type of executable of ELF format or Executable and Linkable Format (Will talk about them more in detail later.), which is a type of executable used in linux environment. One thing to notice is not directly our code is converted into executable, there are several intermediatery steps involved to produce an executable. <br>
There was a subject in my previous sem called "Compiler Design" or "Language Translator" and as the name suggests it taughts us about various phases of compiler and how it really compiles a program, what sections are involved, how everything is managed etc, So there are total of 6 Phases of compiler involved - (Just for reference, will not go into much detail.)
- Lexical Analysis
- Syntax Analysis
- Symantic Analysis
- Intermediate Code Generation
- Code Optimization
- Target Code Generation

and after the target code generation, the most important part is played by Linker and Loader, in brief<br> **Linkers** are responsible for combining multiple object files and libraries into a single executable file and <br>
**Loader** - are responsible for loading the executable file into memory, preparing it for execution, allocating memory for the program, set up the runtime environment, and transfer control to the program's entry point, allowing it to start executing.<br>
(Don't worry if it's too exhaustive and if you're unable to understand it, will cover each and every point in detail).

#### Linker
When a compiler creates the final executable code, it often needs to include functions from libraries. This is because the computer's CPU cannot run the code on its own. Even if the compiler produces machine code directly, it still needs an object module that contains the code and information about library functions and other programs required for execution.
That's when the linked came in the picture, Linker accepts the object module and extracts all the information out of it. The linker then locates the required library routine and other programs and combines them with the target code. It then generates a machine language program. This machine language program or binary program is self-efficient of executing all alone without the assistance of any other program.

#### Loader
Loader is generated by linker as a binary program and places it on hard disk, where it loads or places the machine language program or the binary program in the main memory for its execution. Linker is also responsible for Relocation of the memory, for ex in high level languages like C, C++ we can even mention the memory location to allocate from and where to end, where in the memory the program will execute and what section will it aquire, all of this is done by linker only.

![Linkers and Loaders](/blogs/assets/BlogImages/Linker-and-Loader.jpg){: width="650"}

<small>Source - BinaryTerms.com</small>
<br>

### Structure of an Executable.
We can generalize the structure of an executable by this image. If you've spare time do visit the pwnfunction's video on "What is Executable ?". He has explained clearly and from basics about it, but if you don't want to here i am expalining on behalf of pwnfunction. Basically every executable contains some Headers, Sections and Segments and then each of them contains further chunks with information related to executables like in case of ELF there are .text, .data etc, and in case of PE files somewhat similar information like data, pe headers, text etc.
![PwnFunction Executable](/blogs/assets/BlogImages/PwnFunction%20-%20Executable%20Format.png){:id="pwnfunction"}
<br>
<br>
[Note : -](#)
<br>
This few things and some sections remain same in both type of executable. We've discussed somewhat about linux ELF executables but will not focus more on that, now we will be focusing more on windows executables which is of .exe format and are a type of PE file (Portable Executables ), and for linux I think this much of knowledge is enough to get a kickstart in reverse engineering. More focused on PE Files because they can help in our further journey of Reverse Engineering of a Malware. 

### PE Executables
PE stands for Portable Execution and is a file format for executables used for Windows operating system. One thing to note here is not only .exe is a type of pe file, but DLLs, SRVs are type of pe files too. A PE file can be compared with a data structure that holds information necessary for the OS loader to be able to load that executable into memory and execute it.
<br>
A PE file consists of a number of headers and sections that tell the [dynamic linker](#linker) how to map the file into memory. An executable image consists of several different regions, each of which require different memory protection. For instance, typically the .text section (which holds program code) is mapped as execute/read-only, and the .data section (holding global variables) is mapped as no-execute/read write. Part of the job of the [dynamic linker](#linker) is to map each section to memory individually and assign the correct permissions to the resulting regions, according to the instructions found in the headers.
<br>
A typical PE file follows the structure as mentioned below - 

![PE Files 3](/blogs/assets/BlogImages/PEFormat3.avif){: height="450"}
<br>
<small>Source - makeuseof.com</small>

Yup, I Know it's too much to take in but it don't want you focus on everything and overload your brain with unnecessary information that you'll forget the minute you read it, just like in sem exams, but rather will focus on important sections.

### PE Headers

Let's take a look at each one of the [PE File Structure](#structure-of-an-executable) and a breif introduction of them starting with PE Header. The PE header is an essential part of a Windows executable. It contains detailed information about the structure and properties of the executable for the Windows operating system. It also provides information to operating system on how to map the file into memory to properly execute it. The executable code has designated regions that require a different memory protection and RWX permissions (Read, write and execution permission.).
<br>
<br>

![PE Files 2](/blogs/assets/BlogImages/PE2.png){: height="550"}
<br>
<br> The PE header file contains several other chunks of information starting with **DOS Header**.  


#### DOS Header
The DOS header is a relic from the early days of MS-DOS. Its primary purpose is to allow the file to be executed under MS-DOS, which was the predecessor to the Windows operating system, on which the eniter windows os is built. It's main job is to show that it's an MS-DOS executable and contains the MZ field or the magic number as well which for .exe is "4D 5A", or the word "MZ" itself.

#### DOS Stub
It's existence is questionable. Just after the DOS header comes the DOS stub that just prints an error message saying “This program cannot be run in DOS mode” when the program is run in DOS mode. Nowadays this message is just ignored by operating systems.

#### NT Headers
NT Headers provide essential information about the structure and organization of a PE file, allowing the Windows operating system to properly load, execute, and manage the executable. It contains several parts some of them are -
- PE Signature : Located immediately after DOS Stub and identifies the file as PE File.
- COFF Header :  The COFF (Common Object File Format) Header contains information about the format of the executable, including the machine type (e.g., x86, x64), the number of sections, and the timestamp of the file's creation.
- Optional Headers : The Optional Header follows the COFF Header and provides additional details about the executable, such as the image base address (the preferred memory address at which the executable should be loaded), the size of the code and data sections as discussed earlier several high level languages that are closed to low level provides this facilities like C, C++ {[ HERE ](#linker)} and the entry point (the address where execution should start). 

#### Section Tables
This table of section headers provides a structured overview of the executable's layout, helping the Windows operating system load and manage the program's different sections during runtime.

### PE Sections
In a Portable Executable (PE) file format, various sections are used to organize and store different types of data and code. These sections serve specific purposes in the execution of the program. 
- **.text** : also known as the code section, contains the executable code of the program. It includes machine code instructions that are executed when the program runs. This section is typically marked as readable and executable but not writable.

- **.data** : stores initialized global and static variables. These variables have predefined values set at compile time. It is marked as readable and writable but not executable. For ex : Global variables like configuration settings, user data, and constants are stored here.

- **.rdata** : stands for "read-only data," stores data that should not be modified during program execution. It often includes constant strings and data used by the program and is marked as readable but not writable or executable. Data in this section is considered constant.

- **.rsrc** : .rsrc or resource section, stores various resources used by the program's user interface, such as images, icons, strings, and other non-executable data. It is marked as readable but not writable or executable.

---

# Labs
We've nearly finished our theory lessons, and we're almost ready to begin reversing small applications. Before diving into debuggers and certain other application we've to get ourselves familier with Assembly level language, which is actually the closest to the machine language we can get. So to start with real labs we've to look at the **Lowest Level Possible** !!.

## The lowest level possible ?

As discussed earlier in our [Existential Crisisis](#why-were-doing-this-) phase, x86 assembly language is the closest or the lowest level we can reach to communicate directly with hardware and registers. To gain a deeper understanding of x86 architecture and assembly language, you can refer to my frustration expressed in the article [x86 Assembly, What the hell is it ?](/2023/08/23/x86-Assembly.html)

### The Last Boring Part

[x86 Assembly, What the hell is it ?](/2023/08/23/x86-Assembly.html)

That really was a journey though, now assuming you does have knowledge of assembly we will be movie with our first reverse engineering file.

### We should know about gdb !

Before jumping directly to gdb, let's glance around a little bit. <br>
(I'm using one of the crackmes you can find [here](#) just to display some gdb usage.)
```bash
$ objdump -M intel -d assfile
```
```bash
helloWorld:     file format elf64-x86-64

Disassembly of section .text:

0000000000401000 <_start>:
  401000:	b8 01 00 00 00       	mov    eax,0x1
  401005:	bf 01 00 00 00       	mov    edi,0x1
  40100a:	48 be 00 20 40 00 00 	movabs rsi,0x402000
  401011:	00 00 00
  401014:	ba 12 00 00 00       	mov    edx,0x12
  401019:	0f 05                	syscall
  40101b:	b8 3c 00 00 00       	mov    eax,0x3c
  401020:	bf 00 00 00 00       	mov    edi,0x0
  401025:	0f 05                	syscall


```
objdump generally is used to get the expected assembly code from the generated machine code. Now getting further in gdb we'll be using "gef" or gdb enhanced feature which provides many features like multi architecture support, various commands for debugging and much more.
To get brief information regarding what the file is, it's type etc we can use the file command here.
```bash
$ file helloworld.asm
```

```bash
$ firstprog: ELF 64-bit ELF executable, x86-64, version 1 (SYSV), dynamically linked, interpreter
 /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX, stripped
```
Now let's start digging gdb a bit further - <br>
We can know about the elf or the binary file more using elf-info command.
```bash
$ gef > # elf-info
```

```bash
GEF for linux ready, type `gef' to start, `gef config' to configure
89 commands loaded and 5 functions added for GDB 10.1.90.20210103-git in 0.00ms using Python engine 3.9
Reading symbols from arm_crack1...
(No debugging symbols found in arm_crack1)
gef➤  elf-info
Magic                 : 7f 45 4c 46
Class                 : 0x1 - ELF_32_BITS
Endianness            : 0x1 - LITTLE_ENDIAN
Version               : 0x1
OS ABI                : 0x0 - SYSTEMV
ABI Version           : 0x0
Type                  : 0x2 - ET_EXEC
Machine               : 0x28 - ARM
Program Header Table  : 0x00000034
Section Header Table  : 0x000011a0
Header Table          : 0x00000034
ELF Version           : 0x1
Header size           : 52 (0x34)
Entry point           : 0x00008591

```
To get the information about functions used we can use info-functions command, same applies for identifying variables cause in man ctfs the flag was hidden in one of the variables.

```bash
$ gef➤  info functions
All defined functions:

Non-debugging symbols:
0x000084e4  abort@plt
0x000084f0  __libc_start_main
0x000084f0  __libc_start_main@plt
0x000084fc  signal@plt
0x00008508  __gmon_start__@plt
0x00008518  ptrace
0x00008518  ptrace@plt
0x00008524  fgets@plt
0x00008530  system@plt
0x0000853c  memcpy@plt
0x00008548  alarm
0x00008548  alarm@plt
0x00008554  printf
0x00008554  printf@plt
0x00008560  malloc@plt
0x0000856c  __stack_chk_fail
0x0000856c  __stack_chk_fail@plt
0x00008578  puts
0x00008578  puts@plt
0x00008584  exit
0x00008584  exit@plt

```
To disassemble a function we can simply write this - 

```bash
$ gef➤  disas alarm
Dump of assembler code for function alarm@plt:
   0x00008548 <+0>:	add	r12, pc, #0, 12
   0x0000854c <+4>:	add	r12, r12, #8, 20	; 0x8000
   0x00008550 <+8>:	ldr	pc, [r12, #2780]!	; 0xadc
End of assembler dump.

```
Noticable thing in all of these are the memory address, they helps a lot while debugging or during reverse engineering or observing some cases. Let's take a look at some of the commands that we will be using quite frequently, starting with - 
- **break** : break command is used to set the breakpoint at a particular address or function. It pauses the flow of program at that particular step so that we can observe the running program at each step. For example to set a breakpoint at a main function we would write - 

```bash
$ gef > break main
```
and then when we run the program using "run" or "r", it will stop at main and will show the current register and stack values.
- **rip** : One thing we should have notices till now is every address displayed is relative to register or pointer rip, $rip.
so if we've to view the value stored at particular address say 0x4533223, we've write - 
```bash
$ gef > x/s $rip + 0x4533223
```
which will eventually give us the value stored at that address. The "s" here represents the string, if we've to display the data in any other form we can do that as well.

- **registers** : At each step gdb does display the view of stack and register but for any reason if we want to view the current content and status of registers we can use : 
```bash
$ gef > registers
```
- **steps** : We can move step by step or by defining how much steps jump we've to take, we can do this by "n" or displaying the jump value "n 10".

- **Addresses** : we can modify the contents of registers at any particular incident using "set" command. 
```bash
set $rax = new_value
```
And now I  think finally we can move to our Real journey !!

## Reverse Engineering

### Don't Compare

Yeah we are going to **compare** !! infact we're going to compare a LOT !!. Before starting with anything we would start with basic, i.e comparing !!, that means to really understand what's really going on in the background we will compare, the code we've written and the assembly of it, that really gives us an idea to understand code even better and will help us in our further RE journey.<br>

**Let's get started !!** 

### Novice Comparer

**I. The OG, "Hello World" -**<br>
We will start with writing a "C/C++" program of hello world and then comparing it with it's assembly equivalent.
```c
#include <iostream.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
  printf("Hello World !! ");

  return 0;
}
```
You can play along here , but let's just jump into what's happening here.
<iframe width="850px" height="600px" src="https://godbolt.org/e#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:___c,selection:(endColumn:30,endLineNumber:5,positionColumn:30,positionLineNumber:5,selectionStartColumn:30,selectionStartLineNumber:5,startColumn:30,startLineNumber:5),source:'%23include+%3Cstdio.h%3E%0A%23include+%3Cstdlib.h%3E%0Aint+main(int+argc,+char*+argv%5B%5D)%0A%7B%0A++++printf(%22Hello+World+!!!!%22)%3B%0A++++return+0%3B%0A%7D'),l:'5',n:'0',o:'C+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:compiler,i:(compiler:cg121,deviceViewOpen:'1',filters:(b:'0',binary:'1',binaryObject:'1',commentOnly:'0',debugCalls:'1',demangle:'0',directives:'0',execute:'0',intel:'0',libraryCode:'0',trim:'1'),flagsViewOpen:'1',fontScale:17,fontUsePx:'0',j:1,lang:___c,libs:!(),options:'',overrides:!(),selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:1),l:'5',n:'0',o:'+x86-64+gcc+12.1+(Editor+%231)',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4"></iframe>

I presume that you do know about x86 assembly....<br>
To find the equivalent c code of the assembly we can just hover into and we can see it's equivalent code is highlighted and vice versa. Now if we look at the c code and it's equivallent, the most funniest part (In my opinion) is if you hover over the first 4 assembly instruction you'll get to know that it's equivalent code is not highlighted in C !!, why ? cause this part of the code is just preparing the register and stack. The first 3 lines prepare rbp to set 16 blocks away, declaring the stack for "if" space is required for any variable. Genrally argc and argv are stored in the registers edi and rsi hence the next 2 instructions are declaring pointer or storing the value pointer to edi and rsi into stack. So the main code starts from the VIth line !!.<br>
These are things that i spent a significant amound during my start to figure out what it really does, it have taken me a significant amount to figure out how to ignore these things and that's what we're going to do now. The rest can be figured out easily, where the next instruction stores the address of our string variable and finally calling printf function.

**II. The What If of loops ? -**<br>

Let's try moving on with loops and If-else statement. Consider this simple program i've written here consisting of simple if-else and loops, also taking argument with argc. A simple program checking if the char array contains 'c' or not.

<iframe width="850px" height="600px" src="https://godbolt.org/e#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:___c,selection:(endColumn:39,endLineNumber:5,positionColumn:39,positionLineNumber:5,selectionStartColumn:39,selectionStartLineNumber:5,startColumn:39,startLineNumber:5),source:'%23include+%3Cstdio.h%3E%0A%23include+%3Cstdlib.h%3E%0Aint+main(int+argc,+char*+argv%5B%5D)%0A%7B%0A++++for(int+i%3D0%3B+argv%5Bi%5D+!!%3D+!'%5C0!'%3B+i%2B%2B)%0A++++%7B%0A++++++++if(argv%5Bi%5D+%3D%3D+!'c!')%0A++++++++%7B%0A++++++++++++printf(%22Contains+C+!!!!%22)%3B%0A++++++++++++break%3B%0A++++++++%7D%0A++++++++if(argv%5Bi%2B1%5D+%3D%3D+!'%5C0!')%0A++++++++++++printf(%22No+C+in+here+!!!!%22)%3B%0A++++%7D%0A++++printf(%22Hello+World+!!!!%22)%3B%0A++++return+0%3B%0A%7D'),l:'5',n:'0',o:'Hello+world',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:compiler,i:(compiler:cg121,deviceViewOpen:'1',filters:(b:'0',binary:'1',binaryObject:'1',commentOnly:'0',debugCalls:'1',demangle:'0',directives:'0',execute:'0',intel:'0',libraryCode:'0',trim:'1'),flagsViewOpen:'1',fontScale:17,fontUsePx:'0',j:1,lang:___c,libs:!(),options:'',overrides:!(),selection:(endColumn:8,endLineNumber:2,positionColumn:8,positionLineNumber:2,selectionStartColumn:8,selectionStartLineNumber:2,startColumn:8,startLineNumber:2),source:1),l:'5',n:'0',o:'+x86-64+gcc+12.1+(Editor+%231)',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4"></iframe>

Now many things in that assembly is useless, let's figure out things we need to focus !!.<br>
If we take a look at the main function, the first few lines as discussed earlier are just preparing the stack and registers, the main code starts just before the jmp statement.
```asm
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     DWORD PTR [rbp-20], edi # address for storing argc
        mov     QWORD PTR [rbp-32], rsi # address for storing argv
        mov     DWORD PTR [rbp-4], 0
        jmp     .L2
```
You can play along with above code, but let's try to figure things out using just assembly.
edi and rsi are registers to keep track of argc and argv, the second last statement is assigning something at position [rbp-4] to 0 and then jumping to .L2 label.
Just write it down and we will see if it's being used . Now jumping to label ".L2", we see the code as - <br>
```asm
.L2:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-32]
        add     rax, rdx
        mov     rax, QWORD PTR [rax]
        test    rax, rax
        jne     .L6
```
Let's focus on the important part here, pointer's address assigned to the address rbp-4 with value 0, is being moved to eax register, that can mean that it has some use. Moving with the next line after cdqe ["leaving it for as it is for some time "], 
lea rdx, [0+rax*8], the address rax is pointing to is our argv,  it's taking the initial value, or i should say it's address i.e argv[i] and storing it in rdx register so "loading" it's "effective address" to the rdx register, i.e lea rdx, [0+rax*8]<br>
Now this particular line, is an offset !! [ presuming you know about offsets !! ], offset to keep getting incrementing argv, why ? let's move ahead.
Moving on to the next line, if we recall the [rbp-32] address was initialized to store argv, moving it's value to the rax register, the next line is pretty interesting !!. "add rax, rdx" which means adding rax and rdx and then storing the result in the second register i.e rax.<br>
 - rax was containing - argv address <br>
 - rdx was contaning [0+rax*8]<br>

adding both of them gives us the offset to their effective address hence getting the value stored at argv[i] !!!!.<br>
So now rax contains the value stored at argv[i] or argv[0] and the offset will keep increasing using rdx's offset address being stored.<br>
The next two lines test if the value stored at rax is either 0 or not, if it's not the it'll jump into .L6, so will we.<br>
What we've understood till now let's summarize from it and write it down properly !!. it stores 0 at eax, initializes with offset and get's the first value of argv[i], which is argv[0], which hints us that it'll be the part of loop, and there can be something related to argv.Assuming first value is non-zero le'ts just jump to .L6 <br>

```asm
.L2:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-32]
        add     rax, rdx
        mov     rax, QWORD PTR [rax]
        cmp     rax, 99
        jne     .L3
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        jmp     .L4
```

That's a lot !! still can't give up !! will not give up !!.<br>
Let's summarize what we've done till now, since i'm picking after 2 weeks of these.., It starts with setting a variable value to zero, we assumed that it can usefull in the later sections, then it jumpts to .L2 sections, we analyzed it to conclude that it's taking the initial value of argv, and assigning a pointer to it by getting the effective address from the offset and storing it in rax which i think will be used late to access the values of argv array, and at last, it checks if the test value is 0 or not basically checking it's value if it's not it'll jump to .L6 !!.

```asm
.L6:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-32]
        add     rax, rdx
        mov     rax, QWORD PTR [rax]
        cmp     rax, 99
        jne     .L3
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        jmp     .L4

```
I guess the first 5 lines are now readable easily, moving to the mov rax, QWORD PTR [rax], moving value of rax pointing to the the rax register itself, then comparing it with 99 ????? 
Interesting !!, 99 is the ascii value of 'c', probablity is it's comparing if the rax is holding c or not, if it is holding the ascii character 'c' then it will move forward, otherwise it'll call .L3 so it means it's comparing a string characters in a loop which is inputted while running and storing the string in argv, let's see what .L3 brings us to if the char is not ascii 'c'.

```asm
.L3:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        add     rax, 1
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-32]
        add     rax, rdx
        mov     rax, QWORD PTR [rax]
        test    rax, rax
        jne     .L5
        mov     edi, OFFSET FLAT:.LC1
        mov     eax, 0
        call    printf
```

rax previously was holding the string char, the first 5 lines ig you can analyze to know it does - adds 1 to it's initial value which curretnly is 0, load the effective address to rdx, move the argv value to rax, add both of them, mov the value of pointer at rax to rax and then tests it, meaning a bitwise and to rax, so if non zero it jumps to .L6 !!, now the interesting part !!
```asm
.L5:
        add     DWORD PTR [rbp-4], 1

```
.L5 just adds 1 to it and then the moves to the next instruciton line after .L5 which is .L2 !!! the starting point of the whole program !!!!.
Let's conclude from our findings and the rest will be the work for you.
It starts with storing value 0, then calculates the offset and effective address of argv and get's it's value, compares it with character 'c', if it's not equal, increment the rax i.e i and the control get's back to L2 starting the whole process, so we're pretty sure what the program do now aaaaaaand VOILĽA !!, you've done your first RE of a program !!!!!. 

### Adequate Comparer
Well you've make it till here, so let's go for our first Crackmes !!<br>

Both of these sections are still in development and I'm currently in my final year of BTech, with ongoing endsem exams. Will finish these once i start my internship in Jan but still i decided to upload the blogs as i've invested much time collecting, reading, and writing about these times and it's totally worth it in the end.<br>
Hope you enjoyed both of blogs, do checkout my about section, my current and future projects or to know more about me !!.
Thanks !!!>

### Seldom Comparer

<br> Still  In Development Phase.

## Bonus 
These are the Questions I asked myself in this process starting with - <br>
Q. Why PE files are named as "**Portable Executables**" ?<br>
Q. Why there's a need of object files ? or several intermediate files ?<br>

