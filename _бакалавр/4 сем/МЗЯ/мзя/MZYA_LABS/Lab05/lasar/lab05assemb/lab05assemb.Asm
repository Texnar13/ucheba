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
TEMP      DB 255 DUP (?)


         .CODE         
         PUBLIC myCange 
         EXTERNDEF _mySetText:NEAR
myCange PROC 

              PUSH EBP
              MOV  EBP, ESP
              ADD  ESP,256 ;выделение памяти под копию строки
              
              ; сохранение регистров
              PUSH EBX
              PUSH ESI
              PUSH EDI
              
              ; копируем строку в стек
              mov  ESI,[EBP+8] ; адрес исходной строки
              lea  EDI,[EBP-256]; адрес копии исходной строки 
              xor  ECX,ECX
              mov  CL, [ESI]  ; длина исходной строки 
              inc  ECX       ; добавим адрес начала исходной строки 
              rep  movsb     ; копирование исходной строки 
 

              
              

              
              MOV  EBX, [EBP-256]; адрес исходной строки
              XOR  ECX, ECX
              MOV  CL,  [EBX]; начинаем цикл по длинне всей строки, в которой находим позиции необходимых слов
              MOV  EBX, 1; счетчик символов (первый символ это количество символов, по этому начинаем сразу со второго)
              MOV  EDX, 1; счетчик количества слов
              MOV  ESI, -1; флаг обработки слова
search_loop:  
                
              CMP  ESI, -1; проверяем не идет ли уже на этом слове проверка  
              JNZ  end_sec_if  
                
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


                
              MOV  EDI, [EBP-256] ; получаем базовый адрес строки
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
              MOV  ESI, [EBP-256] ; получаем базовый адрес изначальной строки     
              LEA  EDI, TEMP; получаем базовый адрес новой строки               
              REP  MOVSB

              ; копируем второе слово
              MOV  ECX, SECONDEND ; количество букв во втором слове
              SUB  ECX, SECONDPNT
              PUSH ECX            ; количество букв еще пригодится
                                  ; счетчик позиции в старой строке
              MOV  ESI, [EBP-256]   ; база
              ADD  ESI, SECONDPNT ; индекс
              
                                  ; счетчик позиции в новой строке
              LEA  EDI, TEMP      ; база
              ADD  EDI, FIRSTPNT  ; индекс
              
              REP  MOVSB
              

              ; копируем часть цепочки от конца первого слова до начала второго слова
                                  ; счетчик позиции в старой строке  
              MOV  ESI, [EBP-256]   ; база 
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
              MOV  ESI, [EBP-256]   ; база
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
              MOV  ESI, [EBP-256]   ; база
              ADD  ESI, SECONDEND ; индекс
                                  ; счетчик позиции в новой строке  
              LEA  EDI, TEMP      ; база
              ADD  EDI, SECONDEND ; индекс
              
                                                   
              MOV  EBX, [EBP-256]; адрес исходной строки
              XOR  ECX, ECX                    
              MOV  CL, [EBX]   ; количество символов в исходной строке
              ADD  CL, 1
              SUB  ECX, SECONDEND
              
              REP  MOVSB

              ; возвращаем сохраненные регистры
              PUSH EBX
              PUSH ESI
              PUSH EDI
        
              ; через внешнюю процедуру меняем текст
              LEA  EAX, TEMP
              PUSH EAX
              CALL myCange
      
end_p:      
      
      
      POP  EBP
      RET  16

myCange ENDP    
   
 
END

        
; Вариант 16. Дан текст не более 255 символов. Слова отделяются друг от друга пробелами. 
; Поменять местами пары слов с указанными номерами. 
; 