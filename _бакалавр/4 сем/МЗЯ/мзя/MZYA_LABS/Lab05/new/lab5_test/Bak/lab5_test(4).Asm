; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib


         .CONST
MsgExit  DB    "Press Enter to Exit",0AH,0DH,0

         .DATA
;sdk       BYTE  "Hello",0
str1      BYTE  100 dup (0)
str2      BYTE  100 dup (0)
len2      BYTE  0

         .DATA?
inbuf     DB    100 DUP (?)
straddr   DD     ?
len1      BYTE   ?
max_chr   BYTE   ?

         .CODE
Start:
; 
;    Add you statements
;

        Invoke StdIn,ADDR str1, LengthOf str1	
        lea    EAX, str1
        mov    straddr, EAX
         

        ; all string length
        lea   EDI, str1                                             ; ESI
        mov   ECX, 255
        mov   EAX, 0
        repne scasb
        mov   len1, 255
        sub   len1, CL
        dec   len1
        dec   len1
        dec   len1
        xor   ECX, ECX
        mov   CL, len1
        mov   str1[ECX], 0

        ; prohodimsya po slovam
        ;mov   EAX, straddr
        ;lea   ESI, [EAX]
        ;mov   ECX, len1
        
        while_not_empty:
        CMP   len1, 0
        JE    while_not_empty_end
            
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
               JL if_no
                  mov max_chr, AL
               if_no:
               
               LEA   EDI, str1                                      ; ESI
               ADD   EDI, EBX                                       ; ESI
               MOV   EAX, ' '
               REPNE SCASB
            
            JMP while_scan
            while_scan_end:            
            
            XOR   ECX, ECX
            MOV   CL, len1  ;CL   := len1
            lea   EDI, str1 ;ESI := lea s                           ; ESI
            
            while_move:
            CMP   CL, 0
            JZ    while_move_end; CL == 0?
            
               MOV   AL, [EDI]                                      ; ESI
               CMP   AL, max_chr   ;s[ESI] == max_chr
               JNE if_rewrite_else
                  
                  PUSH  ECX
                  PUSH  EDI                                         ; ESI
                   
                  MOV   ESI, EDI  ;ESI:= EDI
                  LEA   EDI, str2                                   ; EDI++++
                  XOR   EAX, EAX
                  MOV   AL, len2
                  ADD   EDI, EAX  ;EDI :=lea s2 + len2              ; EDI++++
                  XOR   ECX, ECX
                  MOV   CL, len1  ;ECX := len1
                 
                  
                  while_inner_move:
                  MOV   AL, [ESI]                                   ; ESI++++
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
                  POP   EDI                                        ; ESI++++
                  INC   ESI
                  ;DEC   EDI       
                  ;PUSH  EDI
                  POP   ECX
                  
                  CMP   len1, 0
                  JZ    my_end
                     DEC   len1
                     REP   MOVSB;
                     XOR   EAX, EAX
                     MOV   AL, len1
                     ;DEC   AL
                     MOV   str1[EAX], 0
                  my_end:
                  
                  JMP   if_rewrite_end 
               if_rewrite_else:
                  
                  MOV   AL, ' '
                  REPNE SCASB
               
               if_rewrite_end:
            
            jmp while_move
            while_move_end:   

        jmp while_not_empty
        while_not_empty_end:         
         
         
         
         
         ;mov    EAX, 1
         ;add    EAX, 2 
         ;mov AL, 'T'
         ;mov sdk[0], AL
         
         
         

         XOR    EAX,EAX
         Invoke StdOut, ADDR str2

         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

