************************
*   PROGRAM Quicksort  *
************************
* Implements and test Quicksort 
* Using a non recursive algorithm
*
* Sorts random bytes using a stack
* $2000 : random bytes
* $7000 : stack 
* $8000 : program
*
        put const       ; file of equ
        put macros      ; file of macros

*********************************************
*  Bug fix :
* 08/2021 : the program genrated 4096 random bytes, instead of 2 x 4096 bytes
* needed for 4096 integer (2 bytes per integer)
*
sptr    equ $06         ; pointer to stack in zero page
ptr2    equ $08         ; pointer in zero page
sbase   equ $7000       ; base address of stack 
datab   equ $2000       ; base address of data

        org $8000
* init stack
        lda #$00        ; init stack counter 
        sta scount
        sta scount+1
        lda #<sbase     ; init sptr to stack base address
        sta sptr
        lda #>sbase+1
        sta sptr+1

* init data pointer

*
*  ======= Home ==========
*
        lda #$03
        jsr outport
        jsr home
        printc strib
        cr
        prnstr strib2
        cr
        cr
        prnstr sgene


* poke dnb x 2 random bytes (2 bytes per integer)
        jsr initrandom
        lda dnb
        sta tempo
        lda dnb+1
        sta tempo+1
        *  Bug fix 08/2021 :
        asl tempo       ; tempo = tempo * 2
        rol tempo+1
        *
        lda pkrd+1      ; save self modified address
        sta tempo3
        lda pkrd+2
        sta tempo3+1
pokernd jsr random
pkrd    sta datab       ; self modifying 
        jsr random
        sta datab+1
        m_inc pkrd+1
        m_dec tempo
        lda tempo
        ora tempo+1
        bne pokernd
        lda tempo3      ; restore self modified address 
        sta pkrd+1
        lda tempo3+1
        sta pkrd+2

        cr
        prnstr ssorting
*
* * * * * MAIN LOOP * * * * * 
*
*stack.push(0); // left
        lda #$00
        sta tempo3
        sta tempo3+1
        sta tempo
        sta tempo+1
        jsr push
*stack.push(arr.length - 1); // right
        movshort dnb;tempo;2
        m_dec tempo
        jsr push


*
* LOOP 1
* do {
* int right = stack.pop();
loop1   jsr pop
        movshort tempo;Rright;2

*int left = stack.pop();
        jsr pop
        movshort tempo;Lleft;2
* --subArray;
        m_dec scount
*
* LOOP 2
*int _left = left;
*int _right = right;
loop2   movshort Lleft;left;2
        movshort Rright;right;2 
* 
*int pivot = arr[(left + right) / 2];
        lda left+1        ; tempo1 = left / 2
        lsr
        sta tempo1+1
        lda left
        ror 
        sta tempo1

        lda right+1       ; tempo2 = right  / 2
        lsr
        sta tempo2+1
        lda right
        ror 
        sta tempo2 

        lda tempo1      ; tempo1 tempo1 + tempo2
        clc
        adc tempo2
        sta tempo1
        lda tempo1+1
        adc tempo2+1
        sta tempo1+1

* pivot = array[tempo1] 
        getelem datab;tempo1;pivot 

* LOOP 3

*while (pivot < arr[_right]) {
* _right--;
* }
* tempo = array[right] > pivot ?
loop3   nop
doright getelem datab;right;tempo
        sup tempo;pivot         ; is tempo > pivot ?
        bcc next1               ; no : go next
        m_dec right             ; yes : dec right
        jmp doright             ; and loop       

next1   nop
* while (pivot > arr[_left]) {
* _left++;
* }
doleft  getelem datab;left;tempo
        sup pivot;tempo         ; is pivot > tmepo ?
        bcc next2               ; no : go next
        m_inc left              ; yes : inc left
        jmp doleft              ; and loop

next2   nop
* if (_left <= _right) { "permut" }
        ssupeq right;left
        bcs next3               ; right >= left : permut
        jmp next6               ; else : jump over
* permut :
* if (_left != _right) {
* int temp = arr[_left];
* arr[_left] = arr[_right];
* arr[_right] = temp;
* }

next3
        equal left;right        ; left = right ?
        bcc permut              ; no : go permut
        jmp next5               ; yes : go next

permut  getelem datab;left;tempo        ; permut array[left] and array[right]
        getelem datab;right;tempo2
        setelem datab;left;tempo2
        setelem datab;right;tempo
        inc tempo3
        bne next5
        lda #"."
        jsr cout
*
next5
* _right--;
* _left++;
        m_dec right
        m_inc left
*
next6   nop             ; here if !(_left <= _right)
* } while (_right >= _left); ==> LOOP 3
        ssupeq right;left       ; right >= left ?
        bcc next7               ; no : go next
        jmp loop3               ; yes : loop
*
next7
* if (_left < right) {
* ++scount;
* stack.push(_left);
* stack.push(right);
* }
        ssup Rright;left        ; Rrght > left ?
        bcc next8               ; no : go next
        m_inc scount            ; inc stack counter
        movshort left;tempo;2
        jsr push
        movshort Rright;tempo;2
        jsr push
*
next8 
* right = _right;
        movshort right;Rright;2

* } while (left < right); // ==> LOOP 2
        ssup Rright;Lleft        ; Rrght > left ?
        bcc next9
        jmp loop2
