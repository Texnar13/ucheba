/*************** ЭКСПЕРТНАЯ СИСТЕМА **********************/

CONSTANTS
       cz0=63 % исходный цвет закраски пунктов меню
       col=18 % цвет для пометки выбранных пунктов
       c1=63  % цвет фона и символов окон 14 и 15 
       c2=118 % цвет обрамления и названия окон 14 и 15

DOMAINS
% вводим с целью упрощения дальнейшего описания  
  i = integer  s = string c = char  r = real

DATABASE
   
wpw(s,s,s,s,s,s,s,s,s) % для хранения вариантов ответов и вероятности инфаркта

ar(i,i)  %для хранения кода нажатой клавиши и номера выбранного пункта меню 
  
mn(i,i)  % вспомогательная база для вывода меню
 
tw(i)    % для хранения текущего номера вопроса или кода меню

aw(i,s)  % вспомогательная база интерфейсной части 

rom(i,i) % для отдельного хранения номера вопроса и ответа

ind(i)   % для индикации: 1 - работа в главном режиме; 2 - в режиме опроса

q(i)     % вспомогательная база режима опроса
 

PREDICATES
     start      % предикат целевого утверждения
     menu       % для работы с меню
     wop(i,i,i) 
     k(i)       % факты кодов клавиш стрелок 
     
     read_kod(i)  char_kod(i,i) % для чтения с клавиатуры
     o(i,i,s,i,i)  d(i,i,i,i)   % для описания фактов меню
     
     bor         % для основного цикла программы
     an(i,i)     % для анализа и обработки нажатых клавиш
     uz(i,i,s,i) % для описания фактов-вопросов 
         
     rw(i) ro(i,i) pw(i) po(i,i) % для разметки или пометки пунктов меню
     
     lop(i)      % для организации считывания цифр в режиме опроса
     let(i,s)
     cur(i,i,i) 
     asrom(i,i)  % для инициализации базы с предикатом rom
     lb(i,i)     % для защиты по количеству вводимых цифр
     preobr      % для описания основных правил непосредственного 
     vero(r,s)   % определения баллов и вероятности инфаркта 
     dbl(i,s)    % для работы с базой rom(i,i)
     qduk        % для работы с базой q(i)
     lb1(i,i)    % факты для ограничения диапазона ввода цифр
     wiw         % для вывода информации в окно пройденного пути
     wiwex  	 % для вывода основного результата работы системы
     sob         % для вывода служебного сообщения

GOAL
  assert(ind(1)),assert(wpw("","","","","","","","","")),
  makewindow(3,c1,c2," П Р О Й Д Е Н Н Ы Й   П У Т Ь ",2,40,21,37),
  makewindow(4,c1,c2," О К Н О   Д И А Л О Г А ",2,3,21,37),
  start.

CLAUSES

start:-ind(Q),Q=1, 
  makewindow(1,82,111," МЕДИЦИНСКАЯ ЭКСПЕРТНАЯ СИСТЕМА ",0,0,25,80),
  makewindow(2,62,c2," ГЛАВНОЕ МЕНЮ ",5,10,8,50),
  retractall(mn(_,_)),assert(mn(10,10)), menu,
  retractall(mn(_,_)),po(10,1),  
  retractall(tw(_)),assert(tw(10)),
  retractall(ar(_,_)),assert(ar(80,1)),
  bor,!.

% считывание из базы пунктов меню 
menu:- mn(N1,N2),X2=N1+1,N1<N2+1,retractall(mn(_,_)),
        assert(mn(X2,N2)),uz(N1,_,_,Y), wop(N1,1,Y),fail.
menu:- mn(N1,N2),N1<N2+1,menu,!.
menu:- mn(N1,N2),N1=N2+1,!.

% непосредственный вывод пунктов меню
wop(N,X,Y):-  o(N,X,A,D1,D2),cursor(D1,D2),
              write(A),str_len(A,L),field_attr(D1,D2,L,cz0),
              X2=X+1,X<Y,wop(N,X2,Y),!.
