@echo off
REM ===========================================================================
REM == COMPILE.BAT
REM ===========================================================================

set MODULE=mips_test
set SOURCE=%MODULE%.sv

iverilog -g2012 -o %MODULE%.exe %SOURCE%
