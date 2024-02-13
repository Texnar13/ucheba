program Compiler;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type SetofChar=set of AnsiChar;
Const Razd:setofChar=[' ','+','-','*','/',')'];
Var St:shortstring;
    R:boolean;


Function Culc(Var St:shortstring;Razd:setofChar):boolean;forward;


Procedure Error(St:shortstring); {вывод сообщений об ошибках}
  Begin      WriteLn('Error *** ', st, ' ***');  End;

Procedure Probel(Var St:shortstring); {удаление пробелов}
  Begin   While (St<>'') and (St[1]=' ') do Delete(St,1,1);   End;

Function Id1(Var St:shortstring;Razd:setofChar):boolean; {распознаватель идентиф.}
  Var S:shortString;

  Begin
    Probel(St);
    S:='';
    if St[1] in ['A'..'Z','a'..'z'] then
       Begin
         S:=S+St[1]; Delete(St,1,1);
         While (St<>'') and (St[1] in ['A'..'Z','a'..'z'])
                or (St[1] in ['0'..'9']) do
            Begin
              S:=S+St[1]; Delete(St,1,1);
            End;
         if (St='') or (St[1] in Razd) then
            Begin
              Result:=true;  WriteLn('Identify=',S);
            End
         else
            Begin
              Result:=false; WriteLn('Wrong symbol *',St[1],'*');
            End;
       End
    else
       Begin
          Result:=false; WriteLn('Identifier waits...', St);
       End;
  End;

  Function Id2(Var St:shortstring;Razd:setofChar):boolean; {распознаватель идентиф.}
  Var S:shortString; State,Ind,Col:byte;
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

Function Mult(Var St:shortstring;Razd:setofChar):boolean;
  Var R:boolean;
  Begin
    Probel(St);
    if St[1]='(' then
      begin
        Delete(St,1,1); Probel(St);
        R:=Culc(St,Razd);
        Probel(St);
        if R and (St[1]=')') then Delete(St,1,1) else Error(St);
      end
    else R:=Id2(St,Razd);
    Mult:=R;
  End;

Function Term(Var St:shortstring;Razd:setofChar):boolean;
  Var R:boolean;
  Begin
     R:=Mult(St,Razd);
     if R then
       begin
         Probel(St);
         While ((St[1]='*') or (St[1]='/')) and R do
           begin
             Delete(St,1,1);
             R:=Mult(St,Razd);
           end;
       end;
     Term:=R;
  End;

Function Culc(Var St:shortstring;Razd:setofChar):boolean;
  Var R:boolean;
  Begin
     R:=Term(St,Razd);
     if R then
       begin
         Probel(St);
         While ((St[1]='+') or (St[1]='-')) and R do
           begin
             Delete(St,1,1);
             R:=Term(St,Razd);
           end;
       end;
     Culc:=R;
  End;

Begin
  Writeln('Input Strings:'); Readln(St);
  R:=true;
  While (St<>'end') and R do
    Begin
      R:=Culc(St,Razd);
      if R and (length(st)=0) then Writeln('Yes')
                              else Writeln('No');
      Writeln('Input Strings:'); Readln(St);
    End;
    writeln('Press Enter');
    readln;
End.