wop(N,X,Y):-X=Y,!.

% Инициализация вспомогательной базы для хранения вариантов ответов
asrom(N,M):-N<=M,assert(rom(N,0)),N1=N+1,asrom(N1,M).
asrom(N,M).

% Основные правила анализа выбранных пунктов меню и
%	чтения кода клавиш

bor:- ar(K,R),K<>100,tw(W),W>4,W<>6,W<8,read_kod(K1), an(K1,R),fail.
bor:- ar(K,R),K=100,tw(W),W>4,W<>6,W<8, an(K,R),fail.
bor:- ar(K,R),K<>27,tw(W),W<7,W<>5,an(K,R),fail.
bor:- ar(K,R),K<>13,tw(W),W=10,read_kod(K1),an(K1,R),fail.

% выход на исполнение пунктов главного меню
bor:- ar(13,R),tw(10),R=1,an(300,1),fail,!. % режим опроса
bor:- ar(13,R),tw(10),R=2,an(500,1),fail,!. % сведения о системе
bor:- ar(13,R),tw(10),R=3,exit.             % выход из системы

% Если код 27, то выходим в главное меню
bor:- ar(K,R),K=27,retractall(ind(_)),assert(ind(1)),
       retractall(ar(_,_)),assert(ar(80,1)), an(K,R),  fail,!.

% Если вопросы закончились (их 7, т.е. W=8), то выводим результаты экспертизы  
bor:- ind(Y),Y=2,tw(W),W=8, wiwex,
       retractall(ind(_)),assert(ind(1)),
       retractall(ar(_,_)),assert(ar(80,1)),
       an(27,1),fail,!.

bor:- ind(Y),Y=2,q(X),X=1,retractall(ar(_,_)),assert(ar(80,1)),an(27,1),fail,!.

bor:-!,bor.

% Коды клавиш стрелок вверх и вниз        
k(72).k(80).

% Анализ нажатия клавиши Esc, если нажата, то 
%  возвращаемся в главное меню с установкой исходных параметров 
an(K,R):-K=27,ind(Q),Q=1,retractall(q(_)), 
  shiftwindow(1),shiftwindow(2),
  retractall(mn(_,_)),assert(mn(10,10)),  menu,
  retractall(mn(_,_)),po(10,1),  
  retractall(tw(_)),assert(tw(10)),
  retractall(ar(_,_)),assert(ar(80,1)),!.
  
% если режим опроса,то устанавливаем параметры и в итоге активизируем окно 4
an(K,R):-K=300, retractall(ind(_)),assert(ind(2)),
        retractall(tw(_)),assert(tw(1)),
  retractall(rom(_,_)),asrom(1,7),
  retractall(ar(_,_)),assert(ar(80,1)),
  shiftwindow(3),wiw,shiftwindow(4),clearwindow,sob,!.

an(K,R):-K=500,
  makewindow(5,30,112,"КРАТКИЕ СВЕДЕНИЯ О СИСТЕМЕ ( Выход - Esc ... ) ",3,5,12,70),nl,nl,
  Sf="prim2_es.hlp",existfile(Sf),file_str(Sf,S),display(S), removewindow,
  retractall(ind(_)),assert(ind(2)),retractall(ar(_,_)),assert(ar(80,2)),!.


an(K,R):-ind(Q),Q=0,removewindow,removewindow,removewindow,removewindow,
         removewindow,removewindow,removewindow,removewindow,exit.

an(K,R):-ind(O),O=2,
         K=100,tw(W),W>4,W<8,W<>6,
         shiftwindow(4),clearwindow,sob,
         uz(W,Y,P2,_),cursor(Y,2),write(P2),
         retractall(mn(_,_)),assert(mn(W,W)),
         menu,retractall(mn(_,_)),  
         field_attr(Y,16,1,240),         
         po(W,1),retractall(ar(_,_)),assert(ar(80,1)),!.

