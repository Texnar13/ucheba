LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
ENTITY Seven_Segment_Driver IS
	PORT(
		CLK : IN std_logic;
		CLK_DIV : IN std_logic;
		Q : IN std_logic_vector(15 DOWNTO 0);
		RST : IN std_logic;
		D : OUT std_logic_vector(3 DOWNTO 0);
		A : OUT std_logic_vector(3 DOWNTO 0)
	);
END ENTITY Seven_Segment_Driver;
ARCHITECTURE Struct OF Seven_Segment_Driver IS
--Internal Anode
 SIGNAL A_int : std_logic_vector(3 DOWNTO 0);
BEGIN
--Output Anode
A <= A_int;
A_drive: PROCESS (CLK,RST)
BEGIN
	IF (RST = '1') THEN
		A_int<="1110";
	ELSIF (CLK'EVENT AND CLK='1') THEN
		IF (CLK_DIV='1') THEN
			A_int(3)<=A_int(2);
			A_int(2)<=A_int(1);
			A_int(1)<=A_int(0);
			A_int(0)<=A_int(3);
		END IF;
	END IF;
END PROCESS A_drive;
D(0) <= (Q(0) AND NOT(A_int(0)))
	OR (Q(4) AND NOT(A_int(1)))
	OR (Q(8) AND NOT(A_int(2)))
	OR (Q(12) AND NOT(A_int(3)));
D(1) <= (Q(1) AND NOT(A_int(0)))
	OR (Q(5) AND NOT(A_int(1)))
	OR (Q(9) AND NOT(A_int(2)))
	OR (Q(13) AND NOT(A_int(3)));
D(2) <= (Q(2) AND NOT(A_int(0)))
	OR (Q(6) AND NOT(A_int(1)))
	OR (Q(10) AND NOT(A_int(2)))
	OR (Q(14) AND NOT(A_int(3)));
D(3) <= (Q(3) AND NOT(A_int(0)))
	OR (Q(7) AND NOT(A_int(1)))
	OR (Q(11) AND NOT(A_int(2)))
	OR (Q(15) AND NOT(A_int(3)));
END ARCHITECTURE Struct;