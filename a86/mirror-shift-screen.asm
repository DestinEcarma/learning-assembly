mov ds, 0b800h

mov dx, 0
mov di, 0

init:
    mov si, di
    add si, 158
    mov cx, 0

mirror:
    mov al, b[ds:di]
    mov b[ds:si], al

	mov al, b[ds:di + 1]
	mov b[ds:si + 1], al

	add di, 2
    dec si, 2

    inc cx
    cmp cx, 40
    jl mirror

    add di, 80
    cmp di, 4000
    jl init

mov dx, 80

reset:
    mov di, 158
    mov si, 160

    mov al, b[ds:di]
	mov ah, b[ds:di + 1]

    mov bl, b[ds:si]
	mov bh, b[ds:si + 1]

shift:
    mov cl, b[ds:di - 2]
    mov b[ds:di], cl
	mov cl, b[ds:di - 1]
	mov b[ds:di + 1], cl

    mov cl, b[ds:si + 2]
    mov b[ds:si], cl
    mov cl, b[ds:si + 3]
    mov b[ds:si + 1], cl

    sub di, 2
    add si, 2
    cmp di, 0
    jg shift

    mov b[ds:di], al
	mov b[ds:di + 1], ah

    mov b[ds:si], bl
	mov b[ds:si + 1], ah

    mov cx, 0ffffh

delay_loop:
  loop delay_loop

dec dx
cmp dx, 0
jg reset
    
int 20h
