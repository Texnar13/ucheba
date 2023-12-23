%Поиск слова в строке
Domains
  i = integer  s = string  c = char  file=f
  list=integer* %  список целых чисел
Database
  sp(i,s,i)
  s(s) b(s) slo(i,s) n(i)

Predicates
 start  del wiw 
 
Goal start.

Clauses
start:-makewindow(1,1,7,"",0,0,25,80),
       makewindow(2,27,47,"Введите слово для поиска",5,10,15,59),
       S="aaa  bbb  ccc  ddd   eee  fff   ggg",write(S),nl,
       readln(Sp),str_len(Sp,L), 
       retractall(sp(_,_,_)),assert(sp(L,Sp,0)),
       retractall(s(_)),assert(s(S)),
       retractall(b(_)),assert(b(S)),
       retractall(n(_)),assert(n(0)),
       del,wiw. 
  
del:-b(S),sp(L,Sp,_),frontstr(L,S,S1,S2),
     S1=Sp,n(N),retractall(sp(_,_,_)),assert(sp(L,Sp,N)),!.
del:-b(S),frontchar(S,C,Sz),retractall(b(_)),assert(b(Sz)),
     n(N),retractall(n(_)),N1=N+1,assert(n(N1)),fail.
del:-b(""),!.
del:-del.
     
wiw:-sp(L,S,N),N<>0,s(Si),nl,write(Si),
     cursor(Y,X),cursor(Y,N),field_attr(Y,N,L,56),
     readchar(_),!.     
wiw:-sp(L,S,0),nl,write(S," - не найдено"), readchar(_),!.     
