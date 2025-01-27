% Программа преобразует строку цифр в слова
Predicates  
	start(string)  conv(string,integer)
Goal start("0123456789").
Clauses

start(S):- frontstr(1,S,S1,S2),str_int(S1,K),conv(X,K),
	   write(X),nl,start(S2). 
	% База фактов преобразования
conv("ноль",0).conv("один",1).conv("два",2).conv("три",3).conv("четыре",4).
conv("пять",5).conv("шесть",6).conv("семь",7).conv("восемь",8).conv("девять",9).
