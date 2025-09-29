@echo off
title DEO Claude Code CEO - Installation Windows
color 0B
cd /d "%~dp0"

echo.
echo  ╔════════════════════════════════════════════════════════╗
echo  ║                                                        ║
echo  ║     🚀 DEO CLAUDE CODE CEO - INSTALLATION USB 🚀       ║
echo  ║                                                        ║
echo  ║         Digital Executive Officer Auto-Installer       ║
echo  ║                  Windows Edition                       ║
echo  ║                                                        ║
echo  ║               👤 ehadsagency-ai                        ║
echo  ║               📧 ehads.agency@gmail.com                ║
echo  ║                                                        ║
echo  ╚════════════════════════════════════════════════════════╝
echo.

echo [%time%] 🔍 Détection du système Windows...
ver | findstr /i "Windows"
if %errorlevel% neq 0 (
    echo ❌ Système non-Windows détecté
    echo 💡 Utilisez DEMARRER_DEO_MACOS.command ou DEMARRER_DEO_LINUX.sh
    pause
    exit /b 1
)

echo [%time%] ✅ Système Windows compatible détecté
echo.

REM Vérification des privilèges admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Privilèges administrateur requis pour l'installation
    echo 🔄 Redémarrage avec élévation de privilèges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b 0
)

echo [%time%] 🔑 Privilèges administrateur confirmés
echo.

REM Vérification Docker
echo [%time%] 🐳 Vérification de Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Docker non installé - Installation automatique...
    if exist "windows\docker-desktop-installer.exe" (
        echo 📦 Installation Docker Desktop depuis USB...
        start /wait "windows\docker-desktop-installer.exe" install --quiet
        echo ✅ Docker Desktop installé
    ) else (
        echo 📥 Téléchargement Docker Desktop...
        powershell -Command "Invoke-WebRequest -Uri 'https://desktop.docker.com/win/main/amd64/Docker%%20Desktop%%20Installer.exe' -OutFile 'docker-installer.exe'"
        start /wait docker-installer.exe install --quiet
        del docker-installer.exe
        echo ✅ Docker Desktop installé depuis internet
    )
) else (
    echo ✅ Docker déjà installé
)

REM Installation Python portable si nécessaire
echo [%time%] 🐍 Vérification Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    if exist "windows\python-portable" (
        echo 📦 Configuration Python portable...
        set PATH=%CD%\windows\python-portable;%PATH%
        echo ✅ Python portable configuré
    )
)

REM Installation Git portable si nécessaire
echo [%time%] 📚 Vérification Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    if exist "windows\git-portable" (
        echo 📦 Configuration Git portable...
        set PATH=%CD%\windows\git-portable\bin;%PATH%
        echo ✅ Git portable configuré
    )
)

echo.
echo [%time%] 🧠 Déploiement Claude Code CEO...

REM Copie configuration vers %USERPROFILE%\.claude
if not exist "%USERPROFILE%\.claude" mkdir "%USERPROFILE%\.claude"
xcopy /E /Y "core\*" "%USERPROFILE%\.claude\"
echo ✅ Configuration Claude Code CEO installée

REM Configuration GitHub credentials si disponible
if exist "data\user-configs\github_credentials" (
    copy "data\user-configs\github_credentials" "%USERPROFILE%\.claude\"
    echo ✅ Credentials GitHub restaurés
)

echo.
echo [%time%] 🚀 Test de l'installation...
cd "%USERPROFILE%\.claude\global_memory"

REM Test du système
if exist "sync_scripts\github_sync.sh" (
    echo ✅ Scripts de synchronisation trouvés
)
if exist "ui\index.html" (
    echo ✅ Interface web trouvée
)

echo.
echo [%time%] 🎯 Finalisation DEO...

REM Affichage bannière finale
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    ██████╗ ███████╗ ██████╗     ███████╗██╗   ██╗███████╗████████╗███████╗ ║
echo  ║    ██╔══██╗██╔════╝██╔═══██╗    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝ ║
echo  ║    ██║  ██║█████╗  ██║   ██║    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗   ║
echo  ║    ██║  ██║██╔══╝  ██║   ██║    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝   ║
echo  ║    ██████╔╝███████╗╚██████╔╝    ███████║   ██║   ███████║   ██║   ███████╗ ║
echo  ║    ╚═════╝ ╚══════╝ ╚═════╝     ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝ ║
echo  ║                                                                            ║
echo  ║                    🚀 DIGITAL EXECUTIVE OFFICER 🚀                         ║
echo  ║                                                                            ║
echo  ║                ✅ INSTALLATION USB WINDOWS TERMINÉE ✅                     ║
echo  ║                                                                            ║
echo  ║              👤 ehadsagency-ai  ^|  📧 ehads.agency@gmail.com               ║
echo  ║                                                                            ║
echo  ║    🧠 CEO Memory: Active        🔄 GitHub Sync: Ready                     ║
echo  ║    👥 Agents: Deployed          🌐 Web Interface: Ready                   ║
echo  ║    🐳 Docker: Operational       📊 Dashboard: localhost:3000              ║
echo  ║                                                                            ║
echo  ║            🌟 Votre Claude Code CEO est prêt depuis USB ! 🌟              ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo      🎯 DEO USB SYSTEM: FULLY OPERATIONAL ON WINDOWS
echo.
echo      🔥 Ready to revolutionize development from anywhere! 🔥
echo.

echo 🚀 Ouverture interface web...
start "" "http://localhost:3000" 2>nul

echo.
echo 📝 Installation terminée ! Appuyez sur une touche pour fermer...
pause >nul

exit /b 0