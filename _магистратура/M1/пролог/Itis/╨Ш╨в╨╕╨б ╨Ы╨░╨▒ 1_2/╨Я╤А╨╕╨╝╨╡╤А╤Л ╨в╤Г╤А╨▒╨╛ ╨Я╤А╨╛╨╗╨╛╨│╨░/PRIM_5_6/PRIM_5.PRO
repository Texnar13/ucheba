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
	write("������ ���: "),readln(Name),nl,
	conclusion(Name).
start.

conclusion(Name):-woman(Name), retract(age(Name,_)),
		  retract(woman(Name)),save("facts.bd"),
		  write("����� �� ��ꥪ�� ",Name," 㤠���� �� ���� !"),
		  readchar(_).
conclusion(Name):-not(woman(Name)), 
		write("��ꥪ� ",Name," ��������� � ���� !"),readchar(_).

/* ᮤ�ন��� 䠩�� "facts.bd"
age("����",20)
age("����",10)
age("����",18)
woman("����")
woman("����")
man("����")
*/



