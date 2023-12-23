Domains
  r = real s = string  c = char
  list=real* %  список вещественных чисел
  usp=u(r,list) % список условий срабатывания правил с учетом вопроса
  listusp=usp*
   
Database-f    % база фактов интерфейсного модуля
   w(r,r,s)   % вопросы 
   f(r,r,s)  % возможные ответы 

Database-rul    % база заключений
   rule(r,listusp,list,r) % факты заключений 
   z(r,s)  
             /* Общая база  */
Database
   b(s,s) quit % для вспомогательных целей
   wp_bd(r)    % для опроса
   f_act(r,r)  % для формирования активных фактов    
   buff(s)     % буфер выделенных слов или фраз
   vbuff(s)    % для формирование одного слова или одной фразы
   r_act(r,r)  % активные правила
   ok(r,r)     % для проверки на срабатывае правила
   f_s(r,r)    % сработанные факты и правила
   f_time(r,r)  % для проверки сработанных правил
   old_new(r,r)  % для выхода из МЛВ 
   
Predicates
 start 
 readmy(s) interface  rmv % предикаты интерфейсного модуля    
 asbuff(s,s)   % для множества выделенных слов или фраз
 prob(s,s)     % для определения лишних пробелов 
 predprob(s,s) % для удаления пробела перед разделителем
 opros  wp(r,r)       % для обработки вопросника
 d1(s) pr1(s,s) pr12(r) pr2(s) v(c,c)  sumb(s)  % для обработки строк
 formact asform(s)  % для формирования активных фактов
      % предикаты для организации механизма вывода
 repeat  no_iterac   analiz(r,listusp,list,r) 
 kol_u(listusp)    kol(list)
 cross_f(listusp)   cross_u(usp)  cross_r(list)
 pr_fs(r,r)  as_fs kol_r(list,r) kol_rs     
 ud_f_act  ud(r,r) % удаляем сработанные факты
 new_ok(r,r) prov(r,r)
 zak  outzakl           % вывод заключений
 inform inf_fs inf_rs 
  
  
  Goal start.
       
Clauses

start:-makewindow(1,1,7," ЭC определения животных (Выход - Esc... )",0,0,25,80),
       makewindow(2,27,47,"Перечислите возможные ответы",5,10,15,59),
       retractall(_),interface. 

interface:-  retractall(_), 		 % удаляем все факты общей базы
	     opros, not(quit),
	         	         /* МЛВ */
	     formact,    % формирование активных фактов
	     assert(old_new(0,0)), % начальные сработанные правила
	     repeat,     % вызов механизма вывода
	     zak,        % вывод результатов работы
	     fail.

interface:-  quit,cursor(5,10), write("Сеанс работы завершен ..."),
	     readchar(_),rmv,exit.
interface:- interface.
 
        /*удаляет все пользовательские окна */
rmv:- shiftwindow(N),N<=127,removewindow,fail.   
rmv:- shiftwindow(N),N>127. %  max 127- обозначений, max 34 окна
rmv:-rmv. 

% *************** Интерфейс с пользователем *********************
% *********** морфологический анализ декларативным методом ******

% Цикл опроса и формирование активных фактов (max 100 групп вопросов)
% Вопрос выводим как заголовок меню

opros:-not(wp_bd(_)),assert(wp_bd(1)),fail.
opros:- not(quit),  % если не Esc, то работаем дальше 
        wp_bd(G),wp(G,1),    
	retractall(wp_bd(_)),G<100,G1=G+1,assert(wp_bd(G1)),fail.     
opros:-wp_bd(G),G=100,not(quit),!.
opros:-quit,!.
opros:-opros.

wp(K,N):-W(K,N,W),not(quit),makewindow(3,91,27,W,10,14,4,50), d1(S),N1=N+1,
         removewindow,wp(K,N1),!.
wp(K,N):-quit,removewindow,!.
wp(K,N).

% возвращаем обработанную строку (буквы после обработки только строчные)

d1(S):- readmy(Sv), pr1(Sv,S), pr2(S),!.

readmy(S):-  readln(S),!.
readmy(S):-  S="",not(quit),assert(quit),fail. % если Esc

% обработка входной строки 
pr1(Sv,S1):- str_len(Sv,L),retractall(b(_,_)),
	     assert(b(Sv,"")),pr12(L),b(_,S1),!.
pr12(L):- b(S,H),L<>0,frontchar(S,C,So),v(C2,C),
          str_char(Sc,C2),concat(H,Sc,H1),
          retractall(b(_,_)),L1=L-1,assert(b(So,H1)),pr12(L1).
pr12(L):-L=0,!.
pr12(L):-pr12(L).

% формируем базу фактов выделенных слов или фраз
pr2(S):-S<>"",frontstr(1,S,S1,S2),asbuff(S1,S2),pr2(S2).
pr2(S).

% формируем в vbuff фразу или слово и отправляем в buff
% при этом лишние пробелы пропускаем

