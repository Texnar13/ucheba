; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgEnter     DB    "Enter 30 values",0AH,0DH,0
MsgCalculate DB    "Calculate",0AH,0DH,0
MsgExit      DB    "Press Enter to Exit",0AH,0DH,0
nextLine     DB    0AH,0DH,0
space        DB    " ",0

         .DATA 
str_num    SWORD  0
col_num    SWORD  0

         .DATA?
ans        DWORD ?

matr       DWORD 30  DUP (?) 
matr_new   DWORD 15  DUP (?) 




inbuf      DB    100 DUP (?)
myInBuffer DB  10   DUP (?) 

         .CODE
Start:
; 
;    Add you statements
; Дана матрица B(5,6). Переписать в новую матрицу X(3,5) только столбцы с четными номерами. Полученную матрицу вывести на экран.   
;
; Комментарий: Длинна столбца в первой матрице B(5,6) больше чем во второй X(3,5), по этому я взял наименьшую.          
        
        
; ввод матрицы matr B(5,6)

        Invoke StdOut,  ADDR MsgEnter
                
        mov    ECX, 30
        MOV    EBX, 0 ; счетчик строк
      
loop_enter:   ; цикл ввода всех элементов
     
        
        push   ECX
        Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
        Invoke StripLF, ADDR myInBuffer      
        Invoke atol,    ADDR myInBuffer      
        pop    ECX
        MOV    matr[EBX*4], EAX    
        
        INC    EBX; переход к следующему числу
        LOOP   loop_enter
     
        Invoke StdOut,  ADDR MsgCalculate
        
        
;расчеты
        
        MOV    ECX, 5 ; кол-во строк
        MOV    EBX, 0 ; счетчик строк
five_loop:
        push   ECX; дальше будет другой цикл, счетчик лучше сохранить
        

        ; заполняем ряд
        mov    ECX, 3 ; количество повторений цикла
        MOV    ESI, 0 ; счетчик столбцов
third_loop:        
        
        ;EAX = EBX*5+ESI*2 
        mov    EAX, EBX 
        mov    EDX, 5
        mul    EDX
        mov    EDX, EAX ;EDX=EBX*5
        mov    EAX, 2
        MUL    ESI      ;EAX = 2*ESI
        add    EAX, EDX ;EAX = EAX+EDX = ESI*2+EBX*5 
        
        mov    EDX, matr[EAX]; достаем число под нужной позицией
        push   EDX; запоминаем в стек значение полученное из matr
        
        
        mov    EAX, EBX ;EAX = EBX*3+ESI
        mov    EDX, 3
        mul    EDX
        add    EAX, ESI 
        
        pop    EDX; вспоминаем запомненное значение
        mov    matr_new[EAX], EDX; и записываем его в matr_new
       
        LOOP   third_loop; следующая позиция в строке
        
        
        push   ECX; достаем обратно сохраненный счетчик

        ; переходим к следующей строке
        INC    EBX
        LOOP five_loop
        
; вывод
     
        mov ECX, 3 ; Количество повторений цикла
        mov EDI, 0 ; Индекс элемента
         
        cycle_str_output: ; Цикл по строкам
        
         push ECX 
         
         mov ECX, 5 ; Количество повторений цикла
         cycle_col_output: ; Цикл по столбцам
            
            push ECX ; Помещаем значение ECX в стэк		
            Invoke dwtoa, matr_new[EDI*4], ADDR myInBuffer ; Переводим элемент в строку
            Invoke StdOut, ADDR myInBuffer ; Выводим элемент
            Invoke StdOut, ADDR space ; Вывдом символ разделения
            inc EDI ; Увеличиваем индекс элемента на 1
            pop ECX ; Берем значение ECX из стэка
        
         loop cycle_col_output
         Invoke StdOut, ADDR nextLine ; Вывдом символ новой строки
         pop ECX 
     loop cycle_str_output
                 
       
   
     

       
       
       






         ;mov ans, AX
         ;Invoke dwtoa,  ans, ADDR myInBuffer ; прреобразование числа в строку
         ;Invoke StdOut, ADDR myInBuffer             ; вывод строки





         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf myInBuffer	
	
         Invoke ExitProcess,0
         
End    Start

