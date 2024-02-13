; Template for console application
         .586
         .MODEL  flat, pascal
         ;OPTION CASEMAP:NONE
         
         .CONST
MSEPARATE DWORD " ",0

         .DATA
FIRSTPNT  DWORD -1
SECONDPNT DWORD -1
FIRSTEND  DWORD -1
SECONDEND DWORD -1

         .DATA?
TEMP      DWORD 255 DUP (?)



         .CODE         
         PUBLIC myCange 
         EXTERNDEF mySetText:NEAR
myCange PROC 

      PUSH EBP
      MOV  EBP, ESP
      
      ;MOV  EAX, [EBP+16] ; a[EBP+16]      
      ;ADD  EAX, [EBP+12] ; b[EBP+12]      
      ;MOV  [EBP+8], EAX  ; strk[EBP+8]
      

              
              MOV  ECX, 255 ; начинаем цикл, в котором находим позиции необходимых слов
              MOV  EBX, 0; счетчик символов 
              MOV  EDX, 0; счетчик количества слов
              MOV  ESI, -1; флаг обработки слова
search_loop:  
                
              CMP  EDX, [EBP+16] ;если мы находимся на слове находящемся под первым номером
              JNZ  end_first_if
              MOV  FIRSTPNT, EBX; копируем найденный адрес  
              MOV  ESI, 1; флаг         
end_first_if:       
                
              CMP  EDX, [EBP+12] ;если мы находимся на слове находящемся под вторым номером
              JNZ  end_sec_if
              MOV  SECONDPNT, EBX; копируем найденный адрес
              MOV  ESI, 2; флаг            
end_sec_if:   



                
                

              MOV  EAX, EBP ; получаем базовый адрес строки
              ADD  EAX, 8
              MOV  EAX, [EAX+EBX*4]; получаем текущий элемент
              
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
              MOV  ESI, EBP ; получаем базовый адрес изначальной строки
              ADD  ESI, 8              
              LEA  EDI, TEMP; получаем базовый адрес новой строки               
              REP  MOVSD

              ; копируем второе слово
              MOV  ECX, SECONDEND ; количество букв во втором слове
              SUB  ECX, SECONDPNT
              PUSH ECX            ; количество букв еще пригодится
                                  ; счетчик позиции в старой строке
              MOV  ESI, EBP       ; база
              ADD  ESI, 8 
              MOV  EAX, SECONDPNT ; индекс
              MOV  EBX, 4
              MUL  EBX
              ADD  ESI, EAX
                                  ; счетчик позиции в новой строке
              LEA  EDI, TEMP      ; база
              MOV  EAX, FIRSTPNT  ; индекс
              MOV  EBX, 4
              MUL  EBX
              ADD  EDI, EAX
              
              REP  MOVSD
              

              ; копируем часть цепочки от конца первого слова до начала второго слова
                                  ; счетчик позиции в старой строке  
              MOV  ESI, EBP       ; база
              ADD  ESI, 8 
              MOV  EAX, FIRSTEND  ; индекс
              MOV  EBX, 4 
              MUL  EBX
              ADD  ESI, EAX 
                                  ; счетчик позиции в новой строке                 
              LEA  EDI, TEMP      ; база
              MOV  EAX, FIRSTEND  ; индекс
              POP  ECX            ; достаем количество букв второго слова   
              ADD  EAX, ECX
              PUSH EAX            ; Сохраняем позицию в новой строке для дальнейшей обработки
              MOV  EBX, 4
              MUL  EBX
              ADD  EDI, EAX  
                                  ; количество символов
              MOV  ECX, SECONDPNT
              SUB  ECX, FIRSTEND
              
              REP  MOVSD
              
              
              ; копируем первое слово
                                  ; счетчик позиции в старой строке  
              MOV  ESI, EBP       ; база
              ADD  ESI, 8 
              MOV  EAX, FIRSTPNT  ; индекс
              MOV  EBX, 4 
              MUL  EBX
              ADD  ESI, EAX 
                                  ; счетчик позиции в новой строке                 
              LEA  EDI, TEMP      ; база
              POP  EAX            ; достаем предыдущую позицию и прибавляем к ней расстояние между словами
              ADD  EAX, SECONDPNT ; индекс
              SUB  EAX, FIRSTEND
              MOV  EBX, 4
              MUL  EBX
              ADD  EDI, EAX        
                                  ; количество символов
              MOV  ECX, FIRSTEND
              SUB  ECX, FIRSTPNT
              
              REP  MOVSD


              ; копируем от конца второго слова до конца цепочки
                                  ; счетчик позиции в старой строке  
              MOV  ESI, EBP       ; база
              ADD  ESI, 8 
              MOV  EAX, SECONDEND ; индекс
              MOV  EBX, 4 
              MUL  EBX
              ADD  ESI, EAX 
                                  ; счетчик позиции в новой строке  
              LEA  EDI, TEMP      ; база
              MOV  EAX, SECONDEND ; индекс
              MOV  EBX, 4 
              MUL  EBX
              ADD  EDI, EAX 
              
                                  ; количество символов
              MOV  ECX, 255
              SUB  ECX, SECONDEND
              
              REP  MOVSD

        
              ; через внешнюю процедуру меняем текст
              LEA  EAX, TEMP
              PUSH EAX
              CALL myCange
      
end_p:      
      
      
      POP  EBP
      RET  12

myCange ENDP    
   
 
END

        
; Вариант 16. Дан текст не более 255 символов. Слова отделяются друг от друга пробелами. 
; Поменять местами пары слов с указанными номерами. 
;
;         
      
      
      
         
;Start:
; 
;    Add you statements
;
         ;XOR    EAX,EAX	
	
         ;Invoke ExitProcess,0
         ;End    Start
		 
		 

MsgExit   DB    "Press Enter to Exit",0AH,0DH,0
MStart    DB    "ENTER STRING:it is my word hello program",0AH,0DH,"ENTER FIRST NUMBER:4",0AH,0DH,"ENTER SECOND NUMBER:6",0
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
                
              CMP  EDX, 6 ;если мы находимся на слове находящемся под вторым номером----------------------------------[EBP+12]
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
              
              
              

              INC  EDX ; после цикла последний раз увеличиваем счетчик слов            
              
              
              CMP  ESI, 2; находим конец второй строки
              JNZ  end_s_d_end_if
              MOV  SECONDEND, EBX; копируем найденный адрес     
              MOV  ESI, -1; флаг           
end_s_d_end_if: 
              
              
              
              
              
              
              
              
              
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


		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 