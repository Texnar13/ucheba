; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
msgEnterLine  DB    "Enter 5 values - line ",0
msgCalculate  DB    "Calculate",0AH,0DH,0
msgExit       DB    "Press Enter to Exit",0AH,0DH,0
nextLine      DB    0AH,0DH,0
space         DB    " ",0
matr          DWORD 1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,20,1,2,3,4,5

         .DATA 

         .DATA?
;matr          DWORD 25  DUP (?) 
myInOutBuffer DB    10  DUP (?) 
regOutBuf     DWORD ?

         .CODE
Start:


; 
;    Add you statements
; 
;
; Дана матрица 5х5. Определить на каждой строке произведение элемент, кратных 4, 
; и поместить его на место элементов побочной диагонали. 
; Организовать ввод матрицы и вывод результатов. 
        
        
        
        
      


; расчеты

        Invoke StdOut, ADDR msgCalculate
        
        
        
        
        mov    ECX, 5 ; Количество повторений цикла
        mov    EDI, 0 ; Индекс элемента
cycle_str_calc:       ; Цикл по строкам
        push   ECX 
        
        mov    EAX, 1; изначальное произведение всех элементов в сторке 
        
        mov    ECX, 5 ; Количество повторений цикла
cycle_col_calc:       ; Цикл по столбцам
        push   ECX    ; Помещаем значение ECX в стэк		
        push   EAX
        
        
        mov    EAX, matr[EDI*4]; проверка кратности 4 todo DX:AX-------------------------------------------------
        mov    EBX, 4
        div    EBX
        
        
        cmp    DX, 0
        JNE    calc_else       ; если не кратно, пропускаем следующий шаг
        mul    matr[EDI*4]     ; если кратно, умножаем общее произведение
calc_else: 
            
        inc    EDI            ; Увеличиваем индекс элемента на 1
        pop    EAX
        pop    ECX            ; Берем значение ECX из стэка
        loop   cycle_col_calc
        
        
        Invoke StdOut, ADDR nextLine                  ; Вывдом символ новой строки
        
        pop    ECX 
        loop   cycle_str_calc
                 
        
        
        
        












; вывод
     
        mov    ECX, 5 ; Количество повторений цикла
        mov    EDI, 0 ; Индекс элемента       
cycle_str_output:     ; Цикл по строкам
        push   ECX 
        
        
        mov    ECX, 5 ; Количество повторений цикла
cycle_col_output:     ; Цикл по столбцам
        push   ECX    ; Помещаем значение ECX в стэк		
            
        Invoke dwtoa, matr[EDI*4], ADDR myInOutBuffer ; Переводим элемент в строку
        Invoke StdOut, ADDR myInOutBuffer             ; Выводим элемент
        Invoke StdOut, ADDR space                     ; Вывдом символ разделения
            
        inc    EDI    ; Увеличиваем индекс элемента на 1
        pop    ECX    ; Берем значение ECX из стэка
        loop   cycle_col_output
        
        
        Invoke StdOut, ADDR nextLine                  ; Вывдом символ новой строки
        
        pop    ECX 
        loop   cycle_str_output
                 











         XOR    EAX,EAX
         Invoke StdOut,ADDR msgExit
         Invoke StdIn,ADDR myInOutBuffer,LengthOf myInOutBuffer	
	
         Invoke ExitProcess,0
         
End    Start

