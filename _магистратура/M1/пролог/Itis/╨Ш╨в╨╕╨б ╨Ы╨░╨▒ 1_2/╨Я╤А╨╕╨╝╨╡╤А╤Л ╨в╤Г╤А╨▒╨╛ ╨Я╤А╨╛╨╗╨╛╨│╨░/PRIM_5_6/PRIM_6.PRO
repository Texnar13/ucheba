Domains
  i = integer  s = string  

Database - da1    % описание динамической базы данных с именем da1
           da(s,i)
Predicates
     start   % предикат целевого утверждения
     dtt     % для ввода новой даты 
     td(i,s) % для проверки правильности ввода с сохранением
Goal   start.
Clauses

start:- existfile("da.bd"),consult("da.bd",da1),
	makewindow(1,0,0,"",0,0,25,80), dtt, removewindow, !.

start.
dtt:-not(da(_,_)),assert(da("",1)).
dtt:- da(H1,_), 
	date(G,M,D),str_int(G1,G),str_int(M1,M),str_int(D1,D),
	concat("Введите дату (Esc - отказ) [СЕГОДНЯ:",D1,S1),
	concat(S1,".",S2),concat(S2,M1,S3),concat(S3,".",S4),
	concat(S4,G1,S5),concat(S5," г.]",S6),
	makewindow(5,48,91,S6,10,10,4,58),
	editmsg(H1,H2,"F10 - выход с сохpанением","","",0,"",C),
	removewindow,td(C,H2),!.
dtt:-dtt.  

td(C,H2):- C=0,str_len(H2,Ld),Ld<9,
	frontstr(2,H2,H3,H4),str_int(H3,Nd),Nd>0,Nd<32, 
	frontstr(1,H4,K1,K2),K1=".", frontstr(2,K2,P1,P2),
	str_int(P1,Nm),Nm<13,Nm>0, frontstr(1,P2,J1,J2),J1=".",
	frontstr(2,J2,Q1,Q2),str_int(Q1,Ng),Ng>=0,
	da(_,Bb),  retractall(da(_,_)),assert(da(H2,Bb)),
        save("da.bd",da1),!.
td(C,H2):- C=1,!.

