* ROM routines
        lst off
*
home    equ $FC58
text    equ $FB2F
cout    equ $FDED
vtab    equ $FC22
getln   equ $FD6A
bascalc equ $FBC1
return  equ $FD8E      ; print carriage return
clreop  equ $FC42      ; clear from cursor to end of page
clreol  equ $FC9C      ; clear from cursor to end of line
xtohex  equ $F944
rdkey   equ $FD0C      ; wait for keypress
auxmov  equ $C311
xfer    equ $C314
wait    equ $FCA8
outport equ $FE95
*
* page 0
*
cv      equ $25
ch      equ $24 
wndlft  equ $20
wndwdth equ $21
wndtop  equ $22
wndbtm  equ $23 
prompt  equ $33
*