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
              MOV  CL, INTEXT ; �������� ���� �� ������ ���� ������, � ������� ������� ������� ����������� ����---------[EBP+8]
              MOV  EBX, 1; ������� �������� (������ ������ ��� ���������� ��������, �� ����� �������� ����� �� �������)
              MOV  EDX, 1; ������� ���������� ����
              MOV  ESI, -1; ���� ��������� �����
search_loop:  
                
              CMP  ESI, -1; ��������� �� ���� �� ��� �� ���� ����� ��������  
              JNZ  end_sec_if  
                
              CMP  EDX, 4 ;���� �� ��������� �� ����� ����������� ��� ������ �������---------------------------------[EBP+16]
              JNZ  end_first_if
              MOV  FIRSTPNT, EBX; �������� ��������� �����  
              MOV  ESI, 1; ����         
end_first_if:       
                
              CMP  EDX, 5 ;���� �� ��������� �� ����� ����������� ��� ������ �������----------------------------------[EBP+12]
              JNZ  end_sec_if
              MOV  SECONDPNT, EBX; �������� ��������� �����
              MOV  ESI, 2; ����            
end_sec_if:   


                
              LEA  EDI, INTEXT ; �������� ������� ����� ������---------[EBP+8]+1
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
              
              
              
              
              
              
              
              MOV  EAX, -1        ; ����� ���������� ����� ����� ������� ���� ��� -1 � ������   
              CMP  FIRSTPNT, EAX  ; � ������ -1 ��������� � ����� ��������� ��� ������������� ����
              JE   end_p
              CMP  SECONDPNT, EAX
              JE   end_p
              
              
              
              
              ; ������ ����� �������
              
              ; �������� � ����� ���������� ������ �� ������ ������� �����
              MOV  ECX, FIRSTPNT
              LEA  ESI, INTEXT ; �������� ������� ����� ����������� ������ --------------  [EBP+8]        
              LEA  EDI, TEMP; �������� ������� ����� ����� ������               
              REP  MOVSB

              ; �������� ������ �����
              MOV  ECX, SECONDEND ; ���������� ���� �� ������ �����
              SUB  ECX, SECONDPNT;----------------------------------------------------------------------------------------------------------------
              PUSH ECX            ; ���������� ���� ��� ����������
                                  ; ������� ������� � ������ ������
              LEA  ESI, INTEXT    ; ���� --------------  [EBP+8]  
              ADD  ESI, SECONDPNT ; ������
              
                                  ; ������� ������� � ����� ������
              LEA  EDI, TEMP      ; ����
              ADD  EDI, FIRSTPNT  ; ������
              
              REP  MOVSB
              

              ; �������� ����� ������� �� ����� ������� ����� �� ������ ������� �����
                                  ; ������� ������� � ������ ������  
              LEA  ESI, INTEXT    ; ���� --------------  [EBP+8]  
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
              LEA  ESI, INTEXT    ; ���� --------------  [EBP+8]  
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
              LEA  ESI, INTEXT    ; ���� --------------  [EBP+8] 
              ADD  ESI, SECONDEND ; ������
                                  ; ������� ������� � ����� ������  
              LEA  EDI, TEMP      ; ����
              ADD  EDI, SECONDEND ; ������
              
                                  ; ���������� ��������
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





