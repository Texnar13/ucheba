% Программа собирает в список все объекты фактов с предикатом bn

Domains 
	i=integer 
	l=integer*  %список целых чисел
Database d(l) % база данных, где объектом в факте является список
Predicates   sw bn(i) fb  sp(l)
Goal makewindow(1,1,7,"",0,0,25,80),sw. 
Clauses
sw:- 	assert(d([])), % создаем в памяти факт БД с объектом типа "список" 
	fb. 	% переходим к правилу формирования списка
		% формирование списка c помощью бектрекинга
fb:-bn(N),d(S),sp([N|S]),fail. 
sp(S):-retractall(d(_)),assert(d(S)),write(S," "),readchar(_).
  	% база фактов
bn(1). bn(2). bn(3). bn(4).