*
next9
* } while (scount > -1);  // ==>  LOOP 1
        lda #$FF 
        sta tempo
        sta tempo+1
        ssup scount;tempo
        bcc next10
        jmp loop1
*
next10  cr
        prnstr scheck
        jsr check
        bcc endprog
doerr   cr
        prnstr serror
        printm ptr2
        cr
        jmp outprg

endprog prnstr snoerr   
        cr
outprg  cr
        cr
        prnstr endstr
        cr
        cr
        rts             ; END of program
* 
*
* * * * DATA * * * *
*
spivot  str "pivot  : "
sscount str "scount : "
sleft   str "left   : "
sright  str "right  : "
sRR     str "Rright : "
sLL     str "Lleft  : "
sspace  str " ; "
endstr  str "End of program : 4096 integers sorted at $2000"
strib   str "A Tribute to Charles Antony Richard Hoare,"
strib2  str "who invented QuickSort algorithm in 1961 !"
sgene   str "Generating 4096 pseudo random 16 bits unsigned integers..."
ssorting str "Sorting..."
scheck  str "Checking..."
serror  str "Error at : "
snoerr  str "no error."

scount  hex 0000
dnb     hex 0010        ; quantity of integers  
*
Rright  hex 0000
right   hex 0000
Lleft   hex 0000
left    hex 0000
pivot   hex 0000
*
tempo   hex 0000
tempo1  hex 0000
tempo2  hex 0000
tempo3  hex 0000
*
*
* STACK routines
*
* Stack : push a 16 bits value on stack
* tempo = pointer to vlue to push
push    nop         
        ldy #$00        
        lda tempo       ; get value from tempo (lo)
        sta (sptr),y    ; drop on stack
        iny
        lda tempo+1     ; get value from tempo (hi)
        sta (sptr),y    ; drop on stack
        lda sptr        ; sptr = sptr + 2 (to point to next free memory)
        clc
        adc #$02
        sta sptr
        lda sptr+1
        adc #$00
        sta sptr+1
epush   rts
*
* Stack : pop a 16 bits value from stack 
pop     nop             ; pop a 16 bits value from stack 
        lda sptr         ; set sptr to sptr-2
        sec
        sbc #$02
        sta sptr
        lda sptr+1
        sbc #$00
        sta sptr+1
        ldy #$00        ; get value
        lda (sptr),y 
        sta tempo       ; to tempo
        iny
        lda (sptr),y 
        sta tempo+1
nodec   rts

* 
* Random number generator
*     
R1       hex 00
R2       hex 00
R3       hex 00
R4       hex 00
*
random  ror R4          ; Bit 25 to carry
        lda R3          ; Shift left 8 bits
        sta R4
        lda R2
        sta R3
        lda R1
        sta R2
        lda R4          ; Get original bits 17-24
        ror             ; Now bits 18-25 in ACC
        rol R1          ; R1 holds bits 1-7
        EOR R1          ; Seven bits at once
        ror R4          ; Shift right by one bit
        ror R3
        ror R2
        ror
        sta R1
        rts
*
* Routine to seed the random number generator with a
* reasonable initial value:
*
initrandom lda $4E        ; Seed the random number generator
        sta R1          ; based on delay between keypresses
        sta R3
        lda $4F
        sta R2
        sta R4
        rts

*
* DEBUG routines
* print vars
dbg 
        jsr debug
        cr
        prnstr sLL
        printm Lleft
        prnstr sspace
        prnstr sRR
        printm Rright

        cr

        prnstr sleft
        printm left 
        prnstr sspace
        prnstr sright
        printm right

        cr

        prnstr spivot
        printm pivot
        prnstr sspace
        prnstr sscount
        printm  scount
        cr 
        jsr rdkey
        cr
        rts 
*
debug   jmp ddbug
ltmp    hex 0000 
ddbug   
        lda #$00
        sta tempo1+1
        sta tempo1
doaff   getelem datab;tempo1;ltmp
        lda #"$"
        jsr cout 
        ldx ltmp+1
        jsr xtohex
        ldx ltmp 
        jsr xtohex
        lda #$A0
        jsr cout
        inc tempo1
        lda tempo1
        cmp #10
        beq doend
        jmp doaff
doend   rts
*
* Checking routine
*
check   
        lda dnb         ; tempo2 = integer count - 1
        sta tempo2
        lda dnb+1
        sta tempo2+1
        m_dec tempo2    ; counter = array size - 1
*
        lda #<datab     ; ptr points to sorted array        
        sta ptr2
        lda #>datab
        sta ptr2+1
*
lcheck  ldy #$0         ; compare integer n and integer n+1
        lda (ptr2),y
        sta tempo
        iny 
        lda (ptr2),y
        sta tempo+1
        iny   
        lda (ptr2),y
        sta tempo1
        iny 
        lda (ptr2),y
        sta tempo1+1
        supeq tempo1;tempo
        bcc erroron     ; tempo1 >= tempo ?                

        m_inc ptr2      ; next integer
        m_inc ptr2
        m_dec tempo2    ; dec counter
        lda tempo2
        ora tempo2+1
        bne lcheck
        clc             ; no error flag
        rts  
erroron sec             ; error flag
        rts