an(K,R):-ind(O),O=2, K=13,tw(W),W>4,W<8,W<>6,
         retractall(rom(W,_)),
         Ws=W+1,Rs=R-1,assert(rom(W,Rs)),
         retractall(tw(_)),assert(tw(Ws)),
         shiftwindow(3),wiw,gotowindow(4),
         retractall(ar(_,_)),assert(ar(80,1)),!.

an(K,R):-k(K),tw(W),W>4,W<>6,W<8,uz(W,W2,S,_),
     str_len(S,Lw),
     o(W,R,A,Y,X),d(W,R,K,Rs),
     o(W,Rs,As,Ys,Xs),d(W,Rs,Ks,_),str_len(A,L),str_len(As,Ls),
     field_attr(Y,X,L,c1),field_attr(Ys,Xs,Ls,col),
     retractall(ar(_,_)),assert(ar(K,Rs)),!.

an(K,R):-k(K),tw(W),W>8,
     o(W,R,A,Y,X),d(W,R,K,Rs),
     o(W,Rs,As,Ys,Xs),d(W,Rs,Ks,_),str_len(A,L),str_len(As,Ls),
     field_attr(Y,X,L,c1),field_attr(Ys,Xs,Ls,col),
     retractall(ar(_,_)),assert(ar(K,Rs)),!.

an(K,R):-K=13,tw(W),W=10,R=1,retractall(ind(_)),assert(ind(2)),
          retractall(ar(_,_)),assert(ar(K,R)),!.

an(K,R):-K=13,tw(W),W=10,R=2,
         retractall(ind(_)),assert(ind(3)),
         retractall(ar(_,_)),assert(ar(K,R)),!.

an(K,R):-K=13,tw(W),W=10,R=3,retractall(ar(_,_)),assert(ar(K,R)),!.

an(K,R):- ind(O),O=2, q(U),U=1,retractall(q(_)),
          retractall(ind(_)),assert(ind(1)),
          retractall(ar(_,_)),assert(ar(K,R)),!.

an(K,R):-ind(O),tw(W),O=2,W<7,W<>5,
         shiftwindow(4),clearwindow,sob,
         uz(W,Y,P2,_),cursor(Y,2),
         write(P2), field_attr(Y,16,1,240),         
         cur(W,Y1,X1),cursor(Y1,X1),
         let(W,Lt),qduk,
         dbl(W,Lt), retractall(tw(_)),
         W1=W+1,assert(tw(W1)),
         shiftwindow(3),wiw,gotowindow(4),
         retractall(ar(_,_)),assert(ar(100,1)),!.

an(K,R):-ind(O),O=2, tw(W),W<7,W<>5,
         retractall(ar(_,_)),assert(ar(27,1)),!.

an(K,R):-ind(O),O=3,K=13,tw(W),W>4,W<8,W<>6,
         retractall(rom(W,_)),
         Rs=R-1,assert(rom(W,Rs)),
         retractall(ar(_,_)),assert(ar(80,R)),
         fail, !.

an(K,R):-ind(O),O=3,K=27,tw(W),W>4,W<8,W<>6,
         retractall(tw(_)), assert(tw(20)),
         retractall(ar(_,_)),assert(ar(80,W)),
         shiftwindow(2), !.

an(K,R):-ind(O),O=2,K=27,tw(W),W>4,W<8,W<>6,
         retractall(q(_)),assert(q(1)),!.

an(K,R).

sob:-cursor(18,0),S="Esc - выход",write(S),
     str_len(S,L),field_attr(18,0,L,112),!.
sob.

qduk:-not(q(_)),!.
qduk:-q(V),V<>3,!.

% преобразуем и добавляем ответ в базу данных
dbl(R,Lt):-str_int(Lt,N),retractall(rom(R,_)),assert(rom(R,N)),!.
dbl(R,Lt).

