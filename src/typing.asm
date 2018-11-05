assume cs:code, ds:data, ss:stack


.stack 100h
.data
  intro_title db '* Introduction *$'
  intro1 db 'This is a little typing game designed with$'
  intro2 db '8086 assembly language.$'
  intro3 db 'Go and test it!$'
  intro4 db 'Press any key to begin.$'
  m_title db 'My aim in life$'
  m_path db '../data/passage.txt', 0
  waiting db ':waiting..$'
  wrong db ':wrong..  $'
  win db ':win!     $'
  m_score db 'score: $'
  passage db 2000 dup (36) ;36='$'
  blank db '                                                    $'
  xd dd 0
  yd dd 0
  m_char db 0
  color db 0
  ten db 10
  pass_si dd 0
  score dd 0
  

.code
start:
  mov ax, data
  mov ds, ax

cls:
  mov ax, 3h
  int 10h

print_introduction:
  setCursor 3, 26
  printStr intro_title
  setCursor 6, 18
  printStr intro1
  setCursor 8, 24
  printStr intro2
  setCursor 11, 27
  printStr intro3
  setCursor 14, 24
  printStr intro4
  getch
  setCursor 14, 24
  printStr blank
  setCursor 11, 27
  printStr blank
  setCursor 8, 24
  printStr blank
  setCursor 6, 18
  printStr blank
  setCursor 3, 26
  printStr blank

print_title:
  setCursor 1, 24
  printStr m_title

read_file:
  lea dx, m_path           ;open file 
  mov al, 2
  mov ah, 3dh
  int 21h

  lea dx, passage          ;read file to passage
  mov cx, 2000
  mov bx, ax
  mov ah, 3fh
  int 21h

  mov ah, 3eh              ;close file
  int 21h

print_passage:
  setCursor 2, 0
  printStr passage
  setCursor 23, 0
  printStr waiting

set_title_color:
  mov cx, 14
  mov al, 14
  mov di, 48
  mov bp, 0b80Ah
  mov es, bp
  l1:
    mov es:[di+1], al
    add di, 2
    loop l1

print_score:
  setCursor 0, 0
  printStr m_score
  setCursor 0, 7
  mov dl, 48
  mov ah, 06h
  int 21h

game_loop:
  setCursor 2, 0
  mov xd, 2
  getChar
  jmp skip_space
 next:
  getChar
 skip_next:
  cmp m_char, 10            ;10='\n'
  je next_line
  mov ax, xd
  mov dx, yd
  setCursor al, dl
  getch
  cmp al, m_char
  je input_right
  jmp input_wrong

skip_space:
  cmp m_char, 32            ;32=' '
  jne skip_next
  inc yd
  inc pass_si
  getChar
  jmp skip_space

next_line:
  inc xd
  mov yd, 0
  mov ax, xd
  inc pass_si
  setCursor al, 0
  getChar
  cmp m_char, 36
  je end
  jmp skip_space

input_right:
  cmp al, 32
  je skip_score
  inc score
 skip_score:
  mov color, 14             ;14=yellow
  setColor color
  inc yd
  inc pass_si
  call printScore
  jmp next

input_wrong:
  dec score
  call printScore
  setCursor 23, 0
  printStr wrong
  mov color, 12             ;12=red
  setColor color
  pusha
  sleep
  popa
  mov color, 7              ;7=white
  setColor color
  setCursor 23, 0
  printStr waiting
  mov ax, xd
  mov dx, yd
  setCursor al, dl
  jmp next

end:
  setCursor 23, 0
  printStr win

  mov ah,1                 ;press any key to exit
  int 21h

  mov ax, 4c00h            ;end
  int 21h


sleep macro
    mov cx, 65535
    s1:
      loop s1
    dec bx
    cmp bx, 0
endm

setCursor macro x, y          ;x y 8bits
  mov dh, x
  mov dl, y
  mov ah, 02h
  mov bh, 0
  int 10h
endm

getch macro
  mov ah, 08h
  int 21h
endm

getChar macro
  lea si, passage
  add si, pass_si
  mov dx, ds:[si]
  mov m_char, dl
endm

printStr macro str
  lea dx, str
  mov ah, 09h
  int 21h
endm

printChar macro char
  mov dl, char
  mov ah, 06h
  int 21h
endm

setColor macro color
  mov ax, xd
  mul ten
  add ax, 0b800h
  mov es, ax
  mov di, yd
  add di, yd
  mov al, color
  mov es:[di+1], al
endm

printScore proc near
  setCursor 0, 7
  printStr blank
  pusha
  setCursor 0, 7
  mov dx, 0
  push 36
  mov ax, score
  get_next:
    div ten
    add ah, 48
    mov dl, ah
    push dx
    mov ah, 0
    cmp ax, 0
    jne get_next
  print_next:
    pop ax
    cmp ax, 36
    je print_score_done
    printChar al
    jmp print_next
  print_score_done:
  popa
  ret
proc endp

end start