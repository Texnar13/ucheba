www 
% �࣠������ 横�� � ������� �।���� fail � ��室�� 
% �ᯮ������� �⠭����� �।�⢠ �࣠����樨 ����䥩�
Database     namefile(string) % ��� ��࠭���� ����� ��࠭���� 䠩��
Predicates   start andisk
Goal  start.
Clauses
start:-  makewindow(1,112,94," ����� ��������� ��������� ������ (Esc-��室 ...) ",0,0,25,80),
	 andisk.
andisk:- makewindow(2,45,47,"",1,1,4,78),dir("C:","*.*",Name),
	 assert(namefile(Name)),removewindow,fail.
andisk:- not(namefile(_)),removewindow,exit,!.
andisk:- namefile(Name),concat("����ন��� 䠩�� ",Name,S),
	 makewindow(3,73,27,S,1,1,23,78), file_str(Name,Str),
	 display(Str),retractall(namefile(_)),removewindow,fail.
andisk:- andisk.

