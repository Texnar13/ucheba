--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 10.1
--  \   \         Application : ISE
--  /   /         Filename : lab2.vhw
-- /___/   /\     Timestamp : Wed Mar 23 16:46:27 2022
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: lab2
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library ieee;
use ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY lab2 IS
END lab2;

ARCHITECTURE testbench_arch OF lab2 IS
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
                -- -------------  Current Time:  185ns
                WAIT FOR 185 ns;
                RST <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  5985ns
                WAIT FOR 5800 ns;
                RST <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  26985ns
                WAIT FOR 21000 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  27185ns
                WAIT FOR 200 ns;
                COUNT <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  27385ns
                WAIT FOR 200 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  27985ns
                WAIT FOR 600 ns;
                COUNT <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  28185ns
                WAIT FOR 200 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  28385ns
                WAIT FOR 200 ns;
                COUNT <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  29185ns
                WAIT FOR 800 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  33985ns
                WAIT FOR 4800 ns;
                COUNT <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  34385ns
                WAIT FOR 400 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  34585ns
                WAIT FOR 200 ns;
                COUNT <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  34985ns
                WAIT FOR 400 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  35185ns
                WAIT FOR 200 ns;
                COUNT <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  35585ns
                WAIT FOR 400 ns;
                COUNT <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  35785ns
                WAIT FOR 200 ns;
                COUNT <= '0';
                -- -------------------------------------
                WAIT FOR 64415 ns;

            END PROCESS;

    END testbench_arch;

