% �ணࠬ�� ᮡ�ࠥ� � ᯨ᮪ �� ��ꥪ�� 䠪⮢ � �।���⮬ bn

Domains 
	i=integer 
	l=integer*  %ᯨ᮪ 楫�� �ᥫ
Database d(l) % ���� ������, ��� ��ꥪ⮬ � 䠪� ���� ᯨ᮪
Predicates   sw bn(i) fb  sp(l)
Goal makewindow(1,1,7,"",0,0,25,80),sw. 
Clauses
sw:- 	assert(d([])), % ᮧ���� � ����� 䠪� �� � ��ꥪ⮬ ⨯� "ᯨ᮪" 
	fb. 	% ���室�� � �ࠢ��� �ନ஢���� ᯨ᪠
		% �ନ஢���� ᯨ᪠ c ������� ����४����
fb:-bn(N),d(S),sp([N|S]),fail. 
sp(S):-retractall(d(_)),assert(d(S)),write(S," "),readchar(_).
  	% ���� 䠪⮢
bn(1). bn(2). bn(3). bn(4).



