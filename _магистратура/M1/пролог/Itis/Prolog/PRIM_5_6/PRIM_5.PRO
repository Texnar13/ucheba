Domains
  i = integer  s = string 
Database 
	age(s,i)
	woman(s)
	man(s)
 
Predicates	
	start
     	conclusion(s)
			
Goal   start.
Clauses

start:- existfile("facts.bd"),consult("facts.bd"),
	makewindow(1,27,57,"",0,0,25,80),
	write("Введите имя: "),readln(Name),nl,
	conclusion(Name).
start.

conclusion(Name):-woman(Name), retract(age(Name,_)),
		  retract(woman(Name)),save("facts.bd"),
		  write("Данные по объекту ",Name," удалены из базы !"),
		  readchar(_).
conclusion(Name):-not(woman(Name)), 
		write("Объект ",Name," отсутствует в базе !"),readchar(_).

/* содержимое файла "facts.bd"
age("Петя",20)
age("Таня",10)
age("Катя",18)
woman("Таня")
woman("Катя")
man("Петя")
*/



