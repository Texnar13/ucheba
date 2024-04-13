--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 10.1
--  \   \         Application : ISE
--  /   /         Filename : my_test.vhw
-- /___/   /\     Timestamp : Wed Apr 20 12:23:32 2022
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: my_test
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library ieee;
use ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY my_test IS
END my_test;

ARCHITECTURE testbench_arch OF my_test IS
    COMPONENT lab2_example
        PORT (
            RST : In std_logic;
            CLK : In std_logic;
            COUNT : In std_logic;
            CNT : Out std_logic
        );
    END COMPONENT;

    SIGNAL RST : std_logic := '0';
    SIGNAL CLK : std_logic := '0';
    SIGNAL COUNT : std_logic := '0';
    SIGNAL CNT : std_logic := '0';

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : lab2_example
        PORT MAP (
            RST => RST,
            CLK => CLK,
            COUNT => COUNT,
            CNT => CNT
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
                -- -------------  Current Time:  100ns
                WAIT FOR 100 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  10185ns
                WAIT FOR 10085 ns;
                RST <= '1';
                -- -------------------------------------
                WAIT FOR 90015 ns;

            END PROCESS;

    END testbench_arch;

