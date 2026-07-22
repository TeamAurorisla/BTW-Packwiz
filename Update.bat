@echo off
:loop

if exist ".\mods\*.pw.toml" (
    del ".\mods\*.pw.toml"
)
if exist ".\resourcepacks\*.pw.toml" (
    del ".\resourcepacks\*.pw.toml"
)

xcopy .\mods\.index\*.pw.toml .\mods\ /Y
xcopy .\resourcepacks\.index\*.pw.toml .\resourcepacks\ /Y

pause
goto loop