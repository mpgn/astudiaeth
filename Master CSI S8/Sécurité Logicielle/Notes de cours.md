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


## Attaques

  * buffer overflow
  * ret2libc
  * ret2plt
  * rop


## Protections

  * NX
  * ASLR
  * PIE
  * SSP (canaries)
  * RelRO


## x86 vs x86_64

---                   | x86          | x86_64
---                   | ---          | ---
adresses              | 4 octets     | 8 octets
passage de paramètres | sur la stack | dans les registres (rdi, rsi, rdx, rcx, r8, r9) puis sur la stack
appels système        | int 80h      | syscall


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


# ASM

---              | Intel                          | AT&T
---              | ---                            | ---
register         | eax                            | %eax
value            | 1                              | $1
instruction      | instr dest,source              | instr source,dest
pointed address  | [eax]                          | (%eax)
memory operand   | segreg:[base+index*scale+disp] | %segreg:disp(base,index,scale)



## Divers

  * On peut faire une attaque en utilisant `execve` en passant `NULL` et `NULL` dans ECX et EDX (en x86).
  * `fork` ne re-randomize pas la mémoire, `execve` si
