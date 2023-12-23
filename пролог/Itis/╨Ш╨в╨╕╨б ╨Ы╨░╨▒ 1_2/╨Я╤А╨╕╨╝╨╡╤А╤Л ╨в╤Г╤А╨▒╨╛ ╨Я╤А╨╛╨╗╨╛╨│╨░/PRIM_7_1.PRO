% Программа демонстрации разделения списка на голову и хвост

Domains 
        i=integer 
        l=integer* %  список целых чисел
Predicates
split(l)
sw 
Goal makewindow(1,1,7,"",0,0,25,80),sw. 
Clauses

sw:- S=[1,2,3,4,5], % соэдаем список 
	split(S).   % обращаемся к правилу разделения списка

split([N|S]):-write(N," ",S),nl,readchar(_),fail.
split([]):-write("Список пуст").
split([N|W]):-split(W). % организуем цикл с помощью рекурсии

