mov ah, 0h                      ; Configure graphics mode
mov al, 13h                     ; Set mode to 13h (320x200) Pixel Resolution
int 10h                         ; Call the interrupt to update graphics mode

call paint_start

mov ah, 0h                      ; Configure graphics mode
mov al, 3h                      ; Set mode to 3h (80x20) Text resolution
int 10h                         ; Call the interrupt to update graphics mode

int 20h

paint_start:
    mov ah, 1h                  ; Wait for key to be pressed
    int 21h                     ; Call the interrupt to get the key
    cmp al, 1Bh                 ; Check if the key is ESC, if it is, exit
    je paint_end

    call change_color
    call wait_m1_down
    jmp paint_start
paint_end:
    ret

change_color:
    sub al, '1'                 ; Convert the ASCII value to integer
    cmp al, 0                   ; Check if input is less than 0
    jl invalid_color
    cmp al, 2                   ; Check if input is within 0-2
    jg invalid_color

    mov di, ax                  ; Set the value of di to the value of input
    and di, 3                   ; Mask the value of di to 3 since we only want 1, 2 and 3 indices
    mov al, [color_table + di]  ; Get the color from the color table
    ret
invalid_color:
    xor al, al
    ret

wait_m1_down:
    push ax                     ; Save the value of ax, since this was for the color to be changed
    mov ax, 1h                  ; Show mouse cursor
    int 33h                     ; Call the interrupt to show mouse coursor
wait_m1_down_loop:
    mov ax, 3h                  ; Get mouse status
    int 33h                     ; Call the interrupt to get the mouse status
    test bx, bx                 ; Check if the left mouse button is down
    jnz m1_down

    jmp wait_m1_down_loop
m1_down:
    shr cx, 1                   ; Divide by 2 to get the x coordinate
    imul dx, 320                ; Multiply y coordinate by 320 to get the index
    add dx, cx                  ; Add the x coordindate to the index
    mov di, dx                  ; Move the index to di

    mov ax, 2h                  ; Hide mouse cursor (this is to prevent pixel overwriting)
    int 33h                     ; Call the interrupt to hide the mouse cursor

    pop ax                      ; Restore the value of ax
    mov es, 0A000h              ; Address of video memory
    mov es:[di], al             ; Change the color of the pixel
    push ax                     ; Save the value of ax again

    mov ax, 1h                  ; Show mouse cursor
    int 33h                     ; Call the interrupt to show mouse cursor

    mov ax, 3h                  ; Get mouse status
    int 33h                     ; Call the interrupt to get the mouse status
    test bx, bx                 ; Check if the left mouse button is still down
    jnz m1_down                 ; If it is, keep drawing the pixel

    pop ax                      ; Restore the value of ax
    mov ax, 2h                  ; Hide mouse cursor
    int 33h                     ; Call interruption to reset mouse
    ret

color_table db 4, 2, 1          ; Red, Green, Blue