asbuff(S1,S2):-not(vbuff(_)),assert(vbuff("")),fail.
asbuff(S1,S2):-not(sumb(S1)),vbuff(S),prob(S1,S2),concat(S,S1,Sz),
	       retractall(vbuff(_)),assert(vbuff(Sz)),fail.
asbuff(S1,S2):-not(sumb(S1)),S2<>"",!.
asbuff(S1,S2):-vbuff(Sn), predprob(Sn,S),
	       retractall(vbuff(_)),assert(buff(S)),!.
% если разделитель, а предыдущий пробел, то удаляем этот пробел
predprob(Sn,S):- str_len(Sn,L),L1=L-1,frontstr(L1,Sn,Ss,Sz),Sz=" ",S=Ss,!.
predprob(Sn,S):- S=Sn,!.
		
% узнаем это лишний пробел или нет
prob(S1,S2):-S1<>" ",!. 
prob(S1,S2):-S1=" ",vbuff(S),S<>"",str_len(S,L),L1=L-1,
		frontstr(L1,S,Sn,Sz),Sz<>" ",!. 
prob(S1,S2):-S2="".  

sumb(",").sumb(".").sumb(";").    % разделители слов или фраз


 %*************** Формирование  активных фактов *****************

formact:-buff(A), asform(A),fail.
formact.	 
 		% получаем номера активных фактов 
asform(A):-f(W,N,A), not(f_act(W,N)),assert(f_act(W,N)),!.

/***** База правил  (процедурные знания) ************/
/* (перебираем все заключения и анализируем,
    получаем заключения сработанных правил fact_rule)*/

repeat:-rule(N,Split_f,Split_rule,Zakl),analiz(N,Split_f,Split_rule,Zakl),fail.
repeat:-kol_rs,no_iterac,!.  % если не нужно делать еще итерацию, то выходим
repeat:-repeat.

no_iterac:-old_new(S,N),S=N,retractall(old_new(_,_)),assert(old_new(0,0)),!.
no_iterac:-old_new(S,N),S<>N,retractall(old_new(_,_)),assert(old_new(N,0)),fail.

kol_rs:- r_act(P,_),old_new(S,N),N1=N+1,retractall(old_new(_,_)),
		assert(old_new(S,N1)),fail.
kol_rs.

% анализируем на срабатывание заключений

analiz(N,S_u,S_r,Z):-   retractall(f_time(_,_)), 
    new_ok(0,0), kol_u(S_u),    % анализ списка условий 
    cross_f(S_u), ok(Fu,Fa),  Fu=Fa,  as_fs,
    new_ok(0,0),  kol_r(S_r,0),
    cross_r(S_r), ok(R,Rs),   R=Rs,  % анализ сработанных правил
    prov(Fu,Rs),    % совместная проверка
    % ud_f_act,      % удаляем сработанные факты
    not(r_act(N,_)), assert(r_act(N,Z)),!. 
         
prov(X,Y):-X>0,Y=0; X=0,Y>0; X>0,Y>0.

as_fs:-f_time(W,A),not(f_s(W,A)),assert(f_s(W,A)),fail.
as_fs.

kol_u(S):-S=[],!.
kol_u([u(W,A)|B]):- not(A=[]), kol(A), kol_u(B),!.
kol([A|B]):-A>=0,ok(N,_),N1=N+1,new_ok(N1,0),kol(B),!.
kol(S):-!.

kol_r([A|B],N):-A>=0,N1=N+1,new_ok(N1,0),kol_r(B,N1).
kol_r(S,N).

  % анализ на пересечение фактов

cross_f(S):-S=[],!.% если условий нет, то выходим 
cross_f([A|B]):-  cross_u(A), cross_f(B).   %  отбираем u(W,[u1,...])
                
cross_u(u(W,[A|B])):- f_act(W,A), pr_fs(W,A), cross_u(u(W,B)).
cross_u(S):-!.

pr_fs(W,A):- not(f_time(W,A)), assert(f_time(W,A)),
	     ok(N,K),K1=K+1, new_ok(N,K1),!. 
pr_fs(W,A).

cross_r(S):-S=[],!. % анализ сработанных правил
cross_r([A|B]):-A>=0,r_act(A,Z),ok(N,K),K1=K+1,new_ok(N,K1),cross_r(B).

ud_f_act:-f_s(W,F),ud(W,F),fail. % удаляем сработанные факты
ud_f_act.

ud(W,F):-f_act(W,F),retractall(f_act(W,F)),!.

new_ok(A,B):-retractall(ok(_,_)),assert(ok(A,B)).


% Вывод сформированных заключений

zak:-r_act(_,_), % если есть заключения, то выводим
     makewindow(4,32,47," Результаты работы МЛВ ! ",3,4,17,70),
     outzakl,readchar(_),removewindow,inform,!.  
