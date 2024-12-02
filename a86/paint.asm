mov ds, 0B800h

call paint_start
int 20h

paint_start:
	mov ah, 1h
	int 21h
	cmp al, 30h
	je paint_end
	call change_color

	call get_mouse_index
	mov byte [ds:di + 1], al

	jmp paint_start
paint_end:
	mov dl, 0Dh
	mov ah, 02h
	int 21h
	mov dl, 0Ah
	mov ah, 02h
	int 21h
	ret

change_color:
	cmp al, 31h
	je red
	cmp al, 32h
	je green
	cmp al, 33h
	je blue
	ret

	red:
		mov al, 44h
		ret
	green:
		mov al, 22h
		ret
	blue:
		mov al, 11h
		ret

get_mouse_index:
	push ax
	mov ax, 3h
	int 33h

	shr cx, 2
	shr dx, 2

	imul dx, 80
	add dx, cx

	mov di, dx
	pop ax
	ret
