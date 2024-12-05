mov ah, 0h                      ; Configure graphics mode
mov al, 13h                     ; Set mode to 13h (320x200)
int 10h                         ; Call the interrupt to update graphics mode

mov es, 0A000h                  ; Address of video memory

call paint_start

mov ah, 0h                      ; Configure graphics mode
mov al, 3h                      ; Set mode to 13h (320x200)
int 10h                         ; Call the interrupt to update graphics mode

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
    mov al, 4h
    ret
green:
    mov al, 2h
    ret
blue:
    mov al, 1h
    ret

wait_click_start:
    push ax                     ; Save the value of ax, since this was for the color to be changed
    mov ax, 1h                  ; Show mouse cursor
    int 33h                     ; Call interruption to show mouse coursor
wait_click_loop:
    mov ax, 3h                  ; Get the mouse status
    int 33h                     ; Call the interrupt to get the mouse status (this also include position)
    test bx, 1                  ; Check for left mouse button down
    jnz click_down

    jmp wait_click_loop
click_down_reset:
    mov ax, 1h                  ; Show mouse cursor
    int 33h                     ; Call the interrupt to show mouse coursor
click_down:
    mov ax, 2h                  ; Hide mouse cursor
    int 33h                     ; Call interruption to reset mouse

    shr cx, 1                   ; Divide by 2 to get the x coordinate

    imul dx, 320                ; Multiply y coordinate by 320 to get the index
    add dx, cx                  ; Add the x coordindate to the index

    pop ax                      ; Restore the value of ax
    mov di, dx                  ; Move the index to di
    mov es:[di], al             ; Change the color of the pixel
    push ax                     ; Save the value of ax, again
    
    mov ax, 3h                  ; Get mouse status
    int 33h                     ; Call the interrupt to get the mouse status (this also include position)
    test bx, 1                  ; Check for left mouse button down
    jnz click_down_reset        ; Repeat the process until left mouse button is up
    pop ax
    ret
