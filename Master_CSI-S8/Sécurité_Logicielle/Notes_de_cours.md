## Définitions

#### GOT (Global Offset Table)

> Zone mémoire située dans la section .data contenant des adresses pointant vers des fonctions de librairies partagées.


#### PLT (Process Linkage Table)

> Table contenant du code effectuant la résolution pour trouver l'adresse d'une fonction en utilisant la GOT.
> Et qui y rajoute des entrées au besoin.

Dans le code, on référence les fonctions de la PLT, par exemple : `printf@plt` (car on ne connait pas lors de la compilation les adresses où seront chargées les fonctions des librairies partagées).
Si la fonction est dans la GOT, la PLT en retourne l'adresse.
Sinon, la PLT va chercher l'adresse de la fonction dans les librairies partagées, l'ajoute dans la GOT et la retourne.

_remarque_ : À chaque fois que les librairies ne sont pas compilées en statique, on aura besoin de PLT/GOT.


#### Basic block

> Séquence d'instruction continues sans jmp, ret , call..


#### CFG (Control Flow Graph)

> Constitué de basic blocks reliés entre eux, il modélise le flot d'exécution.


## Attaques

  * **buffer overflow**
    - moyenâgeux : écrire un shell code dans la pile ou une variable d'env (NX empêche ça)
    - **ret2libc** (bcp plus dur si ASLR activé)
    - **ret2plt** (Full Relro empêche d'écrire sur la got)
    - **rop** (Return-Oriented Programming, plus dur si ASLR est activé et si le code est compilé en PIE)
    - **blind rop** si ASLR est activée, on aura du mal pour trouver les gadgets. Donc on implement brop. Si le serveur crash mais il ne fait pas la randomisation on peut: 1. lire la stack et faire un leak des canaries et l'address de retour, 2. trouver des gadgets (temps execution) pour faire un write 3. faire un dump du binaire pour trouver gadgets pour executer un shellcode. (en utilisant le write)
    
  * **format string**
    - permet d'écrire sur n'importe qu'elle adresse (qui le permet..)
    - permet de leaker des infos sur la mémoire


## Protections

  * NX = DEP (Pata Execution Prevention) = W^X
  * ASLR (Adresse Space Layout Randomization)
  * PIE/PIC (Position independent executable/code)
  * SSP (Stack Smaching Protection, ce sont les "canaries")
  * Full/Partial RelRO (Relocation Read Only)


## x86 vs x86_64

---                   | x86          | x86_64
---                   | ---          | ---
adresses              | 4 octets     | 8 octets
passage de paramètres | sur la stack | dans les registres (rdi, rsi, rdx, rcx, r8, r9) puis sur la stack, xmm0-xmm9 pour les floats
appels système        | int 80h      | syscall

<img style="width: 50%; margin-left: 25%;" src="http://blog.brakmic.com/wp-content/uploads/2016/08/splitting_eax_register-2.png" alt="registers">

_remarque_ : En 64 bits, faire une operation sur `%eax` va mettre à zéro les 32 autres bits de `%rax`. ("Results of 32-bit operations are implicitly zero extended to 64-bit values. This differs from 16 and 8 bit operations, that don't affect the upper part of registers")

Instructions basique utile: le NOP (0x90).


#### Syscalls

#### x86

EAX  | Name       | EBX                      | ECX         | EDX
---  | ---        | ---                      | ---         | ---
0x01 | sys_exit   | int                      | ---         | ---
0x03 | sys_read   | unsigned int char*       | size_t      | ---
0x04 | sys_write  | unsigned int const char* | size_t      | ---
0x0b | sys_execve | const char*  filename    | char** argv | char** envp

Return values are set into EAX.

#### x86_64

RAX  | Name       | RDI                      | RSI         | RDX
---  | ---        | ---                      | ---         | ---
0x00 | sys_read   | unsigned int char*       | size_t      | ---
0x01 | sys_write  | unsigned int const char* | size_t      | ---
0x3b | sys_execve | const char* filename     | char** argv | char** envp
0x3c | sys_exit   | int                      | ---         | ---

Return values are set into RAX.


## ASM

---              | Intel                          | AT&T
---              | ---                            | ---
register         | eax                            | %eax
value            | 1                              | $1
instruction      | instr dest,source              | instr source,dest
pointed address  | [eax]                          | (%eax)
memory operand   | segreg:[base+index*scale+disp] | %segreg:disp(base,index,scale)


## Reverse engineering et obfuscation

  * Analyse statique (objdump, IDA, r2) vs dynamique (gdb, r2)


### Obfuscation du control flow:

  * déroulage de boucles for
  * inlining de fonctions
  * insertion de junk code
  * prédicats opaques (une condition dont il est dur de savoir si elle est vraie ou pas)
  * control flow flattening


### Obfuscation du data flow:

  * encoder les constantes
  * insérer des "junk data"
  * substitution d'instructions -> a + b devient 3(a \| b) + ... (truc horrible)
  * machine virtuelle (utilise son propre ISA - Instruction Set Architecture)
  * whitebox  -> techniques spécifiques


## Divers

  * On peut faire une attaque en utilisant `execve` en passant `NULL` et `NULL` dans ECX et EDX (en x86).
  * `fork` ne re-randomize pas la mémoire, `execve` si
  * l'ASLR est surtout efficace en 64 bits car en 32 bits l'espace à brute-forcer est beaucoup plus restreint
