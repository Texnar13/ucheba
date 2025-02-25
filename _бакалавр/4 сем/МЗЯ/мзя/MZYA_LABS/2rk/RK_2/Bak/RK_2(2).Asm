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
; ���� ������� B(5,6). ���������� � ����� ������� X(3,5) ������ ������� � ������� ��������. ���������� ������� ������� �� �����.   
;
; �����������: ������ ������� � ������ ������� B(5,6) ������ ��� �� ������ X(3,5), �� ����� � ���� ����������.          
        
        
; ���� ������� matr B(5,6)

        Invoke StdOut,  ADDR MsgEnter
                
        mov    ECX, 30
        MOV    EBX, 0 ; ������� �����
      
loop_enter:   ; ���� ����� ���� ���������
     
        
        push   ECX
        Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
        Invoke StripLF, ADDR myInBuffer      
        Invoke atol,    ADDR myInBuffer      
        pop    ECX
        MOV    matr[EBX*4], EAX    
        
        INC    EBX; ������� � ���������� �����
        LOOP   loop_enter
     
        Invoke StdOut,  ADDR MsgCalculate
        
        
;�������
        
        MOV    ECX, 5 ; ���-�� �����
        MOV    EBX, 0 ; ������� �����
five_loop:
        push   ECX; ������ ����� ������ ����, ������� ����� ���������
        

        ; ��������� ���
        mov    ECX, 3 ; ���������� ���������� �����
        MOV    ESI, 0 ; ������� ��������
third_loop:        
        
        ;EAX = EBX*5+ESI*2 
        mov    EAX, EBX 
        mov    EDI, 5
        mul    EDI
        mov    EDI, EAX ;EDI=EBX*5
        mov    EAX, 2
        MUL    ESI      ;EAX = 2*ESI
        add    EAX, EDI ;EAX = EAX+EDI = ESI*2+EBX*5 
        
        mov    EDI, matr[EAX]; ������� ����� ��� ������ ��������
        push   EDI; ���������� � ���� �������� ���������� �� matr
        
        
        mov    EAX, EBX ;EAX = EBX*3+ESI
        mov    EDI, 3
        mul    EDI
        add    EAX, ESI 
        
        pop    EDI; ���������� ����������� ��������
        mov    matr_new[EAX], EDI; � ���������� ��� � matr_new
       
        inc    ESI
        LOOP   third_loop; ��������� ������� � ������
        
        
        pop   ECX; ������� ������� ����������� �������

        ; ��������� � ��������� ������
        INC    EBX
        LOOP five_loop
        
; �����
     
        mov ECX, 3 ; ���������� ���������� �����
        mov EDI, 0 ; ������ ��������
         
        cycle_str_output: ; ���� �� �������
        
         push ECX 
         
         mov ECX, 5 ; ���������� ���������� �����
         cycle_col_output: ; ���� �� ��������
            
            push ECX ; �������� �������� ECX � ����		
            Invoke dwtoa, matr_new[EDI*4], ADDR myInBuffer ; ��������� ������� � ������
            Invoke StdOut, ADDR myInBuffer ; ������� �������
            Invoke StdOut, ADDR space ; ������ ������ ����������
            inc EDI ; ����������� ������ �������� �� 1
            pop ECX ; ����� �������� ECX �� �����
        
         loop cycle_col_output
         Invoke StdOut, ADDR nextLine ; ������ ������ ����� ������
         pop ECX 
     loop cycle_str_output
                 
       
   
     

       
       
       






         ;mov ans, AX
         ;Invoke dwtoa,  ans, ADDR myInBuffer ; ��������������� ����� � ������
         ;Invoke StdOut, ADDR myInBuffer             ; ����� ������





         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf myInBuffer	
	
         Invoke ExitProcess,0
         
End    Start

