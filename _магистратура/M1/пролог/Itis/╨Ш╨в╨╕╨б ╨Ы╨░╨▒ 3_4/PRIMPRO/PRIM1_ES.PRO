Domains
  r = real s = string  c = char
  list=real* %  ᯨ᮪ ����⢥���� �ᥫ
  usp=u(r,list) % ᯨ᮪ �᫮��� �ࠡ��뢠��� �ࠢ�� � ��⮬ �����
  listusp=usp*
   
Database-f    % ���� 䠪⮢ ����䥩᭮�� �����
   w(r,r,s)   % ������ 
   f(r,r,s)  % �������� �⢥�� 

Database-rul    % ���� �����祭��
   rule(r,listusp,list,r) % 䠪�� �����祭�� 
   z(r,s)  
             /* ���� ����  */
Database
   b(s,s) quit % ��� �ᯮ����⥫��� 楫��
   wp_bd(r)    % ��� ����
   f_act(r,r)  % ��� �ନ஢���� ��⨢��� 䠪⮢    
   buff(s)     % ���� �뤥������ ᫮� ��� �ࠧ
   vbuff(s)    % ��� �ନ஢���� ������ ᫮�� ��� ����� �ࠧ�
   r_act(r,r)  % ��⨢�� �ࠢ���
   ok(r,r)     % ��� �஢�ન �� �ࠡ��뢠� �ࠢ���
   f_s(r,r)    % �ࠡ�⠭�� 䠪�� � �ࠢ���
   f_time(r,r)  % ��� �஢�ન �ࠡ�⠭��� �ࠢ��
   old_new(r,r)  % ��� ��室� �� ��� 
   
Predicates
 start 
 readmy(s) interface  rmv % �।����� ����䥩᭮�� �����    
 asbuff(s,s)   % ��� ������⢠ �뤥������ ᫮� ��� �ࠧ
 prob(s,s)     % ��� ��।������ ��譨� �஡���� 
 predprob(s,s) % ��� 㤠����� �஡��� ��। ࠧ����⥫��
 opros  wp(r,r)       % ��� ��ࠡ�⪨ ����᭨��
 d1(s) pr1(s,s) pr12(r) pr2(s) v(c,c)  sumb(s)  % ��� ��ࠡ�⪨ ��ப
 formact asform(s)  % ��� �ନ஢���� ��⨢��� 䠪⮢
      % �।����� ��� �࣠����樨 ��堭���� �뢮��
 repeat  no_iterac   analiz(r,listusp,list,r) 
 kol_u(listusp)    kol(list)
 cross_f(listusp)   cross_u(usp)  cross_r(list)
 pr_fs(r,r)  as_fs kol_r(list,r) kol_rs     
 ud_f_act  ud(r,r) % 㤠�塞 �ࠡ�⠭�� 䠪��
 new_ok(r,r) prov(r,r)
 zak  outzakl           % �뢮� �����祭��
 inform inf_fs inf_rs 
  
  
  Goal start.
       
Clauses

start:-makewindow(1,1,7," �C ��।������ ������� (��室 - Esc... )",0,0,25,80),
       makewindow(2,27,47,"����᫨� �������� �⢥��",5,10,15,59),
       retractall(_),interface. 

interface:-  retractall(_), 		 % 㤠�塞 �� 䠪�� ��饩 ����
	     opros, not(quit),
	         	         /* ��� */
	     formact,    % �ନ஢���� ��⨢��� 䠪⮢
	     assert(old_new(0,0)), % ��砫�� �ࠡ�⠭�� �ࠢ���
	     repeat,     % �맮� ��堭���� �뢮��
	     zak,        % �뢮� १���⮢ ࠡ���
	     fail.

interface:-  quit,cursor(5,10), write("����� ࠡ��� �����襭 ..."),
	     readchar(_),rmv,exit.
interface:- interface.
 
        /*㤠��� �� ���짮��⥫�᪨� ���� */
rmv:- shiftwindow(N),N<=127,removewindow,fail.   
rmv:- shiftwindow(N),N>127. %  max 127- ������祭��, max 34 ����
rmv:-rmv. 

