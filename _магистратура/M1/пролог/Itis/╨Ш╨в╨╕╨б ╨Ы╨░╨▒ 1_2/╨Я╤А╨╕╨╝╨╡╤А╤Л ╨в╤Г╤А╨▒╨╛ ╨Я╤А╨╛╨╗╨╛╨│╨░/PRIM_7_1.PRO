% �ணࠬ�� ��������樨 ࠧ������� ᯨ᪠ �� ������ � 墮��

Domains 
        i=integer 
        l=integer* %  ᯨ᮪ 楫�� �ᥫ
Predicates
split(l)
sw 
Goal makewindow(1,1,7,"",0,0,25,80),sw. 
Clauses

sw:- S=[1,2,3,4,5], % ������ ᯨ᮪ 
	split(S).   % ���頥��� � �ࠢ��� ࠧ������� ᯨ᪠

split([N|S]):-write(N," ",S),nl,readchar(_),fail.
split([]):-write("���᮪ ����").
split([N|W]):-split(W). % �࣠���㥬 横� � ������� ४��ᨨ

