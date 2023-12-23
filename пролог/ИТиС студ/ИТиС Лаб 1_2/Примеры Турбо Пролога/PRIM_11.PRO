Constants
      cz0=63  % начальный цвет  пунктов меню
      col=28  % цвет пометки пунктов меню
      c1=63   % цвет фона главного окна
      c2=118  % цвет рамки 
      kp=5    % количество пунктов меню
Domains
  i = integer  s = string  r=real
Database
  ar(i,i) mn(i,i,i)   
Predicates     
     mkw(i,i,i,s,i,i,i,i)  rmw  
     r_k(i)  c_k(i,i)   ko(i,s,i,i,i)  ord(i,i,i)
     bor  an(i,i)  start  menu(i,i)  ed_ar(i,i) uz(i,i,s)    
     codm(i,i) ed_mn(i,i,i) my(i,i) pm(i,i) zn(i) initm
        
Goal
   initm,% инициализация мыши
   start.% запуск меню

Clauses

start:- 
  mkw(1,31,52," ОТДЕЛ ГРАФИЧЕСКИХ СИСТЕМ ",0,0,25,80),
  Xnt=22,mkw(2,0,0,"",8,Xnt,9,33),
  Xn=Xnt-2,mkw(3,c1,c2," Г Л А В Н О Е    М Е Н Ю ",7,Xn,9,33),
  menu(1,kp),pm(1,1),zn(Xn), ed_ar(80,1),bor,!.

    % Вывод пунктов меню с помощью рекурсивного правила
menu(X,Y):- ko(X,A,Y1,X1,C),cursor(Y1,X1),write(A),
       str_len(A,L),field_attr(Y1,X1,L,C),X2=X+1,X<Y,menu(X2,Y),!.
menu(X,Y):-X=Y,!.

    % создание окна
mkw(A1,A2,A3,S,B1,B2,B3,B4):-makewindow(A1,A2,A3,S,B1,B2,B3,B4,1,255,"╔╗╚╝═║").
rmw:-removewindow,!.  % удаление окна   

	% главный цикл опроса 
bor:- keypressed,ar(_,R),r_k(K), an(K,R),fail.
bor:- codm(K,R),an(K,R),fail,!.   
bor:- bor.
         
/*   основное пpавило    в  меню  */

an(Kod,R):- ko(R,A,Y,X,C),ord(R,Kod,Rs), pm(1,Rs),pm(0,R),ed_ar(Kod,Rs),!.
an(Kod,R):-uz(R,Kod,S),existfile(S),!. 
an(Kod,R):-uz(R,Kod,S),mkw(26,112,67,"",4,10,3,52),cursor(0,5),
     write("  ФАЙЛ ",S," отсутствует !  "),readchar(_),rmw,!. 
an(Kod,R):-R=5,Kod=13,mkw(10,7,0,"",0,0,25,80), exit,!.
an(Kod,R):-!.

% номер пункта, код срабатывания, имя файла
uz(1,13,"form.exe").uz(2,13,"registr.exe").
uz(3,13,"report.exe").uz(4,13,"servis.exe").

% модификация служебной базы    
ed_ar(A,B):-retractall(ar(_,_)),assert(ar(A,B)),!.

% определение следующего пункта меню
ord(R,Kod,Rs):-R<kp,Kod=80,Rs=R+1.
ord(R,Kod,Rs):-R>1,Kod=72,Rs=R-1.


% факты пунктов меню
% ko(номер пункта,имя пункта,координата по Y, координата по X, цвет)
ko(1,"1. Формирование заказа",1,2,cz0).
ko(2,"2. Регистрация клиента",2,2,cz0).
ko(3,"3. Формирование отчета",3,2,cz0).
ko(4,"4. Сервисные функции",4,2,cz0).
ko(5,"5. Выход",5,2,cz0).

%Чтение расширенного кода
   r_k(Kod):- readchar(C), char_int(C,A),c_k(A,Kod),!.
   c_k(A,Kod):- A<>0,Kod=A,!.
   c_k(0,Kod):- readchar(C),char_int(C,Kod),!.

% пометка или разметка пунктов меню
pm(1,R):-ko(R,A,Y,X,_),str_len(A,L),field_attr(Y,X,L,col),!.
pm(0,R):-ko(R,A,Y,X,C),str_len(A,L),field_attr(Y,X,L,C),!.
pm(N,R).

    % Правила для мышки         
initm:-  bios($33, reg(0,0,0,0,0,0,0,0),reg(_,_,_,_,_,_,_,_)),
         bios($33, reg(1,0,0,0,0,0,0,0), reg(_,_,_,_,_,_,_,_)),!.   
initm.

codm(K,R):- bios($33, reg(3,0,0,0,0,0,0,0),reg(_,M,X,Y,_,_,_,_)),M=1,
       my(Y,R),mn(R,Xn,Xk),X>=Xn,X<=Xk,	ar(_,Rr),pm(0,Rr),pm(1,R),
       ed_ar(0,R),K=13,!.

my(72,1).my(80,2).my(88,3).my(96,4).my(104,5).

zn(O):- ko(R,A,Y,X,_),str_len(A,L),Xn=(O+X+1)*8,Xk=Xn+L*8-1,ed_mn(R,Xn,Xk),fail.
zn(O).

ed_mn(R,Xn,Xk):-retractall(mn(R,_,_)),assert(mn(R,Xn,Xk)),!.
