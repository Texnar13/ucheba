LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY main IS
	PORT (
		CLK: IN std_logic;
		COUNT: IN std_logic;
		RESET: IN std_logic;
		A: OUT std_logic_vector (3 DOWNTO 0);
		LED: OUT std_logic_vector (7 DOWNTO 0)
	);
END main;
ARCHITECTURE Behavioral OF main IS
	COMPONENT Seven_Segment_Driver
	PORT (
		CLK : IN std_logic;
		CLK_DIV : IN std_logic;
		RST : IN std_logic;
		Q : IN std_logic_vector (15 DOWNTO 0);
		D : OUT std_logic_vector (3 DOWNTO 0);
		A : OUT std_logic_vector (3 DOWNTO 0)
	);
	END COMPONENT;
	COMPONENT seven_segment
	PORT (
		data : IN std_logic_vector (3 DOWNTO 0);
		led : OUT std_logic_vector (7 DOWNTO 0)
	);
	END COMPONENT;
	COMPONENT lab2_example
	PORT ( 
		RST : IN std_logic;
		CLK : IN std_logic;
		COUNT : IN std_logic;
		CNT : OUT std_logic
	);
	END COMPONENT;

SIGNAL CNT_int,CNT_ff,CNT_RISE:std_logic;
SIGNAL COUNTER: integer;
SIGNAL COUNTER_OVF: std_logic;
-- Main counter
SIGNAL MAIN_COUNTER: std_logic_vector(15 DOWNTO 0);
SIGNAL D_int : std_logic_vector(3 DOWNTO 0);
BEGIN
	ssd_inst : Seven_Segment_Driver
	PORT MAP (
		CLK => CLK,
		CLK_DIV => COUNTER_OVF,
		Q(15 DOWNTO 0) => MAIN_COUNTER,
		RST => RESET,
		D(3 DOWNTO 0) => D_INT,
		A(3 DOWNTO 0) => A
	);
	led_decode_inst : seven_segment
	PORT MAP (
		data(3 DOWNTO 0) => D_int,
		led(7 DOWNTO 0) => LED
	);
	lab2_example_inst : lab2_example
	PORT MAP (
		CLK => CLK,
		COUNT => COUNT,
		RST => RESET,
		CNT => CNT_int
	);
	-- Описнаие делителя частоты
	COUNTER_inst: PROCESS (CLK)
	BEGIN
		IF (CLK='1' and CLK'event) THEN
			IF (RESET='1' or COUNTER_OVF='1') THEN
				COUNTER <= 0;
			ELSE
				COUNTER <= COUNTER + 1;
			END IF;
		END IF;
	END PROCESS;
	COUNTER_OVF <= '1' WHEN COUNTER = 2**16 ELSE '0';
	--Детектор фронта сигнала CNT
	CNT_RISE <= '1' WHEN CNT_int='1' and CNT_ff='0' ELSE '0';
	CNT_ff_inst: PROCESS (CLK)
	BEGIN
		IF (CLK='1' and CLK'event) THEN
			IF (RESET='1') THEN
				CNT_ff <= '0';
			ELSE
				CNT_ff <= CNT_int;
			END IF;
		END IF;
	END PROCESS;
	--Основной счетчик
	MAIN_COUNTER_inst: PROCESS (CLK)
	BEGIN
		IF (CLK='1' and CLK'event) THEN
			IF (RESET='1') THEN
				MAIN_COUNTER <= (others => '0');
			ELSIF (CNT_RISE = '1') THEN
				MAIN_COUNTER <= MAIN_COUNTER + 1;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIORAL;