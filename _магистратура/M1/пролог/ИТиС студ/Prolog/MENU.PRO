Code=320
Constants
   cz=63  %цвет пункта 
   col=28 %цвет пометки  
Domains  i = integer  s = string c = char
Database ar(i,i)
Predicates r_k(i) c_k(i,i) p(i,s,i,i,i)  o(i,i,i) bor an(i,i) start menu(i,i) 
Goal  start.
Clauses
start:- makewindow(1,0,0,"",0,0,25,80),
  makewindow(2,63,118," Г Л А В Н О Е    М Е Н Ю ",4,12,8,48),
  menu(1,4),p(1,A,Y,X,_),str_len(A,L),field_attr(Y,X,L,col),
  assert(ar(80,1)),bor,!.

% Вывод пунктов
  menu(X,Y):- p(X,A,Y1,X1,C),cursor(Y1,X1),write(A),
       str_len(A,L),field_attr(Y1,X1,L,C),X2=X+1,X<Y,menu(X2,Y),!.
  menu(X,Y):-X=Y,!.

% Циклическое считывание кода
  bor:- ar(K,R),r_k(K1), an(K1,R),fail.
  bor:- bor.
         
/*   основное пpавило    в  меню  */
an(Kod,R):- p(R,A,Y,X,C), o(R,Kod,Rs),
     p(Rs,As,Ys,Xs,Cs),o(Rs,Ks,_),str_len(A,L),str_len(As,Ls),
     field_attr(Y,X,L,C),field_attr(Ys,Xs,Ls,col),
     retractall(ar(_,_)),assert(ar(Kod,Rs)),!.
% Исполнение пунктов
% an(Kod,R):-R=1,Kod=13,.......
%..............................
an(Kod,R):-R=4,Kod=13,exit,!.
an(Kod,R):-!.

% Определяем номер пунка
 o(R,K,X):-K=80,X=R+1. o(R,K,X):-K=72,X=R-1.

% Чтение расширенного кода
   r_k(Kod):- readchar(C),char_int(C,A),c_k(A,Kod),!.
   c_k(A,Kod):- A<>0,Kod=A,!.
   c_k(0,Kod):- readchar(C),char_int(C,Kod),!.

% Факты пунктов меню - Номер пунка, пункт,координаты, цвет 
p(1," 1.  Режим пpосмотpа и pедактиpования",1,2,cz).
p(2," 2.  Режим pаботы с файлами",2,2,cz).
p(3," 3.  Режим многоаспектного поиска",3,2,cz).
p(4," 4.  Выход",4,2,cz).


