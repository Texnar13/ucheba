LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY control_unit IS
PORT (
	C : IN std_logic_vector (5 DOWNTO 0);
	CLK : IN std_logic; RST : IN std_logic;
	M : OUT std_logic_vector (7 DOWNTO 0) );
END control_unit;
ARCHITECTURE arch_control_unit OF control_unit IS
	TYPE STATE_TYPE IS (s1, s2, s3, s4, s5, s6);
	SIGNAL current_state: STATE_TYPE := s1;
BEGIN
PROCESS (clk, rst)
BEGIN
	IF (rst='1') THEN
		M <= "00000000";
		current_state <= s1;
	ELSIF (CLK'EVENT AND CLK='1') THEN
		CASE current_state IS
		WHEN S1 =>
			M <= "00000100";
			IF (C(0)='1' AND C(1)='1' AND C(2)='1') THEN
				current_state <= S2;
			ELSIF (C(0)='1' AND C(1)='0') THEN
				current_state <= S4;
			ELSE
				current_state <= S1;
			END IF;
		WHEN S2 =>
			M <= "00000001";
			IF (C(4)='1') OR (C(3)='1') THEN
				M <= "01100000";
				current_state <= S3;
			ELSE
				current_state <= S2;
			END IF;
		WHEN S3 =>
			M <= "10000010";
			IF (C(0)='1' AND C(1)='1') THEN
				current_state <= S1;
			ELSIF (C(0)='0') THEN
				M <= "00100000";
				current_state <= S6;
			ELSE
				current_state <= S3;
			END IF;
		WHEN S4 =>
			M <= "01100000";
			IF (C(3)='1' AND C(5)='0') THEN
				M <= "00010000";
				current_state <= S5;
			ELSIF (C(5)='1') THEN
				M <= "10100000";
				current_state <= S3;
			ELSE
				current_state <= S4;
			END IF;
		WHEN S5 =>
			M <= "00001000";
			IF (C(0)='1') OR (C(2)='0') THEN
				M <= "00000100";
				current_state <= S6;
			ELSE
				M <= "11000000";
				current_state <= S5;
			END IF;
		WHEN S6 =>
			M <= "00010000";
			current_state <= S1;
		END CASE;
	END IF;
END PROCESS;
END arch_control_unit;
