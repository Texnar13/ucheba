program Compiler3;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type SetofChar=set of AnsiChar;
     Troyki=array[1..10] of shortstring;
Const Razd:setofChar=[' ','+','-','*','/','(',')',':',';','<','>','='];
Var St,StS:shortstring;  Comands:Troyki;
    R:boolean;

Function Scan(St:shortstring;Razd:setofChar;Var StS:shortstring):boolean;forward;
Function Predshest(St:shortstring;Var Comands:Troyki):boolean;forward;

Procedure Error(St:shortstring); {вывод сообщений об ошибках}
  Begin      WriteLn('Error *** ', st, ' ***');  End;

Procedure Probel(Var St:shortstring); {удаление пробелов}
  Begin   While (St<>'') and (St[1]=' ') do Delete(St,1,1);   End;


Function Id2(Var St:shortstring;Razd:setofChar):boolean; {распознаватель идентиф.}
  Var S:shortString; State,Col:byte;
  Const TableId:array[1..2,1..4] of Byte=((2,0,0,0),(2,2,10,0));
  Begin
    Probel(St);
    State:=1;
    S:='';
    while (State<>0) and (State<>10) and (Length(St)<>0) do
    begin
      if St[1] in ['A'..'Z','a'..'z'] then  Col:=1
      else  if St[1] in ['0'..'9'] then Col:=2
            else if (St[1] in Razd) then Col:=3
                 else Col:=4;
      State:=TableId[State,Col];
      if (State<>0) and (State<>10) then
      begin
        S:=S+St[1];
        Delete(St,1,1);
      end;
    end;
    if length(st)=0 then State:=10;
    if (State=10) and (S<>'') then
      Begin
        Result:=true;  WriteLn('Identify=',S);
      End
    else
      if (State=0) then
          Begin
             Result:=false; WriteLn('Wrong symbol *',St[1],'*');
          End
      else
          Begin
             Result:=false; WriteLn('Identifier waits...', St);
          End;
  End;