% основное правило для подсчета количества баллов по каждому вопросу
% и обновление результирующей базы  
preobr:- rom(1,X1),rom(2,X2),rom(3,X3),
         rom(4,X4),rom(5,X5),rom(6,X6),rom(7,X7),
         M=4.2*X1+3.6*X2+4.5*X3+222*X4+68*X5-78*X6+224*X7,
         str_int(S1,X1),str_int(S2,X2),str_int(S3,X3),
         str_int(S4,X4),str_int(S5,X5),str_int(S6,X6),str_int(S7,X7),
         str_real(S8,M), vero(M,S9),
         wpw(H1,H2,H3,H4,H5,H6,H7,H8,H9),
         retractall(wpw(_,_,_,_,_,_,_,_,_)),
         assert(wpw(S1,S2,S3,S4,S5,S6,S7,S8,S9)),!.
preobr.


cur(1,9,16).cur(2,10,16).cur(3,10,16).cur(4,10,16).cur(6,11,16).
   
let(W,X):-  retractall(aw(_,_)),assert(aw(1,"")),
            rom(W,U),lop(W),aw(E,X),!.


% для защиты по количеству вводимых цифр при ответе на вопросы
lb(1,2).lb(2,2).lb(3,3).lb(4,1).lb(6,2).

% факты, ограничивающие диапазон ввода цифр для всех вопросов,
% кроме 5-го и 7-го  
lb1(1,100). % для количества лет, т.е. по 1-му вопросу и т.д.
lb1(2,X):-rom(1,X),!.
lb1(3,301).
lb1(4,10).
lb1(6,169).

% основное правило описывающее интерфейсную часть
% диалогового окна (анализ и обработка нажатых клавиш) 
% и защита от случайного ввода
   
   % анализ клавиш цифр (коды 48 - 57) и формирование строки ответа  
   % позволяет ввести только цифры

lop(W):-ind(G),G=2,aw(X,Q),read_kod(K),retractall(aw(_,_)),
      assert(aw(K,Q)),K>=48,K<=57,char_int(C,K),
     str_len(Q,L),lb(W,M),L<M,
     write(C),str_char(S,C),concat(Q,S,S1),
     retractall(aw(_,_)),assert(aw(K,S1)),fail.

   % обработка клавиши Esc (код 27) - выход из цикла
lop(W):-ind(G),G=2,aw(X,Q),X=27,retractall(q(_)),assert(q(1)),!.
 
   % обработка клавиши Enter (код 13) - выход из цикла
lop(W):-ind(G),G=2,aw(X,Q),X=13,str_len(Q,L),lb(W,M),L<=M,str_int(Q,M1),!.

   % обработка клавиши Backspase (код 8)
lop(W):-aw(X,Q),X<>13,X=8,str_len(Q,L),L>0,
          cur(W,E1,E2), cursor(E1,E2),write("       "),
          retractall(aw(_,_)),assert(aw(1,"")),
          cursor(E1,E2), rom(W,U), fail.
   % зацикливаем правило
lop(W):-lop(W).


% правила для изменения цвета пунктов меню на экране 
ro(W,R):-o(W,R,A,Y,X),str_len(A,L),field_attr(Y,X,L,58),!.
po(W,R):-o(W,R,A,Y,X),str_len(A,L),field_attr(Y,X,L,col),!.
po(W,R).

rw(R):- uz(R,W,S,_), str_len(S,L),field_attr(W,2,1,62),!.
pw(R):- uz(R,W,S,_), str_len(S,L),field_attr(W,2,1,240),!.

% вывод информации о пройденном пути
wiw:- clearwindow,preobr, wpw(H1,H2,H3,H4,H5,H6,H7,H8,H9),
        cursor(2,0),
          write("\n              ВОЗРАСТ : ",H1,"\n             КУРИТ(Л) : ",H2),
          write("\n     ВЕРХНЕЕ ДАВЛЕНИЕ : ",H3,"\n КОЛИЧЕСТВО ИНФАРКТОВ : ",H4),
          write("\n     НАСЛЕДСТВЕННОСТЬ : ",H5,"\n                СПОРТ : ",H6),
          write("\n        БОЛИ В СЕРДЦЕ : ",H7), !.
   

