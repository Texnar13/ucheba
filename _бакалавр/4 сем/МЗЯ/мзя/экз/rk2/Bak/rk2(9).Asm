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

;matrix dword 1 ,2 ,3 ,4 ,5 ,6 ,
;             7 ,8 ,9 ,10,11,12,
;             13,14,15,16,17,18,
;             19,20,21,22,23,24,
;             25,26,27,28,29,30
             
enter_msg DB "Enter matrix (6,5): ",13,10,0             
zapros    DB 13,10,"number ", 0
out_msg   DB 13,10,"Result: ",13,10,0

entr      DB 13,10,0
spac      DB "  ", 0 

         .DATA?
matrix    DB    30  DUP(?)
matrix2   DB    15  DUP(?)

buffer db 10 DUP(?)

; дана матрица B(6,5). переписать в новую матрицу  X(3,5) 
; только строки с четными номерами. полученную матрицу вывести на экран. 

         .CODE
Start:


;  read matrix
Invoke StdOut,ADDR enter_msg	


mov    ecx, 6
mov    ebx, 0
cycleRow1: push ecx
    
    
        mov ecx, 5
        cycleCol1: 
        
        
                push   ecx
                push   ebx
                    
                
                ; enter EAX
                Invoke StdOut, ADDR zapros
                Invoke StdIn,ADDR buffer,LengthOf buffer
                Invoke StripLF,ADDR buffer
                Invoke atol,ADDR buffer


                pop    ebx
                pop    ecx
                
                
                mov    matrix[ebx], al
                
                inc    ebx
                
                
        loop   cycleCol1


        push   ebx
        Invoke StdOut, ADDR entr
        pop    ebx
        
        
pop    ecx
loop   cycleRow1



; move elements cycle
mov ecx, 3 ; row cycle
cycleRow2: push ecx

        mov  ebx, ecx
        mov  ecx, 5
        cycleCol2: push ecx
        
                ; matrix2[ebx*5 + ecx] := matrix[(ebx*2+1)*5 + ecx]
                
                ; edx = (ebx*2+1)*5 + ecx
                
                mov edx, ebx ;(ebx*2+1)
                shl edx, 1
                add edx, 1
                
                mov eax, edx  ; edx * 5
                shl eax, 2
                add edx, eax 
                
                add edx, ecx ; edx = edx + ecx
                
                
                ; eax = ebx*5 + ecx
                
                mov eax, ebx ; eax = ebx * 5
                shl eax, 2
                add eax, ebx 
                
                add eax, ecx; eax = eax + ecx
                
                
                ; matrix2[ebx*5 + ecx] := matrix[(ebx*2+1)*5 + ecx]
                
                xor ecx, ecx ; cl = matrix[(ebx*2+1)*5 + ecx] = matrix[edx]
                mov cl, matrix[edx]
                
                mov matrix2[eax], cl; matrix2[ebx*5 + ecx] := cl
                
                
        pop  ecx 
        loop cycleCol2


pop    ecx
loop   cycleRow2


   
; out second table
Invoke StdOut, ADDR out_msg	


mov    ecx, 3
mov    ebx, 0
cycleRow3: push ecx
    
    
        mov ecx, 5
        cycleCol3: 
        
        
                push   ecx
                push   ebx
                    
                Invoke dwtoa, matrix2[ebx], ADDR buffer
                Invoke StdOut, ADDR buffer
                Invoke StdOut, ADDR spac


                push   ebx
                pop    ecx
                
                inc    ebx
                
                
        loop cycleCol3


        Invoke StdOut, ADDR entr
        
        
pop    ecx
loop   cycleRow3


XOR    EAX,EAX
Invoke StdOut,ADDR MsgExit
Invoke StdIn,ADDR buffer,LengthOf buffer		
	
Invoke ExitProcess,0
End    Start

