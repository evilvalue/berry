@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Neo Server Pack

set "PACK_URL=https://evilvalue.github.io/berry/pack.toml"
set "INSTANCE_URL=https://evilvalue.github.io/berry/launcher/instance.zip"
set "INSTANCE=Neo Server Pack"
set "BASE=%APPDATA%\PrismLauncher"
set "INST_DIR=%BASE%\instances\%INSTANCE%"
set "TMPZIP=%TEMP%\neo-server-pack-instance.zip"

echo ============================================
echo   Neo Server Pack - 135.181.126.167:25737
echo ============================================
echo.

rem ---------- 1. найти Prism Launcher ----------
set "PRISM="
for %%P in (
  "%LOCALAPPDATA%\Programs\PrismLauncher\prismlauncher.exe"
  "%ProgramFiles%\PrismLauncher\prismlauncher.exe"
  "%ProgramFiles(x86)%\PrismLauncher\prismlauncher.exe"
  "%ProgramW6432%\PrismLauncher\prismlauncher.exe"
) do (
  if not defined PRISM if exist %%P set "PRISM=%%~P"
)
if not defined PRISM (
  echo [!] Prism Launcher не найден.
  echo     Скачай и установи: https://prismlauncher.org/download/windows/
  echo     Потом запусти этот файл снова.
  echo.
  pause
  exit /b 1
)
echo [+] Prism Launcher: %PRISM%

rem ---------- 2. поставить инстанс, если его нет ----------
if exist "%INST_DIR%\instance.cfg" goto :have_instance

echo [*] Первая установка: скачиваю сборку...
if exist "%TMPZIP%" del /q "%TMPZIP%"
where curl.exe >nul 2>&1
if errorlevel 1 (
  powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing '%INSTANCE_URL%' -OutFile '%TMPZIP%' } catch { exit 1 }"
) else (
  curl.exe -sSL -o "%TMPZIP%" "%INSTANCE_URL%"
)
if not exist "%TMPZIP%" (
  echo [!] Не удалось скачать сборку. Проверь интернет и запусти снова.
  pause
  exit /b 1
)

echo [*] Ставлю инстанс в Prism Launcher...
if not exist "%BASE%\instances" mkdir "%BASE%\instances"
if not exist "%INST_DIR%" mkdir "%INST_DIR%"
powershell -NoProfile -Command "Expand-Archive -LiteralPath '%TMPZIP%' -DestinationPath '%INST_DIR%' -Force"
if not exist "%INST_DIR%\instance.cfg" (
  echo [!] Не удалось распаковать сборку.
  echo     Проверь папку: %INST_DIR%
  pause
  exit /b 1
)
del /q "%TMPZIP%" >nul 2>&1
echo [+] Инстанс установлен.
goto :sync

:have_instance
echo [+] Инстанс уже установлен.

rem ---------- 3. синхронизация сборки ----------
:sync
set "JAVA="
for /d %%D in ("%BASE%\java\java-runtime-*") do (
  if not defined JAVA if exist "%%D\bin\java.exe" set "JAVA=%%D\bin\java.exe"
)
if not defined JAVA (
  where java >nul 2>&1
  if not errorlevel 1 set "JAVA=java"
)
if not defined JAVA (
  echo [i] Java не найдена - обновление сделает Prism при запуске игры.
  goto :launch
)

echo.
echo [*] Проверяю обновления сборки...
pushd "%INST_DIR%\minecraft"
"%JAVA%" -jar packwiz-installer-bootstrap.jar -g "%PACK_URL%"
set "SYNC_RC=!errorlevel!"
popd
if not "!SYNC_RC!"=="0" (
  echo.
  echo [!] Синхронизация не удалась ^(код !SYNC_RC!^).
  echo     Проверь интернет или адрес: %PACK_URL%
  echo     Можно всё равно запустить игру - Prism попробует ещё раз.
  echo.
  pause
)

:launch
if /i "%~1"=="check" (
  echo [i] Режим проверки: игру не запускаю.
  exit /b 0
)
echo.
echo [*] Запускаю игру...
start "" "%PRISM%" --launch "%INSTANCE%"
exit /b 0
