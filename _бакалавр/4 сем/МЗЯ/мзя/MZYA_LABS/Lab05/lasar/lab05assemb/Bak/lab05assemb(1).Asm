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
         PUBLIC _myCange 
         EXTERNDEF mySetText:NEAR
myCange PROC 

              PUSH EBP
              MOV  EBP, ESP
              ADD  ESP,256 ;��������� ������ ��� ����� ������
              
              ; ���������� ���������
              PUSH EBX
              PUSH ESI
              PUSH EDI
              
              ; �������� ������ � ����
              mov  ESI,[EBP+8] ; ����� �������� ������
              lea  EDI,[EBP-256]; ����� ����� �������� ������ 
              xor  ECX,ECX
              mov  CL, [ESI]  ; ����� �������� ������ 
              inc  ECX       ; ������� ����� ������ �������� ������ 
              rep  movsb     ; ����������� �������� ������ 
 

              
              

              
              MOV  EBX, [EBP-256]; ����� �������� ������
              XOR  ECX, ECX
              MOV  CL,  [EBX]; �������� ���� �� ������ ���� ������, � ������� ������� ������� ����������� ����
              MOV  EBX, 1; ������� �������� (������ ������ ��� ���������� ��������, �� ����� �������� ����� �� �������)
              MOV  EDX, 1; ������� ���������� ����
              MOV  ESI, -1; ���� ��������� �����
search_loop:  
                
              CMP  ESI, -1; ��������� �� ���� �� ��� �� ���� ����� ��������  
              JNZ  end_sec_if  
                
              CMP  EDX, [EBP+16] ;���� �� ��������� �� ����� ����������� ��� ������ �������
              JNZ  end_first_if
              MOV  FIRSTPNT, EBX; �������� ��������� �����  
              MOV  ESI, 1; ����         
end_first_if:       
                
              CMP  EDX, [EBP+12] ;���� �� ��������� �� ����� ����������� ��� ������ �������
              JNZ  end_sec_if
              MOV  SECONDPNT, EBX; �������� ��������� �����
              MOV  ESI, 2; ����            
end_sec_if:   


                
              MOV  EDI, [EBP-256] ; �������� ������� ����� ������
              INC  EDI
              XOR  EAX, EAX
              MOV  AL,  [EDI+EBX-1]; �������� ������� �������
              
              CMP  MSEPARATE, EAX; ���� ������� ������ ����������� ������� ���� 
              JNZ  end_numb_if
              INC  EDX
              
              CMP  ESI, 1; ������� ����� ������ ������
              JNZ  end_f_end_if
              MOV  FIRSTEND, EBX; �������� ��������� �����   
              MOV  ESI, -1; ����            
end_f_end_if:              
              
              
              CMP  ESI, 2; ������� ����� ������ ������
              JNZ  end_s_end_if
              MOV  SECONDEND, EBX; �������� ��������� �����     
              MOV  ESI, -1; ����           
end_s_end_if: 
                
              
end_numb_if:       
              INC  EBX
              LOOP search_loop
              
              
              

              INC  EDX ; ����� ����� ��������� ��� ����������� ������� ����            
              
              
              CMP  ESI, 2; ������� ����� ������ ������
              JNZ  end_s_d_end_if
              MOV  SECONDEND, EBX; �������� ��������� �����     
              MOV  ESI, -1; ����           
end_s_d_end_if: 
              
              
              
              
              
              
              
              
              
              MOV  EAX, -1        ; ����� ���������� ����� ����� ������� ���� ��� -1 � ������   
              CMP  FIRSTPNT, EAX  ; � ������ -1 ��������� � ����� ��������� ��� ������������� ����
              JE   end_p
              CMP  SECONDPNT, EAX
              JE   end_p
              
              
              
              
              ; ������ ����� �������
              
              ; �������� � ����� ���������� ������ �� ������ ������� �����
              MOV  ECX, FIRSTPNT
              MOV  ESI, [EBP-256] ; �������� ������� ����� ����������� ������     
              LEA  EDI, TEMP; �������� ������� ����� ����� ������               
              REP  MOVSB

              ; �������� ������ �����
              MOV  ECX, SECONDEND ; ���������� ���� �� ������ �����
              SUB  ECX, SECONDPNT
              PUSH ECX            ; ���������� ���� ��� ����������
                                  ; ������� ������� � ������ ������
              MOV  ESI, [EBP-256]   ; ����
              ADD  ESI, SECONDPNT ; ������
              
                                  ; ������� ������� � ����� ������
              LEA  EDI, TEMP      ; ����
              ADD  EDI, FIRSTPNT  ; ������
              
              REP  MOVSB
              

              ; �������� ����� ������� �� ����� ������� ����� �� ������ ������� �����
                                  ; ������� ������� � ������ ������  
              MOV  ESI, [EBP-256]   ; ���� 
              ADD  ESI, FIRSTEND  ; ������
              
                                  ; ������� ������� � ����� ������                 
              LEA  EDI, TEMP      ; ����
              MOV  EAX, FIRSTPNT  ; ������
              POP  ECX            ; ������� ���������� ���� ������� �����   
              ADD  EAX, ECX
              PUSH EAX            ; ��������� ������� � ����� ������ ��� ���������� ���������
              ADD  EDI, EAX  
                                  ; ���������� ��������
              MOV  ECX, SECONDPNT
              SUB  ECX, FIRSTEND
              
              REP  MOVSB
              
              
              ; �������� ������ �����
                                  ; ������� ������� � ������ ������  
              MOV  ESI, [EBP-256]   ; ����
              ADD  ESI, FIRSTPNT  ; ������
                                  ; ������� ������� � ����� ������                 
              LEA  EDI, TEMP      ; ����
              POP  EAX            ; ������� ���������� ������� � ���������� � ��� ���������� ����� �������
              ADD  EAX, SECONDPNT ; ������
              SUB  EAX, FIRSTEND
              ADD  EDI, EAX        
                                  ; ���������� ��������
              MOV  ECX, FIRSTEND
              SUB  ECX, FIRSTPNT
              
              REP  MOVSB


              ; �������� �� ����� ������� ����� �� ����� �������
                                  ; ������� ������� � ������ ������  
              MOV  ESI, [EBP-256]   ; ����
              ADD  ESI, SECONDEND ; ������
                                  ; ������� ������� � ����� ������  
              LEA  EDI, TEMP      ; ����
              ADD  EDI, SECONDEND ; ������
              
                                                   
              MOV  EBX, [EBP-256]; ����� �������� ������
              XOR  ECX, ECX                    
              MOV  CL, [EBX]   ; ���������� �������� � �������� ������
              ADD  CL, 1
              SUB  ECX, SECONDEND
              
              REP  MOVSB

              ; ���������� ����������� ��������
              PUSH EBX
              PUSH ESI
              PUSH EDI
        
              ; ����� ������� ��������� ������ �����
              LEA  EAX, TEMP
              PUSH EAX
              CALL myCange
      
end_p:      
      
      
      POP  EBP
      RET  16

myCange ENDP    
   
 
END

        
; ������� 16. ��� ����� �� ����� 255 ��������. ����� ���������� ���� �� ����� ���������. 
; �������� ������� ���� ���� � ���������� ��������. 
; 