% *************** ����䥩� � ���짮��⥫�� *********************
% *********** ���䮫����᪨� ������ ������⨢�� ��⮤�� ******

% ���� ���� � �ନ஢���� ��⨢��� 䠪⮢ (max 100 ��㯯 ����ᮢ)
% ����� �뢮��� ��� ��������� ����

opros:-not(wp_bd(_)),assert(wp_bd(1)),fail.
opros:- not(quit),  % �᫨ �� Esc, � ࠡ�⠥� ����� 
        wp_bd(G),wp(G,1),    
	retractall(wp_bd(_)),G<100,G1=G+1,assert(wp_bd(G1)),fail.     
opros:-wp_bd(G),G=100,not(quit),!.
opros:-quit,!.
opros:-opros.

wp(K,N):-W(K,N,W),not(quit),makewindow(3,91,27,W,10,14,4,50), d1(S),N1=N+1,
         removewindow,wp(K,N1),!.
wp(K,N):-quit,removewindow,!.
wp(K,N).

% �����頥� ��ࠡ�⠭��� ��ப� (�㪢� ��᫥ ��ࠡ�⪨ ⮫쪮 �����)

d1(S):- readmy(Sv), pr1(Sv,S), pr2(S),!.

readmy(S):-  readln(S),!.
readmy(S):-  S="",not(quit),assert(quit),fail. % �᫨ Esc

% ��ࠡ�⪠ �室��� ��ப� 
pr1(Sv,S1):- str_len(Sv,L),retractall(b(_,_)),
	     assert(b(Sv,"")),pr12(L),b(_,S1),!.
pr12(L):- b(S,H),L<>0,frontchar(S,C,So),v(C2,C),
          str_char(Sc,C2),concat(H,Sc,H1),
          retractall(b(_,_)),L1=L-1,assert(b(So,H1)),pr12(L1).
pr12(L):-L=0,!.
pr12(L):-pr12(L).

% �ନ�㥬 ���� 䠪⮢ �뤥������ ᫮� ��� �ࠧ
pr2(S):-S<>"",frontstr(1,S,S1,S2),asbuff(S1,S2),pr2(S2).
pr2(S).

% �ନ�㥬 � vbuff �ࠧ� ��� ᫮�� � ��ࠢ�塞 � buff
% �� �⮬ ��譨� �஡��� �ய�᪠��

asbuff(S1,S2):-not(vbuff(_)),assert(vbuff("")),fail.
asbuff(S1,S2):-not(sumb(S1)),vbuff(S),prob(S1,S2),concat(S,S1,Sz),
	       retractall(vbuff(_)),assert(vbuff(Sz)),fail.
asbuff(S1,S2):-not(sumb(S1)),S2<>"",!.
asbuff(S1,S2):-vbuff(Sn), predprob(Sn,S),
	       retractall(vbuff(_)),assert(buff(S)),!.
% �᫨ ࠧ����⥫�, � �।��騩 �஡��, � 㤠�塞 ��� �஡��
predprob(Sn,S):- str_len(Sn,L),L1=L-1,frontstr(L1,Sn,Ss,Sz),Sz=" ",S=Ss,!.
predprob(Sn,S):- S=Sn,!.
		
% 㧭��� �� ��譨� �஡�� ��� ���
prob(S1,S2):-S1<>" ",!. 
prob(S1,S2):-S1=" ",vbuff(S),S<>"",str_len(S,L),L1=L-1,
		frontstr(L1,S,Sn,Sz),Sz<>" ",!. 
prob(S1,S2):-S2="".  

sumb(",").sumb(".").sumb(";").    % ࠧ����⥫� ᫮� ��� �ࠧ


 %*************** ��ନ஢����  ��⨢��� 䠪⮢ *****************

formact:-buff(A), asform(A),fail.
formact.	 
 		% ����砥� ����� ��⨢��� 䠪⮢ 
asform(A):-f(W,N,A), not(f_act(W,N)),assert(f_act(W,N)),!.

/***** ���� �ࠢ��  (��楤��� ������) ************/
/* (��ॡ�ࠥ� �� �����祭�� � ��������㥬,
    ����砥� �����祭�� �ࠡ�⠭��� �ࠢ�� fact_rule)*/

