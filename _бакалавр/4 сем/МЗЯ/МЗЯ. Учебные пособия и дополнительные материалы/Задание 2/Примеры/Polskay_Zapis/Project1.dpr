program Compiler2;

{$APPTYPE CONSOLE}

uses
  SysUtils;
{ Программа не ловит ошибки "Два операнда подряд", "Две операции подряд"}
Type SetofChar=set of AnsiChar;
Const Razd:setofChar=[' ','+','-','*','/','(',')'];
Var St,StS,Comands:shortstring;
    R:boolean;

Function Scan(St:shortstring;Razd:setofChar;Var StS:shortstring):boolean;forward;
Function Polskay_Zapis(St:shortstring;Var Comands:shortString):boolean;forward;

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
         StS:=StS+St[1];
         Delete(St,1,1);
       end;
       Probel(St);
     end;
     WriteLn('After Scan:',StS);
     Result:=R;
  End;
 Function Polskay_Zapis(St:shortstring;Var Comands:shortString):boolean;
 Const TablePred:array[0..3,1..6] of byte=((1,1,1,10,5,10),
                                           (2,1,1,4,4,10),
                                           (4,2,1,4,4,10),
                                           (1,1,1,3,10,10));
 Var StackOperation:shortString;
     IndStr,IndCol:byte;
     Konec:boolean;
 begin

    Comands:='';
    Konec:=false;
    StackOperation:='>';
    St:=St+'<';
    while not Konec do
    begin
      if (St[1]='I') then
      begin
         Comands:=Comands+'I';
         Delete(St,1,1);
      end
      else
        if (St[1]<>'I') then
           begin
             case StackOperation[length(StackOperation)] of
             '+','-':  IndStr:=1;
             '*','/':  IndStr:=2;
             '(': IndStr:=3;
             '>': IndStr:=0;
             else IndStr:=0;
             end;
             case St[1] of
             '+','-':  IndCol:=1;
             '*','/':  IndCol:=2;
             '(': IndCol:=3;
             ')': IndCol:=4;
             '<': IndCol:=5;
             else IndCol:=6;
             end;
             case TablePred[IndStr,IndCol] of
             1: begin
                  StackOperation:=StackOperation+St[1];
                  Delete(St,1,1);
                end;
             2: begin
                  ComandS:=Comands+StackOperation[length(StackOperation)];
                  Delete(StackOperation,length(StackOperation),1);
                  StackOperation:=StackOperation+St[1];
                  Delete(St,1,1);
                end;
             3: begin
                  Delete(StackOperation,length(StackOperation),1);
                  Delete(St,1,1);
                end;
             4: begin
                  ComandS:=Comands+StackOperation[length(StackOperation)];
                  Delete(StackOperation,length(StackOperation),1);
                end;
             5: begin
                  Result:=true;
                  Konec:=true;
                  WriteLn('Comands:',Comands);
                end;
             10:begin
                  Result:=false;
                  Konec:=true;
                  WriteLn('Comands:',Comands,' St[1]=',St[1]);
                end;
             end;
           end
        else
        begin
           Result:=false;
           Konec:=true;
           WriteLn('Comands:',Comands,' St[1]=',St[1]);
        end;
    end;
 end;

Begin
  Writeln('Input Strings:'); Readln(St);
  R:=true;
  While (St<>'end') and R do
    Begin
      R:=Scan(St,Razd,StS);
      if R then R:=Polskay_Zapis(StS,Comands);

      if R then Writeln('Yes')
           else Writeln('No');
      Writeln('Input Strings:'); Readln(St);
      R:=true;
    End;
    writeln('Press Enter');
    readln;
End.
