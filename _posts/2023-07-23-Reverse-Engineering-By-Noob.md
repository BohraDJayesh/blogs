---
# layout: post
title:  "Reverse Engineering 101"
tags: "Reverse Engineering"
---

<script src="/_site/assets/gif-control.js"></script>

### The Initiation
Getting started with anything has always been a bit challenging for me, where to start, how to start, where to look for and what not, I did a lot of 'em and specially the last one.  So, here I am, ready to chat about all these things — what I've tried (which you might want to avoid) and what I should've tried (but didn't).  It might be a mouthful, but no worries. <br> 
This module is going to be quite extensive, but it will be packed with information to give you a strong start in Reverse Engineering. I'll share everything I know that gave my Reverse Engineering journey a push, so you won't have to scour the entire internet for each next step. And yes, I consider myself a beginner in RE, and I'll stay that way until I achieve something significant in this field.
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
![GIF 1](/assets/BlogImages/WindowArch.gif){: height="400"}<br>
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

![Linkers and Loaders](/assets/BlogImages/Linker-and-Loader.jpg){: width="650"}

<small>Source - BinaryTerms.com</small>
<br>

#### Structure of an Executable.
We can generalize the structure of an executable by this image. If you've spare time do visit the pwnfunction's video on "What is Executable ?". He has explained clearly and from basics about it, but if you don't want to here i am expalining on behalf of pwnfunction. Basically every executable contains some Headers, Sections and Segments and then each of them contains further chunks with information related to executables like in case of ELF there are .text, .data etc, and in case of PE files somewhat similar information like data, pe headers, text etc.
![PwnFunction Executable](/assets/BlogImages/PwnFunction%20-%20Executable%20Format.png){:id="pwnfunction"}
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

![PE Files 3](/assets/BlogImages/PEFormat3.avif){: height="450"}
<br>
<small>Source - makeuseof.com</small>

Yup, I Know it's too much to take in but it don't want you focus on everything and overload your brain with unnecessary information that you'll forget the minute you read it, just like in sem exams, but rather will focus on important sections.

### PE Headers

Let's take a look at each one of the [PE File Structure](#structure-of-an-executable) and a breif introduction of them starting with PE Header. The PE header is an essential part of a Windows executable. It contains detailed information about the structure and properties of the executable for the Windows operating system. It also provides information to operating system on how to map the file into memory to properly execute it. The executable code has designated regions that require a different memory protection and RWX permissions (Read, write and execution permission.).
<br>
<br>

![PE Files 2](/assets/BlogImages/PE2.png){: height="550"}
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

Still  In Development Phase.