repeat:-rule(N,Split_f,Split_rule,Zakl),analiz(N,Split_f,Split_rule,Zakl),fail.
repeat:-kol_rs,no_iterac,!.  % �᫨ �� �㦭� ������ �� �����, � ��室��
repeat:-repeat.

no_iterac:-old_new(S,N),S=N,retractall(old_new(_,_)),assert(old_new(0,0)),!.
no_iterac:-old_new(S,N),S<>N,retractall(old_new(_,_)),assert(old_new(N,0)),fail.

kol_rs:- r_act(P,_),old_new(S,N),N1=N+1,retractall(old_new(_,_)),
		assert(old_new(S,N1)),fail.
kol_rs.

% ��������㥬 �� �ࠡ��뢠��� �����祭��

analiz(N,S_u,S_r,Z):-   retractall(f_time(_,_)), 
    new_ok(0,0), kol_u(S_u),    % ������ ᯨ᪠ �᫮��� 
    cross_f(S_u), ok(Fu,Fa),  Fu=Fa,  as_fs,
    new_ok(0,0),  kol_r(S_r,0),
    cross_r(S_r), ok(R,Rs),   R=Rs,  % ������ �ࠡ�⠭��� �ࠢ��
    prov(Fu,Rs),    % ᮢ���⭠� �஢�ઠ
    % ud_f_act,      % 㤠�塞 �ࠡ�⠭�� 䠪��
    not(r_act(N,_)), assert(r_act(N,Z)),!. 
         
prov(X,Y):-X>0,Y=0; X=0,Y>0; X>0,Y>0.

as_fs:-f_time(W,A),not(f_s(W,A)),assert(f_s(W,A)),fail.
as_fs.

kol_u(S):-S=[],!.
kol_u([u(W,A)|B]):- not(A=[]), kol(A), kol_u(B),!.
kol([A|B]):-A>=0,ok(N,_),N1=N+1,new_ok(N1,0),kol(B),!.
kol(S):-!.

kol_r([A|B],N):-A>=0,N1=N+1,new_ok(N1,0),kol_r(B,N1).
kol_r(S,N).

  % ������ �� ����祭�� 䠪⮢

cross_f(S):-S=[],!.% �᫨ �᫮��� ���, � ��室�� 
cross_f([A|B]):-  cross_u(A), cross_f(B).   %  �⡨ࠥ� u(W,[u1,...])
                
cross_u(u(W,[A|B])):- f_act(W,A), pr_fs(W,A), cross_u(u(W,B)).
cross_u(S):-!.

pr_fs(W,A):- not(f_time(W,A)), assert(f_time(W,A)),
	     ok(N,K),K1=K+1, new_ok(N,K1),!. 
pr_fs(W,A).

cross_r(S):-S=[],!. % ������ �ࠡ�⠭��� �ࠢ��
cross_r([A|B]):-A>=0,r_act(A,Z),ok(N,K),K1=K+1,new_ok(N,K1),cross_r(B).

ud_f_act:-f_s(W,F),ud(W,F),fail. % 㤠�塞 �ࠡ�⠭�� 䠪��
ud_f_act.

ud(W,F):-f_act(W,F),retractall(f_act(W,F)),!.

new_ok(A,B):-retractall(ok(_,_)),assert(ok(A,B)).


% �뢮� ��ନ஢����� �����祭��

zak:-r_act(_,_), % �᫨ ���� �����祭��, � �뢮���
     makewindow(4,32,47," �������� ࠡ��� ��� ! ",3,4,17,70),
     outzakl,readchar(_),removewindow,inform,!.  
zak:-not(r_act(_,_)), % �᫨ ��� �����祭��
     makewindow(4,32,47," ��ᨬ ��饭�� ! ",3,4,17,70),
     cursor(5,10),write("��㤭� ��-����� �뢥�� �� ����� 䠪⠬!"),   
     readchar(_),removewindow,!.  

outzakl:-r_act(N,Z),z(Z,S),write("�� ",S,".  (�ࠡ�⠫� �ࠢ��� ",N,")"),
         nl,fail.
outzakl.

