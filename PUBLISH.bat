@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title BerryTrip (BerryUp) - publikaciya obnovleniy

set "PAGES=https://evilvalue.github.io/berry/pack.toml"
set "PACKWIZ="
where packwiz >nul 2>&1
if not errorlevel 1 set "PACKWIZ=packwiz"
if not defined PACKWIZ if exist "%USERPROFILE%\go\bin\packwiz.exe" set "PACKWIZ=%USERPROFILE%\go\bin\packwiz.exe"
if not defined PACKWIZ if exist "%LOCALAPPDATA%\Programs\Go\bin\packwiz.exe" set "PACKWIZ=%LOCALAPPDATA%\Programs\Go\bin\packwiz.exe"
if not defined PACKWIZ if exist "C:\Program Files\Go\bin\packwiz.exe" set "PACKWIZ=C:\Program Files\Go\bin\packwiz.exe"

if /i "%~1"=="addmods" set "NO_PAUSE=1" & goto :addmods
if /i "%~1"=="update"  set "NO_PAUSE=1" & goto :updateall
if /i "%~1"=="publish" set "NO_PAUSE=1" & goto :publish
if /i "%~1"=="status"  set "NO_PAUSE=1" & goto :status

:menu
echo.
echo ==================================================
echo   BerryTrip - публикация обновлений
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
  echo В папке new-mods нет .jar файлов. Положи туда новые моды и запусти снова.
  echo.
  if not defined NO_PAUSE pause
  if defined NO_PAUSE exit /b 0
  goto :menu
)
set "MSG=add mods"
goto :publish

:updateall
if not defined PACKWIZ goto :no_packwiz
echo [*] Обновляю все моды Modrinth до свежих версий...
"%PACKWIZ%" update --all
set "MSG=update mods"
goto :publish

:publish
if not defined MSG set "MSG=pack update %DATE% %TIME%"
if not defined PACKWIZ goto :no_packwiz
echo [*] Пересчитываю index.toml...
"%PACKWIZ%" refresh
echo.
echo [*] Коммит и пуш...
git add -A
git diff --cached --quiet
if not errorlevel 1 (
  echo [i] Изменений нет - публиковать нечего.
  if not defined NO_PAUSE pause
  if defined NO_PAUSE goto :eof
  goto :menu
)
git -c user.name="neopack" -c user.email="neopack@local" commit -m "%MSG%"
git push
echo.
echo [+] Отправлено. GitHub Pages пересоберёт пак за ~1 минуту.
echo     Проверка: https://evilvalue.github.io/berry/pack.toml
echo     (в браузере должен открыться текст pack.toml)
echo.
if not defined NO_PAUSE pause
if defined NO_PAUSE goto :eof
goto :menu

:openfolder
if not exist "new-mods" mkdir "new-mods"
start "" explorer "new-mods"
goto :menu

:status
echo [*] Проверяю %PAGES% ...
powershell -NoProfile -Command "try { $r = Invoke-WebRequest -UseBasicParsing '%PAGES%' -TimeoutSec 20; Write-Host ('[+] HTTP ' + $r.StatusCode + ', ' + $r.Content.Length + ' bytes') } catch { Write-Host ('[!] Сайт не отвечает: ' + $_.Exception.Message) }"
echo.
if not defined NO_PAUSE pause
if defined NO_PAUSE goto :eof
goto :menu

:no_packwiz
echo.
echo [!] packwiz не найден. Установи его: go install github.com/packwiz/packwiz@latest
echo     или положи packwiz.exe в C:\Users\<ты>\go\bin
echo.
if not defined NO_PAUSE pause
if defined NO_PAUSE goto :eof
goto :menu
