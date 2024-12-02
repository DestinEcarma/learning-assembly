call read_integer
mov bx, ax					; Save the first number

call read_integer			; Second number is already in ax

add ax, bx					; Add the two numbers
call print_integer

int 20h

read_integer:
	push bx
    xor ax, ax
	xor bx, bx
read_loop:
    mov ah, 01h				; Wait for a key to be pressed
    int 21h					; Call the interrupt to get the character
    cmp al, 0Dh				; If the user presses enter, we are done reading 0Dh is `\r` in ASCII
    je read_done
    imul bx, 10				; Simple number manipulation, simply adding offset for the new digit
	sub ax, 304				; This is necessary, not sure why 304 is being added to a single digit, 1 would be 305 and 2 would be 306 ... 9 would be 313
	add bx, ax
    jmp read_loop
read_done: 
	mov ax, bx				; Return the number to ax register, it's common to use ax register since it is the accumulator
	pop bx
    ret

print_integer:
    xor cx, cx
    cmp ax, 0
    jne print_loop			; If the number is not 0, print the digit else print 0
    mov dl, '0'
    mov ah, 02h
    int 21h
    ret
print_loop:
    xor dx, dx
    mov bx, 10				; Dividing by 10 to get the digits
    div bx					; Dividing ax by bx, quotient in ax and remainder in dx
    add dx, '0'				; Convert the digit to ASCII
    push dx					; Push the digit to the stack
    inc cx					; Seems like it's not necessary, but it's being used to loop through the digits
    test ax, ax				; This is similar to cmp ax, 0, cmp is an arithmetic operation, test is a logical operation
    jnz print_loop
print_digits:
    pop dx					; Pop the digit from the stack
    mov ah, 02h				; DOS interrupt to print the character, register dl will be used here, that is why we are using the register dx
    int 21h					; Call the interrupt
    loop print_digits		; Where register cx is being used, we could just simply check if sp (stack) is empty, but why bother
    ret
