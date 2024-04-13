LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY seven_segment IS
	PORT (
		data: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		led: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END seven_segment;
ARCHITECTURE Behavioral OF seven_segment IS
BEGIN
PROCESS (data)
	BEGIN
		CASE data IS
			WHEN "0000" => led <= "10000001";
			WHEN "0001" => led <= "11001111";
			WHEN "0010" => led <= "10010010";
			WHEN "0011" => led <= "10000110";
			WHEN "0100" => led <= "11001100";
			WHEN "0101" => led <= "10100100";
			WHEN "0110" => led <= "10100000";
			WHEN "0111" => led <= "10001111";
			WHEN "1000" => led <= "10000000";
			WHEN "1001" => led <= "10000100";
			WHEN "1010" => led <= "10001000";
			WHEN "1011" => led <= "11100000";
			WHEN "1100" => led <= "10110001";
			WHEN "1101" => led <= "11000010";
			WHEN "1110" => led <= "10110000";
			WHEN "1111" => led <= "10111000";
			WHEN OTHERS => NULL;
		END CASE;
	END PROCESS;
END Behavioral;