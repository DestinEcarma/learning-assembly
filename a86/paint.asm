    mov ds, 0B800h

    call paint_start
    int 20h

paint_start:
    mov ah, 1h                  ; Wait for key to be pressed
    int 21h                     ; Call the interrupt to get the key
    cmp al, 30h                 ; Check if the key is 0, if it is, exit
    je paint_end
    call change_color
    call wait_click_start

    jmp paint_start
paint_end:
    mov dl, 0Dh                 ; Carriage return character (move to the beginning of the line)
    mov ah, 02h
    int 21h
    mov dl, 0Ah                 ; New line character (move to the next line)
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
    mov al, 00h
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

wait_click_start:
    push ax                     ; Save the value of ax, since this was for the color to be changed
    mov ax, 1h                  ; Show mouse cursor
    int 33h                     ; Call interruption to show mouse coursor
wait_click_loop:
    mov ax, 3h                  ; Get the mouse status
    int 33h                     ; Call the interrupt to get the mouse position
    test bx, 1                  ; Check for left mouse click
    jnz click_fired

    jmp wait_click_loop
click_fired:
    mov ax, 0h                  ; Reset mouse
    int 33h                     ; Call interruption to reset mouse

    shr cx, 2                   ; Divide by 4 to get the x coordinate
    shr dx, 2                   ; Divide by 4 to get the y coordinate

    imul dx, 80                 ; Multiply by 80 to get the index
    add dx, cx                  ; Add the x coordindate to the index

    pop ax                      ; Restore the value of ax
    mov di, dx                  ; Move the index to di
    mov b[ds:di + 1], al        ; Change the color of the pixel
    ret
