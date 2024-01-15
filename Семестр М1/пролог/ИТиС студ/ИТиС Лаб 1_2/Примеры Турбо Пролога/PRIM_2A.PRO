% Использование рекурсии для вычиления значения факториала
Domains r=real 
Predicates  start  calculate(r,r,r)
Goal start.
Clauses
start:- write("Введите положительное целое число: "),readint(X),calculate(X,1,1). 
calculate(X,Y,Z) :- X>Y,Y1=Y+1,Z1=Z*Y1,calculate(X,Y1,Z1). 
calculate(X,Y,Z) :- X=Y,write(X,"!=",Z). 
calculate(X,Y,Z) :- X<Y,write(X,"!=1").   
 