inform:-r_act(_,_),
        makewindow(4,20,30,"",0,0,25,80),write("�ࠡ�⠭�� 䠪��: "),nl,
	inf_fs,	write("�ࠡ�⠭�� �ࠢ���: "),nl,
	inf_rs, readchar(_),removewindow,!.
inform.

inf_fs:- f_s(W,F),write(W,"-",F,"   "),nl,fail.	inf_fs.	
inf_rs:- r_act(R,_),write(R,"  "),nl,fail.	inf_rs.	

% ����᭨� ࠧ�������� �� ��㯯��
W(1,1,"�� ����� ?").
W(1,2,"�� ���� ?").
W(1,3,"��� ��⠥��� ?").
W(1,4,"��� ��६�頥��� ?").
W(2,1,"�� �������⥫쭮 ����� �������� ?").

% ���� 䠪⮢ ����䥩� � ���짮��⥫�� (������⨢�� ������)
f(1,1,"������").
f(1,2,"�����").
f(1,3,"���").   f(1,3,"����� ���"). f(1,3,"��� �����").
f(1,4,"����").  f(1,4,"����訥 ����").
f(1,5,"����� ᯥ।�"). f(1,5,"���। ᬮ���騥 �����").
f(1,6,"����").
f(1,7,"�����").

f(2,1,"������").
f(2,2,"��").

f(3,1,"���").
f(3,2,"��� �����"). f(3,2,"�ࠢ�"). f(3,2,"��⥭��").
f(3,3,"�론").
f(3,4,"����").
f(3,5,"�����").
f(3,6,"祬 㣮���").f(3,6,"�ᥬ").f(3,6,"�� ���������").

f(4,1,"��⠥�").
f(4,2,"�������").
f(4,3,"室��"). 
f(4,4,"������"). f(4,4,"����� ������"). f(4,4,"������ �����").
 
f(5,1,"�릥���-���筥��").
f(5,2,"⥬�� ��⭠").  f(5,2,"��⭠ ⥬��").
f(5,3,"��� ������"). f(5,3,"������ ���").
f(5,4,"������ ����").  f(5,4,"���� ������").
f(5,5,"������� ��").   f(5,5,"�� �������").
f(5,6,"�� ��⠥�").  
f(5,7,"�୮� � ����").  f(5,7,"����� � ���").
f(5,8,"�������").  
f(5,9,"��� ��⠥�").  f(5,9,"��⠥� ���").

/***************** ���� 䠪⮢ �����祭�� ******************************
 rule(N �ࠢ���, ᯨ᪨ ����஢ 䠪⮢ � �ࠡ��뢠���� �ࠢ��,�����祭��) */
% ��㯯� �ࠢ�� ॠ����� '���'  


rule(1,[u(1,[1])],[],1).
rule(1,[u(2,[1])],[],1).
rule(1,[u(1,[1]),u(2,[1])],[],1).

rule(2,[u(3,[1])],[],2).
rule(2,[u(3,[3])],[],2).
rule(2,[u(1,[3,4,5])],[],2).
rule(2,[u(1,[3,4,5]),u(2,[1])],[],2).
rule(2,[u(1,[3,4,5]),u(2,[3])],[],2).

rule(3,[u(3,[2])],[1],3).
rule(3,[u(1,[2])],[1],3).

rule(4,[u(2,[2]),u(4,[1])],[],4).
rule(4,[u(1,[7])],[],4).

rule(5,[u(5,[1,2])],[1,2],5).
rule(6,[u(5,[1,3])],[1,2],6).
rule(7,[u(5,[2,4,5])],[3],7).
rule(8,[u(5,[3])],[3,1],8).
rule(9,[u(5,[5,6,7])],[4],9).
rule(10,[u(5,[6,7,8])],[4],10).
rule(11,[u(5,[9])],[4],11).

z(1,"���������饥").
z(2,"��魨�").
z(3,"����⭮�").
z(4,"���").
z(5,"�����ﭠ").
z(6,"����").
z(7,"����").
z(8,"����").
z(9,"�����").
z(10,"�������").
z(11,"��졠���").

% ��� �८�ࠧ������ �室��� ��ப� �� ���᪨� �㪢
v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').
v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').
v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').
v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').
v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').v('�','�').
v('�','�').v('�','�').
v(C,C2):-C=C2,!.             

