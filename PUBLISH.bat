@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Neo Server Pack - публикация обновлений

set "PAGES=https://evilvalue.github.io/berry/pack.toml"
set "PACKWIZ=packwiz"
where packwiz >nul 2>&1
if errorlevel 1 set "PACKWIZ=%USERPROFILE%\go\bin\packwiz.exe"
if not exist "%PACKWIZ%" if "%PACKWIZ%"=="packwiz" set "PACKWIZ="

:menu
echo.
echo ==================================================
echo   Neo Server Pack - публикация обновлений
echo ==================================================
echo   1. Добавить моды из папки new-mods и опубликовать
echo   2. Обновить все моды до свежих версий и опубликовать
echo   3. Опубликовать то, что уже изменено (refresh + push)
echo   4. Открыть папку new-mods
echo   5. Проверить, что сайт отдаёт пак
echo   0. Выход
echo.
choice /c 123450 /n /m "Выбор: "
if errorlevel 6 goto :eof
if errorlevel 5 goto :status
if errorlevel 4 goto :openfolder
if errorlevel 3 goto :publish
if errorlevel 2 goto :updateall
if errorlevel 1 goto :addmods

:addmods
if not exist "new-mods" mkdir "new-mods"
set "FOUND=0"
for %%F in ("new-mods\*.jar") do (
  copy /y "%%F" "mods\" >nul
  echo   + %%~nxF
  set "FOUND=1"
)
if "!FOUND!"=="0" (
  echo.
  echo В папке new-mods нет .jar файлов.
  echo Положи туда новые моды и запусти снова.
  echo.
  pause
  goto :menu
)
set "MSG=add mods"
goto :publish

:updateall
if not defined PACKWIZ (
  echo packwiz не найден. Установи: go install github.com/packwiz/packwiz@latest
  pause
  goto :menu
)
echo [*] Обновляю все моды Modrinth до свежих версий...
"%PACKWIZ%" update --all
set "MSG=update mods"
goto :publish

:publish
if not defined PACKWIZ (
  echo packwiz не найден. Установи: go install github.com/packwiz/packwiz@latest
  pause
  goto :menu
)
echo [*] Пересчитываю index.toml...
"%PACKWIZ%" refresh
echo.
echo [*] Коммит и пуш...
git add -A
git -c user.name="neopack" -c user.email="neopack@local" commit -m "%MSG%"
git push
echo.
echo [+] Отправлено. GitHub Pages пересоберёт пак за ~1 минуту.
echo     Проверить можно так: https://evilvalue.github.io/berry/pack.toml
echo     (в браузере должен открыться текст pack.toml)
echo.
pause
goto :menu

:openfolder
if not exist "new-mods" mkdir "new-mods"
start "" explorer "new-mods"
goto :menu

:status
echo [*] Проверяю %PAGES% ...
powershell -NoProfile -Command "try { $r = Invoke-WebRequest -UseBasicParsing '%PAGES%' -TimeoutSec 20; Write-Host ('[+] HTTP ' + $r.StatusCode + ', ' + $r.Content.Length + ' bytes') } catch { Write-Host '[!] Сайт не отвечает: ' $_.Exception.Message }"
echo.
pause
goto :menu
