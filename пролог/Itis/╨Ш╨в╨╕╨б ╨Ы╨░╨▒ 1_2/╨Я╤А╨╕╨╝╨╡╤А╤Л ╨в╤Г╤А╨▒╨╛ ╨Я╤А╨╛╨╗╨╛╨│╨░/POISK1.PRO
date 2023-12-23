% разбор и поиск слова в файле
Domains
  i = integer  s = string  c = char  file=f
  list=integer* %  список целых чисел
Database
  b(s) slo(i,s) n(i)
Predicates
 start  del tmp(i,s) 
Goal start.

Clauses
start:-makewindow(1,1,7,"",0,0,25,80),makewindow(2,27,47,"",5,10,15,59),
       file_str("a.pro",S),
      % S="aaa  bbb  ccc   ddd   eee ", nl,write(S),
       retractall(b(_)),assert(b(S)),
       retractall(n(_)),assert(n(0)),
       retractall(slo(_,_)),assert(slo(0,"")),
       del. 
  
del:-b(S),S<>"",fronttoken(S,S1,S2),n(N),N1=N+1,assert(slo(N1,S1)),
     nl, write(N1,". ",S1), tmp(N1,S1),retractall(b(_)),assert(b(S2)),
     retractall(n(_)),assert(n(N1)),fail,!.
del:-b(""),!.
del:-del.
     
tmp(N,"ccc"):-Write(" - это слово ссс"),!.     
tmp(N,S).     

     
     
     
     
     
     