mov ds, 0b800h

mov dx, 0
mov di, 0

init:
	mov si, di				; Copy the value of register `di` onto register `si`
	add si, 158				; Make register `si` the last index on the current line 
	mov cx, 0				; Register `cx` will serve as the counter for mirror

mirror:
	mov al, b[ds:di]		; Store the current character of register `di`
	mov b[ds:si], al		; Set the last index from the stored character

	mov al, b[ds:di + 1]	; Store the current attribute
	mov b[ds:si + 1], al	; Set the last index from the stored attribute

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
	mov di, 158				; Make register `di` the last index on the first line
	mov si, 160				; Make register `si` the first index on the second line

	mov al, b[ds:di]		; Store the current character from register `di`
	mov ah, b[ds:di + 1]	; Store the current attribute

	mov bl, b[ds:si]		; Store the current character from register `si`
	mov bh, b[ds:si + 1]	; Store the current attribute

shift:
	mov cl, b[ds:di - 2]	; Store the previous character of register `di`
	mov b[ds:di], cl		; Set the current character
	mov cl, b[ds:di - 1]	; Store the previous attribute
	mov b[ds:di + 1], cl	; Set the stored attribute

	mov cl, b[ds:si + 2]	; Store the previous character of register `si`
	mov b[ds:si], cl		; Set the current character
	mov cl, b[ds:si + 3]	; Store the previous attribute
	mov b[ds:si + 1], cl	; Set the stored attribute

	sub di, 2
	add si, 2
	cmp di, 0
	jg shift

	mov b[ds:di], al		; Set the stored character from register `al`
	mov b[ds:di + 1], ah	; Set the attribute from register `ah`

	mov b[ds:si], bl		; Set the stored character from register `bl`
	mov b[ds:si + 1], bh	; Set the attribute from register `bh`

	mov cx, 0ffffh

delay_loop:
	loop delay_loop

dec dx
cmp dx, 0
jg reset
    
int 20h
