--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 10.1
--  \   \         Application : ISE
--  /   /         Filename : my_test_2.vhw
-- /___/   /\     Timestamp : Wed Apr 20 15:12:42 2022
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: my_test_2
--Device: Xilinx
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY my_test_2 IS
END my_test_2;

ARCHITECTURE testbench_arch OF my_test_2 IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT Seven_Segment_Driver
        PORT (
            CLK : In std_logic;
            CLK_DIV : In std_logic;
            Q : In std_logic_vector (15 DownTo 0);
            RST : In std_logic;
            D : Out std_logic_vector (3 DownTo 0);
            A : Out std_logic_vector (3 DownTo 0)
        );
    END COMPONENT;

    SIGNAL CLK : std_logic := '0';
    SIGNAL CLK_DIV : std_logic := '0';
    SIGNAL Q : std_logic_vector (15 DownTo 0) := "0000000000000000";
    SIGNAL RST : std_logic := '0';
    SIGNAL D : std_logic_vector (3 DownTo 0) := "0000";
    SIGNAL A : std_logic_vector (3 DownTo 0) := "0000";

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : Seven_Segment_Driver
        PORT MAP (
            CLK => CLK,
            CLK_DIV => CLK_DIV,
            Q => Q,
            RST => RST,
            D => D,
            A => A
        );

        PROCESS    -- clock process for CLK
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                CLK <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                CLK <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            BEGIN
                WAIT FOR 100200 ns;

            END PROCESS;

    END testbench_arch;

