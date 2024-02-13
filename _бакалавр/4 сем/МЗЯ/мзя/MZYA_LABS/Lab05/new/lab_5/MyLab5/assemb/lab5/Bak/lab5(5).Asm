; Template for console application 
         .586
         .MODEL  flat
;         OPTION CASEMAP:NONE
;Include kernel32.inc
;Include masm32.inc
;
;IncludeLib kernel32.lib
;IncludeLib masm32.lib

         .CONST
         .DATA
;sdk       BYTE  "Hello",0
str1      BYTE  100 dup (0)
str2      BYTE  100 dup (0)
len2      BYTE  0

         .DATA?
inbuf     DB    100 DUP (?)
len1      BYTE   ?
max_chr   BYTE   ?





         .CODE
         public _MYFUNC@4
         EXTERNDEF _MYFUNC2@4:near
         
_MYFUNC@4   PROC   
        push   EBP
        mov    EBP, ESP; База, от которой считаем в стеке свои переменные
        push   EAX
         
        ;get argument string length
        mov   EDI, [EBP+8]; операнд находится после EBP и адр.возвр.. Оба длинной 4. EAX не в счет
        mov   ECX, 255
        mov   EAX, 0
        repne scasb
        mov   len1, 255
        sub   len1, CL
        dec   len1
        ;dec   len1
        ;dec   len1
        
        ;copy string from arguments to str1 
        mov   ESI, [EBP+8]
        lea   EDI, str1
        xor   ECX, ECX
        mov   CL, len1
        mov   str1[ECX], 0
        REP   MOVSB 
        
        ;main rewrite cycle
        while_not_empty:
        CMP   len1, 0
        JE    while_not_empty_end
            
            
            ; find smallest first letter
            MOV   CL, str1[0]
            MOV   max_chr, CL  ;max_chr :=s1[0]
            XOR   ECX, ECX
            MOV   CL, len1     ;ECX     := len1
            
            while_scan:
            CMP   CL, 0
            JZ    while_scan_end; CL == 0?
               
               XOR   EBX, EBX
               XOR   EAX, EAX
               MOV   BL, len1
               SUB   BL, CL
               MOV   AL, str1[EBX]
               CMP   AL, max_chr;s[len1-CL] > max_chr
               JG if_no
                  mov max_chr, AL
               if_no:
               
               LEA   EDI, str1
               ADD   EDI, EBX
               MOV   EAX, ' '
               REPNE SCASB
            
            JMP while_scan
            while_scan_end:            
            
            XOR   ECX, ECX
            MOV   CL, len1  ;CL   := len1
            lea   EDI, str1 ;ESI := lea s
            
            while_move:
            CMP   CL, 0
            JZ    while_move_end; CL == 0?
            
               MOV   AL, [EDI]
               CMP   AL, max_chr   ;s[ESI] == max_chr
               JNE if_rewrite_else
                  
                  PUSH  ECX
                  PUSH  EDI
                   
                  MOV   ESI, EDI  ;ESI:= EDI
                  LEA   EDI, str2
                  XOR   EAX, EAX
                  MOV   AL, len2
                  ADD   EDI, EAX  ;EDI :=lea s2 + len2
                  XOR   ECX, ECX
                  MOV   CL, len1  ;ECX := len1
                 
                  
                  while_inner_move:
                  MOV   AL, [ESI]
                  CMP   AL, 0
                  JE    while_inner_move_end
                  CMP   AL, ' '
                  JE    while_inner_move_end
                  
                     ;LEA   ESI, str2
                     ;LEA   EDI, str1
                     STOSB
                     DEC   ECX
                     INC   ESI
                     INC   len2
                     DEC   len1
                  
                  JMP   while_inner_move
                  while_inner_move_end:
                  
                  MOV   EBX, ' '
                  MOV   [EDI], BL
                  INC   len2; add whitespce
                  POP   EDI
                  INC   ESI
                  ;DEC   EDI       
                  ;PUSH  EDI
                  POP   ECX
                  REP   MOVSB
                  
                  CMP   len1, 0
                  JZ    my_end
                     DEC   len1;
                  my_end:
                  XOR   EAX, EAX
                  MOV   AL, len1
                  ;DEC   AL
                  MOV   str1[EAX], 0
                  
                  JMP   if_rewrite_end 
               if_rewrite_else:
                  
                  MOV   AL, ' '
                  REPNE SCASB
               
               if_rewrite_end:
            
            jmp while_move
            while_move_end:   

        jmp while_not_empty
        while_not_empty_end:         
         
        ; метод вывода
        lea EAX, str2
        push EAX
        call _MYFUNC2@4
        ;pop    EAX
        ;pop    EAX
        ;pop    EAX
        ;pop    EAX
        ;pop    EAX
         
        ;pop    EAX
        ;ret 4
        ret 2
_MYFUNC@4   ENDP 

END
