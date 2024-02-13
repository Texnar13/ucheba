; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit   DB    "Press Enter to Exit",0AH,0DH,0
MStart    DB    "ENTER STRING:it is my word hello program",0AH,0DH,"ENTER FIRST NUMBER:4",0AH,0DH,"ENTER SECOND NUMBER:5",0
MEnter    DB    "Enter",0AH,0DH,0
MNEXT     DB    0AH,0DH,0
MSEPARATE DWORD " ",0

         .DATA
INTEXT    DB 27,"it is my word hello program",0
FIRSTPNT  DWORD -1
SECONDPNT DWORD -1
FIRSTEND  DWORD -1
SECONDEND DWORD -1

         .DATA?
TEMP      DB 255 DUP (?)

         .CODE
Start:
; 
;    Add you statements
;




              Invoke StdOut, ADDR MStart



              XOR  ECX, ECX
              MOV  CL, INTEXT ; начинаем цикл по длинне всей строки, в котором находим позиции необходимых слов---------[EBP+8]
              MOV  EBX, 1; счетчик символов (первый символ это количество символов, по этому начинаем сразу со второго)
              MOV  EDX, 1; счетчик количества слов
              MOV  ESI, -1; флаг обработки слова
search_loop:  
                
              CMP  ESI, -1; проверяем не идет ли уже на этом слове проверка  
              JNZ  end_sec_if  
                
              CMP  EDX, 4 ;если мы находимся на слове находящемся под первым номером---------------------------------[EBP+16]
              JNZ  end_first_if
              MOV  FIRSTPNT, EBX; копируем найденный адрес  
              MOV  ESI, 1; флаг         
end_first_if:       
                
              CMP  EDX, 5 ;если мы находимся на слове находящемся под вторым номером----------------------------------[EBP+12]
              JNZ  end_sec_if
              MOV  SECONDPNT, EBX; копируем найденный адрес
              MOV  ESI, 2; флаг            
end_sec_if:   


                
              LEA  EDI, INTEXT ; получаем базовый адрес строки---------[EBP+8]+1
              INC  EDI
              XOR  EAX, EAX
              MOV  AL,  [EDI+EBX-1]; получаем текущий элемент
              
              CMP  MSEPARATE, EAX; если находим пробел увеличиваем счетчик слов 
              JNZ  end_numb_if
              INC  EDX
              
              CMP  ESI, 1; находим конец первой строки
              JNZ  end_f_end_if
              MOV  FIRSTEND, EBX; копируем найденный адрес   
              MOV  ESI, -1; флаг            
end_f_end_if:              
              
              
              CMP  ESI, 2; находим конец второй строки
              JNZ  end_s_end_if
              MOV  SECONDEND, EBX; копируем найденный адрес     
              MOV  ESI, -1; флаг           
end_s_end_if: 
                
              
end_numb_if:       
              INC  EBX
              LOOP search_loop
              
              
              
              
              
              
              
              MOV  EAX, -1        ; после выполнения цикла имеем позиции слов или -1 в памяти   
              CMP  FIRSTPNT, EAX  ; в случае -1 переходим в конец программы без переставления слов
              JE   end_p
              CMP  SECONDPNT, EAX
              JE   end_p
              
              
              
              
              ; меняем слова местами
              
              ; копируем в новую переменную строку до начала первого слова
              MOV  ECX, FIRSTPNT
              LEA  ESI, INTEXT ; получаем базовый адрес изначальной строки --------------  [EBP+8]        
              LEA  EDI, TEMP; получаем базовый адрес новой строки               
              REP  MOVSB

              ; копируем второе слово
              MOV  ECX, SECONDEND ; количество букв во втором слове
              SUB  ECX, SECONDPNT;----------------------------------------------------------------------------------------------------------------
              PUSH ECX            ; количество букв еще пригодится
                                  ; счетчик позиции в старой строке
              LEA  ESI, INTEXT    ; база --------------  [EBP+8]  
              ADD  ESI, SECONDPNT ; индекс
              
                                  ; счетчик позиции в новой строке
              LEA  EDI, TEMP      ; база
              ADD  EDI, FIRSTPNT  ; индекс
              
              REP  MOVSB
              

              ; копируем часть цепочки от конца первого слова до начала второго слова
                                  ; счетчик позиции в старой строке  
              LEA  ESI, INTEXT    ; база --------------  [EBP+8]  
              ADD  ESI, FIRSTEND  ; индекс
              
                                  ; счетчик позиции в новой строке                 
              LEA  EDI, TEMP      ; база
              MOV  EAX, FIRSTPNT  ; индекс
              POP  ECX            ; достаем количество букв второго слова   
              ADD  EAX, ECX
              PUSH EAX            ; Сохраняем позицию в новой строке для дальнейшей обработки
              ADD  EDI, EAX  
                                  ; количество символов
              MOV  ECX, SECONDPNT
              SUB  ECX, FIRSTEND
              
              REP  MOVSB
              
              
              ; копируем первое слово
                                  ; счетчик позиции в старой строке  
              LEA  ESI, INTEXT    ; база --------------  [EBP+8]  
              ADD  ESI, FIRSTPNT  ; индекс
                                  ; счетчик позиции в новой строке                 
              LEA  EDI, TEMP      ; база
              POP  EAX            ; достаем предыдущую позицию и прибавляем к ней расстояние между словами
              ADD  EAX, SECONDPNT ; индекс
              SUB  EAX, FIRSTEND
              ADD  EDI, EAX        
                                  ; количество символов
              MOV  ECX, FIRSTEND
              SUB  ECX, FIRSTPNT
              
              REP  MOVSB


              ; копируем от конца второго слова до конца цепочки
                                  ; счетчик позиции в старой строке  
              LEA  ESI, INTEXT    ; база --------------  [EBP+8] 
              ADD  ESI, SECONDEND ; индекс
                                  ; счетчик позиции в новой строке  
              LEA  EDI, TEMP      ; база
              ADD  EDI, SECONDEND ; индекс
              
                                  ; количество символов
              XOR  ECX, ECX                    
              MOV  CL, INTEXT;---------[EBP+8]
              ADD  CL, 1
              SUB  ECX, SECONDEND
              
              REP  MOVSB
              
              
              Invoke StdOut, ADDR MNEXT
              Invoke StdOut, ADDR TEMP
              Invoke StdOut, ADDR MNEXT

      
end_p:      







         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR INTEXT,LengthOf INTEXT		
	
         Invoke ExitProcess,0
End    Start





