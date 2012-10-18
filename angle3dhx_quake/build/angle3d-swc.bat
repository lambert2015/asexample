@echo off
set dir=
IF "%1%"=="" GOTO b ELSE GOTO a

:a
set dir=%1
ECHO output directory is defined (%dir%)
goto:c

:b
set dir=..\swc\
ECHO output directory is not defined. using default (%dir%)
goto:c

:c
set lib=..\src\
mkdir %dir%
haxe angle3d-swc.hxml
ECHO done.
pause