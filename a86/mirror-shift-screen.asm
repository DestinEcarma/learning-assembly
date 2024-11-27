mov ds, 0b800h

mov dx, 80

reset:
    mov si, 0               ; Register `si` will serve as the constraint for register `di` (si > di)

init:
    mov di, si              ; Set the value to register `si`, this register will serve as the current index
    add di, 158             ; Add the offset, so we reach the end of the screen
    mov al, b[ds:di]        ; Copy the last character

shift:
    mov cl, b[ds:di - 2]    ; Copy the second to the last character from the current index
    mov b[ds:di], cl        ; Display the copied character to the current index

    sub di, 2
    cmp di, si
    jg shift

    mov b[ds:di], al        ; Display the last character, which was stored on label `init`

    add si, 160
    cmp si, 4000
    jl init

    mov cx, 0ffffh          ; Just for quick delay

delay_loop:
  loop delay_loop

dec dx
cmp dx, 0
jg reset

int 20h
