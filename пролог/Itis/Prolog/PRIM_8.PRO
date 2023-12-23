Predicates  
	start  conv(char,string,integer,real)
Goal start.
Clauses
start:-C='A',S="A",I=65,R=3.14,nl,conv(C,S,I,R). 
conv(C,S,I,R):-char_int(C,X),nl,write(X),fail.   %  X=65
conv(C,S,I,R):-char_int(C1,I),nl,write(C1),fail. %  C1=A
conv(C,S,I,R):-str_int(S1,I),nl,write(S1),fail.  %  S1=65
conv(C,S,I,R):-str_char(S,C1),char_int(C1,I1),
		nl,write(I1),fail.  		 %  I1=65
conv(C,S,I,R):-str_real(S1,R),nl,write(S1),fail. %  S1=3.14

