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
zapros DB 13,10,"number ", 0
Result DB 13,10,"Result: ",13,10,0
nextLine DB 13,10,"----------------",13,10,0
entr DB 13,10,0
spac db "  ", 0 
msg db 13,10,"Input: ",13,10,0
num db 6

         .DATA
matrix dword 2,2,3,4,
             5,6,7,8,
             9,10,11,12,
            44,14,15,16,
            17,18,19,20,
            21,21,22,25
columnsCount dword 4
currentColumn dword 0
;currentOffset dword 0
         .DATA?
inbuf    DB    100 DUP (?)
;matrix sbyte 24 DUP(?)
buffer db 10 DUP(?)
res db 16 dup(' '),0
mas sbyte 24 DUP(?)


         .CODE
Start:

comment $

mov ebx, 0
mov ecx, 6
cycle1: push ecx
        
        mov ecx, 4
        cycle2: push ECX
            
            Invoke StdOut, ADDR zapros
            Invoke StdIn,ADDR buffer,LengthOf buffer
            Invoke StripLF,ADDR buffer
            Invoke atol,ADDR buffer
            CBW ; AL -> AX
            CWDE; AX -> EAX 
            mov matrix[EBX], EAX
            add EBX, 4
            
        pop ECX
        loop cycle2
        
        Invoke StdOut, ADDR nextLine
        
pop ecx
loop cycle1   
    
   $ 
   

mov ecx, 4
cycleCol: push ecx
        
        ;mov currentOffset, ebx; currentOffset = ebx
        ;push ebx
        
        mov eax, columnsCount
        mov currentColumn, eax
        sub currentColumn, ecx; currentColumn = columnsCount - ecx
        

        ; сумма элементов колонки
        xor eax,eax ; сумма
        mov EBX, currentColumn   
        shl EBX, 2; позиция тек. элемента
        mov ecx, 6   ; счетчик
        cycleColSumm:
                add eax, matrix[EBX]
                add EBX, 16
        loop cycleColSumm
         
        
        ; проверка четности
        mov ebx,2
        cdq
        idiv ebx 
        cmp edx,0 
        jne exit
            
            
            ; сдвигаем столбцы влево
            
            ; по строкам
            mov ecx, 6; цикл
            mov ebx, 0; номер строки
            cycleMove_Row: push ecx
                push ebx
                
                ; по элементам строки
                SHL EBX, 4
                mov eax, currentColumn
                SHL eax, 2
                add EBX, eax; ebx = ebx * 16 + currentColumn * 4
                
                mov ecx, 3
                sub ecx, currentColumn 
                cycleMove_Element:
                    
                    mov eax, matrix[EBX+4]
                    mov matrix[EBX], eax
                    add EBX, 4
                    
                loop cycleMove_Element
                
                pop ebx
                inc ebx
            pop ecx
            loop cycleMove_Row
            
            
            dec columnsCount; уменьшаем общее количество столбцов
        exit:
pop ecx
loop cycleCol
   
dec columnsCount     
   
   
   
    
Invoke StdOut,ADDR msg	
mov ebx, 0
mov ecx, 6
 
cycle3: push ecx
    push ebx
    
    
    SHL EBX, 4; ebx = ebx * 16    
    mov ecx, columnsCount
    cycle4: push ecx
         
        Invoke dwtoa,matrix[ebx], ADDR res
        Invoke StdOut, ADDR res
        Invoke StdOut, ADDR spac
        
        add EBX, 4
        
        pop ECX
    loop cycle4
    
    Invoke StdOut, ADDR entr
    
    pop ebx
    inc ebx
    pop ecx
loop cycle3
   
     
      
         
XOR    EAX, EAX
Invoke StdOut, ADDR MsgExit
Invoke StdIn, ADDR inbuf,LengthOf inbuf		
Invoke ExitProcess, 0
End    Start

