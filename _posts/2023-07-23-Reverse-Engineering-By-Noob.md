---
# layout: post
title:  "Reverse Engineering 101"
tags: "Reverse Engineering"
---

<script src="/_site/assets/gif-control.js"></script>

#### The Initiation
Starting with anything is always a tough job for me, where to start, how to start, where to look for and what not.
I did a lot of 'em and specially the last one.  So, here I am, ready to chat about all these things—what I've tried (which you might want to avoid) and what I should've tried (but didn't).  Phew that was a mouthfull, anyways <br> This module is going to be a lenghty one but will be filled with information to get a kick start in Reverse Engineering so you don't have to search the whole internet for every next step.
**Let's Get started**

#### What you'll learn
- Setting up a safe virtual environment. ([Note](#) We will only talk about reversing basic application in this project, but still safety first.)
- Going over operating system and assembly concepts.
- Disassembler, Debuggers, & Information Gathering
- Narrow down specific information and indicators before moving on to deeper static and dynamic analysis.
- How to jump into code in static disassembly then rename and comment on interesting assembly routines that you will debug.

---

Let's cover the basics first, So what exactly is reverse engineering ? and who exactly is a Reverse Engineer ?
<br>
- A Reverse engineering is akin to disassembling a device to uncover its inner workings and understand how it functions. 
- A reverse engineer is an individual who practices this [ART](#) Dismantling objects to unravel their workings, enjoying the challenge of puzzles, devising experiments and tools, embracing unconventional thinking, and maintaining a thirst for continual learning.

### Why we're doing this ?
![GIF 1](/BlogImages/WindowArch.gif){:id="gif1"}
<small>Source - Malware Unicorn</small><br>

### Executables
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

![Linkers and Loaders](/BlogImages/Linker-and-Loader.jpg){:id="Linkers and Loaders"}

<small>Source - BinaryTerms.com</small>

---

We've discussed somewhat about linux ELF executables but will not focus more on that, now we will focus a bit more on windows executables which is of .exe format and are a type of PE file.

### PE Executables


---

Still  In Development Phase.