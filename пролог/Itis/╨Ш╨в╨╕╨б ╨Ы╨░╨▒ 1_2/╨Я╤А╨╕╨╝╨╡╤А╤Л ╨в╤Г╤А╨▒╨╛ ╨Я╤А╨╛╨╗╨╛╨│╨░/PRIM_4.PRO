% Использование механизма отсечки
Domains 
  s=string 
Predicates  
	start  
	woman(s)
	make_cut(s)
Goal start.
Clauses
start:- woman(Name),write(Name),nl,make_cut(Name),!,fail. 
make_cut(Name):-Name="Маша".

woman("Катя"). woman("Таня"). woman("Маша"). woman("Ира"). 