Function Scan(St:shortstring;Razd:setofChar;Var StS:shortstring):boolean;
Const SlSl:array[1..3] of shortString=('if','then','else');
  Var R:boolean; i,k:byte; Stl:shortstring;
  Begin
     R:=true;
     StS:='';
     Probel(St);
     while (length(St)<>0) and R do
     begin
       if not (St[1] in Razd) then
       begin
          k:=Pos(' ',St);
          if k<>0 then
          begin
             Stl:=Copy(St,1,k-1);
             i:=1;
             while (Stl<>SlSl[i]) and (i<4) do i:=i+1;
             if i<>4 then
               begin
                  WriteLn('Slugeb slovo ',Stl);
                  Delete(St,1,k-1);
                  if (Stl[1]='I') or (Stl[1]='i') then StS:=StS+'@@';
                  StS:=StS+Copy(Stl,1,2);
                  R:=true;
               end
             else
               begin
                   R:=Id2(St,Razd);
                   if R then StS:=StS+'V ';
               end;
          end
          else
             begin
                R:=Id2(St,Razd);
                if R then StS:=StS+'V ';
             end
       end
       else
          begin
             if St[1]='(' then Sts:=StS+'@@';
             Sts:=StS+St[1];
             Delete(St,1,1);
             if St[1] in ['=','>'] then
             begin
                StS:=StS+St[1];
                Delete(St,1,1);
             end
             else StS:=StS+' ';
             WriteLn('Slugeb simbol ',Copy(StS,length(StS)-1,2));
          end;
       Probel(St);
     end;
     WriteLn('After Scan:',StS);
     Result:=R;
  End;

 Function Predshest(St:shortstring;Var Comands:Troyki):boolean;
 Const TablePred:array[0..8,1..11] of byte=
         { 1  2  3  4  5  6  7  8  9 10 11
           =  +  *  (  ) := If Th El  ; ?? }
{0 #  } ((50,50,50,50,50,01,01,50,50,05,50),
{1 =  }  (50,50,50,50,50,50,50,03,50,50,50),     // L
{2 +  }  (50,03,01,01,03,50,50,50,50,03,50),     // R
{3 *  }  (50,03,03,01,03,50,50,50,50,03,50),     // R
{4 (  }  (50,01,01,01,04,50,50,50,50,50,50),
{5 := }  (50,01,01,01,50,50,50,50,03,03,50),     // Op
{6 If }  (01,50,50,50,50,50,50,02,50,50,50),
{7 Th }  (50,50,50,50,50,01,01,50,02,03,50),     // If1
{8 El }  (50,50,50,50,50,01,01,50,03,03,50));    // If2
 Var Stack:shortString;
     i,i1,IndStr,IndCol:byte;
     Konec:boolean;
 Procedure Begin01(Var St,Stack:shortstring);
 Begin
    Stack:=Stack+'<.';
    Stack:=Stack+Copy(St,1,4);
    Delete(St,1,4);
 end;
 Procedure End03(Var i:byte;Var St,Stack:shortstring;Var Comands:Troyki);
 Var k,k1:byte;
 begin
    i:=i+1;
    k:=0;
    k1:=length(Stack)-1;
    While k=0 do
    begin
       if copy(Stack,k1,2) ='<.' then  k:=k1;
       k1:=k1-4;
    end;
    if Stack[k+2]='@' then Comands[i]:=Copy(Stack,k+4,length(Stack)-k-3)
    else Comands[i]:=Copy(Stack,k+2,length(Stack)-k-1);
    Delete(Stack,k,length(Stack)-k+1);
    if Stack[length(Stack)]='@' then Delete(Stack,length(Stack)-1,2);
    Comands[i]:=Comands[i]+copy(St,1,2);
    Delete(St,1,2);
    // Здесь должна быть проверка
    if (Comands[i][1]='i') or (Comands[1]='I') then Insert('OI',St,1)
    else if Comands[i][3]in ['+','-','*'] then Insert('C ',St,1)
         else if Comands[i][3]= ':' then Insert('Op',St,1)
              else if Comands[i][3]in ['<','>','='] then Insert('L ',St,1);
 end;
 Procedure Middle02(Var St,Stack:shortstring);
 Begin
    Stack:=Stack+Copy(St,1,4);
    Delete(St,1,4);
 end;
 Procedure Skobki(Var St,Stack:shortstring);
 begin
    Delete(Stack,length(Stack)-1,2);
    if Stack[length(Stack)]='@' then Delete(Stack,length(Stack)-1,2);
    if Stack[length(Stack)-1]='<' then Delete(Stack,length(Stack)-1,2);
    Delete(St,2,2);
 end;
 Begin
    i:=0;
    Konec:=false;
    Result:=false;
    Stack:='# ';
    while not Konec do
    begin
       case Stack[length(Stack)-1] of
         '=','>','<':  IndStr:=1;
         '+','-':      IndStr:=2;
         '*','/':      IndStr:=3;
         '(': IndStr:=4;
         ':': IndStr:=5;
         'I','i': IndStr:=6;
         'T','t': IndStr:=7;
         'E','e': IndStr:=8;
         '#': IndStr:=0;
         else IndStr:=0;
       end;
       case St[3] of
         '=','>','<':  IndCol:=1;
         '+','-':      IndCol:=2;
         '*','/':      IndCol:=3;
         '(': IndCol:=4;
         ')': IndCol:=5;
         ':': IndCol:=6;
         'I','i': IndCol:=7;
         'T','t': IndCol:=8;
         'E','e': IndCol:=9;
         ';': IndCol:=10;
         else IndStr:=11;
       end;
       case TablePred[IndStr,IndCol] of
         1: Begin01(St,Stack);
         2: Middle02(St,Stack);
         3: End03(i,St,Stack,Comands);
         4: Skobki(St,Stack);
         5: begin
              Result:=true;
              Konec:=true;
              For i1:=1 to i do WriteLn('Comands:',Comands[i1]);
            end;
         50: begin
               Konec:=true;
               For i1:=1 to i do WriteLn('Comands:',Comands[i1]);
               WriteLn('St=',St);
             end;
       end;
    end;
 end;

Begin
  Writeln('Input Strings:'); Readln(St);
  R:=true;
  While (St<>'end') and R do
    Begin
      R:=Scan(St,Razd,StS);
      if R then R:=Predshest(StS,Comands);
      if R then Writeln('Yes')
           else Writeln('No');
      Writeln('Input Strings:'); Readln(St);
      R:=true;
    End;
    writeln('Press Enter');
    readln;
End.
