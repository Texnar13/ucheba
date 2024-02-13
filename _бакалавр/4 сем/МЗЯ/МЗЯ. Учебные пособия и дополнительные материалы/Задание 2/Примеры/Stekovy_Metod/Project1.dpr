program Compiler3;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type SetofChar=set of AnsiChar;
     Troyki=array[1..10] of shortstring;
Const Razd:setofChar=[' ','+','-','*','/','(',')'];
Var St,StS:shortstring;  Comands:Troyki;
    R:boolean;

Function Scan(St:shortstring;Razd:setofChar;Var StS:shortstring):boolean;forward;
Function Stack_metod(St:shortstring;Var Comands:Troyki):boolean;forward;

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
  Var R:boolean;
  Begin
     R:=true;
     StS:='';
     Probel(St);
     while (length(St)<>0) and R do
     begin
       if not (St[1] in Razd) then
       begin
        R:=Id2(St,Razd);
        if R then StS:=StS+'I';
       end
       else
       begin
         if St[1]='(' then StS:= StS+'@';
         StS:=StS+St[1];
         Delete(St,1,1);
       end;
       Probel(St);
     end;
     WriteLn('After Scan:',StS);
     Result:=R;
  End;
 Function Stack_metod(St:shortstring;Var Comands:Troyki):boolean;
 Const TablePred:array[0..3,1..6] of byte=((1, 1, 1,10, 4,10),
                                           (2, 1, 1, 2, 2,10),
                                           (2, 2, 1, 2, 2,10),
                                           (1, 1, 1, 3,10,10));
 Var Stack:shortString;
     i,i1,IndStr,IndCol:byte;
     Konec:boolean;
 Procedure Perenos(Var St,Stack:shortstring);
 Begin
    Stack:=Stack+Copy(St,1,2);
    Delete(St,1,2);
 end;
 Procedure Svertka(Var i:byte;Var St,Stack:shortstring;Var Comands:Troyki);
 begin
    i:=i+1;
    Comands[i]:=Copy(Stack,length(Stack)-1,2);
    Delete(Stack,length(Stack)-1,2);
    Comands[i]:=Comands[i]+St[1];
    St[1]:='R';
 end;
 Procedure Odna_osnova(Var St,Stack:shortstring);
 Begin
    Delete(Stack,length(Stack),1);
    if Stack[length(Stack)]='@' then Delete(Stack,length(Stack),1);
    Delete(St,2,1);
 end;
 Begin
    i:=0;
    Konec:=false;
    Result:=false;
    Stack:='>';
    St:=St+'<';
    while not Konec do
    begin
       case Stack[length(Stack)] of
         '+','-':  IndStr:=1;
         '*','/':  IndStr:=2;
         '(': IndStr:=3;
         '>': IndStr:=0;
         else IndStr:=0;
       end;
       case St[2] of
         '+','-':  IndCol:=1;
         '*','/':  IndCol:=2;
         '(': IndCol:=3;
         ')': IndCol:=4;
         '<': IndCol:=5;
         else IndCol:=6;
       end;
       case TablePred[IndStr,IndCol] of
         1: Perenos(St,Stack);
         2: Svertka(i,St,Stack,Comands);
         3: Odna_osnova(St,Stack);
         4: begin
              Result:=true;
              Konec:=true;
              For i1:=1 to i do WriteLn('Comands:',Comands[i1]);
            end;
         10: begin
               Konec:=true;
               For i1:=1 to i do WriteLn('Comands:',Comands[i1]);
               WriteLn('St=',St);
             end;
         else
           begin
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
      if R then R:=Stack_metod(StS,Comands);
      if R then Writeln('Yes')
           else Writeln('No');
      Writeln('Input Strings:'); Readln(St);
      R:=true;
    End;
    writeln('Press Enter');
    readln;
End.