% Вывод результатов экспертизы
wiwex:-  preobr, wpw(H1,H2,H3,H4,H5,H6,H7,H8,H9),
    makewindow(10,0,0,"",17,22,3,38),
    makewindow(11,32,31,"ВЫВОДЫ ЭКСПЕРТНОЙ СИСТЕМЫ ",16,20,3,38),
    write("     Вероятность инфаркта - ",H9,"%"),readchar(_),
    removewindow,removewindow, !.
        
% Основные правила, определяющие вероятность инфаркта
% по набранным баллам
vero(M,S):-M<570,S="0",!. 
vero(M,S):-M>=570,M<=595,S="5",!. 
vero(M,S):-M>595,M<=810,S="15",!. 
vero(M,S):-M>810,M<=860,S="35",!. 
vero(M,S):-M>860,M<=920,S="55",!. 
vero(M,S):-M>920,M<=1100,S="70",!. 
vero(M,S):-M>1100,M<=1800,S="90",!. 
vero(M,S):-M>1800,S="100",!. 
vero(M,S):-S="",!. 

% База вопросов 
% Имеет формат:
% uz(N вопроса; координата по У; вопрос; кол. пунктов,если вопрос по меню)  

uz(1,3,"              1\n\n\n\n       Сколько  вам  лет ?",1).
uz(2,3,"              2\n\n\n\n     Сколько  лет вы курите\n        или  курили  ?",1).
uz(3,3,"              3\n\n\n\n     Какое  у  вас  верхнее\n     артериальное давление ?",1).
uz(4,3,"              4\n\n\n\n     Сколько  было  у   Вас\n         инфарктов ?",1).
uz(5,3,"              5\n\n\n\n     Имелись  ли  сердечно-\n     сосудистые заболевания\n         у родителей ?",3).
uz(6,3,"              6\n\n\n\n     Сколько часов в неделю\n     Вы занимаетесь спортом\n       ( физкультурой ) ?",1).
uz(7,3,"              7\n\n\n\n     Есть ли  боли в сердце\n     при физической нагрузке ?",2).
uz(10,1,"",3).

% Описывают переход курсора при нажатии клавиш стрелок
% Факты для работы меню по 5-му вопросу
   d(5,1,80,2).d(5,1,72,3).d(5,2,80,3).d(5,2,72,1).d(5,3,80,1).d(5,3,72,2).

% Факты для работы меню по 7-му вопросу
   d(7,1,80,2).d(7,1,72,2).d(7,2,80,1).d(7,2,72,1).

% Факты для работы основного меню 
   d(10,1,80,2).d(10,1,72,3).
   d(10,2,80,3).d(10,2,72,1).
   d(10,3,80,1).d(10,3,72,2).

% Нижеперечисленные факты меню имеют следующий формат: 
% o(код меню, номер пункта меню, имя пункта, координата по Y и X) 

% Факты-пункты меню по 5-му вопросу
o(5,1,"НЕ ИМЕЛИСЬ",11,8).
o(5,2,"У ОДНОГО РОДИТЕЛЯ",12,8).
o(5,3,"У ОБОИХ РОДИТЕЛЕЙ",13,8).

% Факты-пункты меню по 7-му вопросу
o(7,1,"НЕТ",10,15).
o(7,2,"ДА",11,15).

% Факты-пункты главного меню 
o(10,1,"РЕЖИМ ОПРОСА",1,5).
o(10,2,"КРАТКИЕ СВЕДЕНИЯ О СИСТЕМЕ",2,5).
o(10,3,"ВЫХОД",3,5).

% Правила, позволяющие читать простой и расширенный коды
   read_kod(Kod):- readchar(C), char_int(C,A),char_kod(A,Kod),!.
   char_kod(A,Kod):- A<>0,Kod=A,!.
   char_kod(0,Kod):- readchar(C),char_int(C,Kod),!.
