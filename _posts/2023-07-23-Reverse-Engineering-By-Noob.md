---
# layout: post
title:  "Reverse Engineering 101"
tags: "Reverse Engineering"
---

<script src="/_site/assets/gif-control.js"></script>

### The Initiation
Starting with anything is always a tough job for me, where to start, how to start, where to look for and what not.
I did a lot of 'em and specially the last one.  So, here I am, ready to chat about all these things—what I've tried (which you might want to avoid) and what I should've tried (but didn't).  Phew that was a mouthfull, anyways <br> This module is going to be a lenghty one but will be filled with information to get a kick start in Reverse Engineering so you don't have to search the whole internet for every next step.
**Let's Get started**

#### What you'll learn
- Setting up a safe virtual environment. ([Note](#) We will only talk about reversing basic application in this project, but still safety first.)
- Going over operating system and assembly concepts.
- Disassembler, Debuggers, & Information Gathering
- Narrow down specific information and indicators before moving on to deeper static and dynamic analysis.
- How to jump into code in static disassembly then rename and comment on interesting assembly routines that you will debug.
<br>

Let's cover the basics first, So what exactly is reverse engineering ? and who exactly is a Reverse Engineer ?
<br>
- A Reverse engineering is akin to disassembling a device to uncover its inner workings and understand how it functions. 
- A reverse engineer is an individual who practices this [ART](#) Dismantling objects to unravel their workings, enjoying the challenge of puzzles, devising experiments and tools, embracing unconventional thinking, and maintaining a thirst for continual learning.
<br>

The first question that came into my mind is "Why we're doing this ? ", well because the executable we get is in machine code and not in human readable form, so we can't just predict or know by reading the assembly code what it really means. As mentioned earlier it's in the form of machien code and we have to generate the original code by **Reverse Engineering** the machine code to get an idea of what the original code would have been like. That's what reverse engineering is, But again -

### Why we're doing this ?
![GIF 1](/BlogImages/WindowArch.gif){:id="gif1"}
<small>Source - Malware Unicorn</small><br>
<br>
By "Why we're doing this" I mean why depending on compilers and various intermediate code ? and not communicating with hardware directly ?<br>
The simple and to the point to this question would be **Because we are not capable to do so**. If you take a look at my blog post on [x86 assembly language](#), you'll come to understand that writing assembly language (one of the lowest-level programming languages) is highly complex. It involves various components, each with its own set of instructions and protocols. Writing assembly code for every hardware component would be impractical and error-prone. High-level languages abstract these complexities, providing simpler and more human-readable code. Most importantly, they don't compromise our productivity at all. We just have to follow their syntax, and we can accomplish our tasks without writing pages of code for simple calculations<br>
For your reference [this](https://gist.github.com/jonaed1230/8271be857f35970fbd3e81dc6630d322) is the code of calculator in assembly languages.



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
<br>

#### Structure of an Executable.
We can generalize the structure of an executable by this image. If you've spare time do visit the pwnfunction's video on "What is Executable ?". He has explained clearly and from basics about it, but if you don't want to here i am expalining on behalf of pwnfunction. Basically every executable contains some Headers, Sections and Segments and then each of them contains further chunks with information related to executables like in case of ELF there are .text, .data etc, and in case of PE files somewhat similar information like data, pe headers, text etc.
![PwnFunction Executable](/BlogImages/PwnFunction%20-%20Executable%20Format.png){:id="pwnfunction"}
<br>
<br>
[Note : -](#)
<br>
This few things and some sections remain same in both type of executable. We've discussed somewhat about linux ELF executables but will not focus more on that, now we will be focusing more on windows executables which is of .exe format and are a type of PE file (Portable Executables ), and for linux I think this much of knowledge is enough to get a kickstart in reverse engineering. More focused on PE Files because they can help in our further journey of Reverse Engineering of a Malware. 

### PE Executables

---

Still  In Development Phase.