zak:-not(r_act(_,_)), % если нет заключений
     makewindow(4,32,47," Просим прощения ! ",3,4,17,70),
     cursor(5,10),write("Трудно что-нибудь вывести по данным фактам!"),   
     readchar(_),removewindow,!.  

outzakl:-r_act(N,Z),z(Z,S),write("Это ",S,".  (Сработало правило ",N,")"),
         nl,fail.
outzakl.

inform:-r_act(_,_),
        makewindow(4,20,30,"",0,0,25,80),write("Сработанные факты: "),nl,
	inf_fs,	write("Сработанные правила: "),nl,
	inf_rs, readchar(_),removewindow,!.
inform.

inf_fs:- f_s(W,F),write(W,"-",F,"   "),nl,fail.	inf_fs.	
inf_rs:- r_act(R,_),write(R,"  "),nl,fail.	inf_rs.	

% Вопросник разбивается по группам
W(1,1,"Что имеет ?").
W(1,2,"Что дает ?").
W(1,3,"Чем питается ?").
W(1,4,"Как перемещается ?").
W(2,1,"Что дополнительно можно добавить ?").

% База фактов интерфейса с пользователем (декларативные знания)
f(1,1,"волосы").
f(1,2,"копыта").
f(1,3,"зубы").   f(1,3,"острые зубы"). f(1,3,"зубы острые").
f(1,4,"когти").  f(1,4,"большие когти").
f(1,5,"глаза спереди"). f(1,5,"вперед смотрящие глаза").
f(1,6,"лапы").
f(1,7,"перья").

f(2,1,"молоко").
f(2,2,"яйца").

f(3,1,"мясо").
f(3,2,"жует жвачку"). f(3,2,"трава"). f(3,2,"растения").
f(3,3,"рыба").
f(3,4,"овощи").
f(3,5,"фрукты").
f(3,6,"чем угодно").f(3,6,"всем").f(3,6,"что попадется").

f(4,1,"летает").
f(4,2,"плавает").
f(4,3,"ходит"). 
f(4,4,"бегает"). f(4,4,"быстро бегает"). f(4,4,"бегает быстро").
 
f(5,1,"рыжевато-коричневый").
f(5,2,"темные пятна").  f(5,2,"пятна темные").
f(5,3,"черные полосы"). f(5,3,"полосы черные").
f(5,4,"длинные ноги").  f(5,4,"ноги длинные").
f(5,5,"длинная шея").   f(5,5,"шея длинная").
f(5,6,"не летает").  
f(5,7,"черное с белым").  f(5,7,"белое с черным").
f(5,8,"плавает").  
f(5,9,"хорошо летает").  f(5,9,"летает хорошо").

/***************** База фактов заключений ******************************
 rule(N правила, списки номеров фактов и срабатываемых правил,заключение) */
% группа правил реализует 'ИЛИ'  


rule(1,[u(1,[1])],[],1).
rule(1,[u(2,[1])],[],1).
rule(1,[u(1,[1]),u(2,[1])],[],1).

rule(2,[u(3,[1])],[],2).
rule(2,[u(3,[3])],[],2).
rule(2,[u(1,[3,4,5])],[],2).
rule(2,[u(1,[3,4,5]),u(2,[1])],[],2).
rule(2,[u(1,[3,4,5]),u(2,[3])],[],2).

rule(3,[u(3,[2])],[1],3).
rule(3,[u(1,[2])],[1],3).

rule(4,[u(2,[2]),u(4,[1])],[],4).
rule(4,[u(1,[7])],[],4).

rule(5,[u(5,[1,2])],[1,2],5).
rule(6,[u(5,[1,3])],[1,2],6).
rule(7,[u(5,[2,4,5])],[3],7).
rule(8,[u(5,[3])],[3,1],8).
rule(9,[u(5,[5,6,7])],[4],9).
rule(10,[u(5,[6,7,8])],[4],10).
rule(11,[u(5,[9])],[4],11).

z(1,"Млекопитающее").
z(2,"Хищник").
z(3,"Копытное").
z(4,"Птица").
z(5,"Обезьяна").
z(6,"Тигр").
z(7,"Жираф").
z(8,"Зебра").
z(9,"Страус").
z(10,"Пингвин").
z(11,"Альбатрос").

% Для преобразования входной строки из русских букв
v('й','Й').v('ш','Ш').v('в','В').v('д','Д').v('м','М').v('ц','Ц').
v('щ','Щ').v('а','А').v('ж','Ж').v('и','И').v('у','У').v('з','З').
v('п','П').v('э','Э').v('т','Т').v('к','К').v('х','Х').v('р','Р').
v('я','Я').v('ь','Ь').v('е','Е').v('ъ','Ъ').v('о','О').v('ч','Ч').
v('б','Б').v('н','Н').v('ф','Ф').v('л','Л').v('с','С').v('ю','Ю').
v('г','Г').v('ы','Ы').
v(C,C2):-C=C2,!.             

