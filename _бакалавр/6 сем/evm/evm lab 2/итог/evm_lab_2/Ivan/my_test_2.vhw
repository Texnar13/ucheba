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
-- /___/   /\     Timestamp : Wed Apr 20 15:17:33 2022
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: my_test_2
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY my_test_2 IS
END my_test_2;

ARCHITECTURE testbench_arch OF my_test_2 IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT seven_segment
        PORT (
            data : In std_logic_vector (3 DownTo 0);
            led : Out std_logic_vector (7 DownTo 0)
        );
    END COMPONENT;

    SIGNAL data : std_logic_vector (3 DownTo 0) := "0000";
    SIGNAL led : std_logic_vector (7 DownTo 0) := "00000000";

    BEGIN
        UUT : seven_segment
        PORT MAP (
            data => data,
            led => led
        );

        PROCESS
            BEGIN
                WAIT FOR 100000 ns;

            END PROCESS;

    END testbench_arch;

