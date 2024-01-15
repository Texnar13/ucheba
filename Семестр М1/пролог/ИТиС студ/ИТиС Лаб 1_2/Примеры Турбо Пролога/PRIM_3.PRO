% Использование повторения для вывода содержимого базы фактов
Domains 
  s=string 
Predicates  
	start  
	woman(s)
Goal start.
Clauses
start:- woman(Name),write(Name),nl,fail. 
woman("Катя"). woman("Таня"). woman("Маша"). 
