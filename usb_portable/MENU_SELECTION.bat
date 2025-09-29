@echo off
title DEO Smart USB - Sélection de Mode
color 0B
cd /d "%~dp0"

:menu
cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    🚀 DEO SMART USB - MODE SELECTION 🚀                                   ║
echo  ║                                                                            ║
echo  ║                    Digital Executive Officer                               ║
echo  ║                      Clé USB Intelligente                                 ║
echo  ║                                                                            ║
echo  ║              👤 ehadsagency-ai  ^|  📧 ehads.agency@gmail.com               ║
echo  ║                                                                            ║
echo  ╠════════════════════════════════════════════════════════════════════════════╣
echo  ║                                                                            ║
echo  ║  Choisissez votre mode d'utilisation:                                     ║
echo  ║                                                                            ║
echo  ║  [1] 🗂️  Mode USB Standard                                               ║
echo  ║      → Accès normal aux fichiers et dossiers                              ║
echo  ║      → Utilisation comme clé USB classique                                ║
echo  ║                                                                            ║
echo  ║  [2] 🧠 Mode Claude Code DEO                                              ║
echo  ║      → Installation système Claude Code CEO                               ║
echo  ║      → Configuration enterprise complète                                  ║
echo  ║                                                                            ║
echo  ║  [3] ⚙️  Configuration DEO Avancée                                        ║
echo  ║      → Paramètres système DEO                                             ║
echo  ║      → Gestion credentials GitHub                                         ║
echo  ║                                                                            ║
echo  ║  [4] 📖 Documentation                                                     ║
echo  ║      → Guide d'utilisation complet                                        ║
echo  ║      → Instructions détaillées                                            ║
echo  ║                                                                            ║
echo  ║  [0] ❌ Quitter                                                            ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo  💾 Espace disponible:
for /f "tokens=3" %%i in ('dir /-c ^| find "bytes free"') do set free=%%i
echo     %free% bytes libres
echo.

set /p choice=" 🎯 Votre choix [1-4, 0]: "

if "%choice%"=="1" goto mode_usb
if "%choice%"=="2" goto mode_deo
if "%choice%"=="3" goto config_deo
if "%choice%"=="4" goto documentation
if "%choice%"=="0" goto quit
echo.
echo  ❌ Choix invalide ! Appuyez sur une touche pour recommencer...
pause >nul
goto menu

:mode_usb
cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    🗂️  MODE USB STANDARD ACTIVÉ 🗂️                                       ║
echo  ║                                                                            ║
echo  ║    ✅ Accès normal à vos fichiers                                         ║
echo  ║    ✅ Fonctionnement clé USB classique                                    ║
echo  ║    ✅ Système DEO reste en arrière-plan                                   ║
echo  ║                                                                            ║
echo  ║    📁 Dossiers disponibles:                                               ║
echo  ║    • Documents/     - Vos documents                                       ║
echo  ║    • Images/        - Vos photos et images                                ║
echo  ║    • Projects/      - Vos projets de développement                        ║
echo  ║    • Archive/       - Vos fichiers archivés                               ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🚀 Ouverture de l'explorateur de fichiers...
echo.
start explorer.exe .
echo  📂 L'explorateur Windows a été ouvert sur votre clé USB.
echo.
echo  💡 Pour accéder au mode DEO plus tard, relancez MENU_SELECTION.bat
echo.
pause
exit

:mode_deo
cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    🧠 MODE CLAUDE CODE DEO ACTIVÉ 🧠                                      ║
echo  ║                                                                            ║
echo  ║    🚀 Démarrage installation Digital Executive Officer...                  ║
echo  ║                                                                            ║
echo  ║    ⏳ Préparation du système enterprise...                                ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo  🔄 Lancement du système d'installation DEO...
echo.
call ".deo_system\scripts\DEMARRER_DEO_WINDOWS.bat"
echo.
pause
exit

:config_deo
cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    ⚙️  CONFIGURATION DEO AVANCÉE ⚙️                                       ║
echo  ║                                                                            ║
echo  ║    [1] 🔧 Paramètres système                                              ║
echo  ║    [2] 🔑 Configuration GitHub                                             ║
echo  ║    [3] 🧠 Gestion mémoire CEO                                             ║
echo  ║    [4] 📊 Statistiques système                                            ║
echo  ║    [5] 🔄 Synchronisation                                                 ║
echo  ║                                                                            ║
echo  ║    [9] ⬅️  Retour menu principal                                          ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
set /p configchoice=" 🎯 Configuration [1-5, 9]: "

if "%configchoice%"=="1" (
    echo 🔧 Ouverture éditeur de configuration...
    if exist ".deo_system\core\memory_config.json" (
        notepad ".deo_system\core\memory_config.json"
    ) else (
        echo ❌ Fichier de configuration non trouvé
    )
)
if "%configchoice%"=="2" (
    echo 🔑 Configuration GitHub...
    if exist ".deo_system\data\user-configs\github_credentials" (
        echo ✅ Credentials GitHub trouvés
        type ".deo_system\data\user-configs\github_credentials"
    ) else (
        echo ❌ Pas de credentials configurés
        echo 💡 Lancez le mode DEO pour configurer GitHub
    )
)
if "%configchoice%"=="9" goto menu

echo.
pause
goto config_deo

:documentation
cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    📖 DOCUMENTATION DEO SMART USB 📖                                      ║
echo  ║                                                                            ║
echo  ║    📚 Guides disponibles:                                                 ║
echo  ║                                                                            ║
echo  ║    • README.md                  - Guide principal                          ║
echo  ║    • GUIDE_UTILISATION_USB.md   - Mode d'emploi détaillé                  ║
echo  ║                                                                            ║
echo  ║    🌐 Ressources en ligne:                                                ║
echo  ║    • https://github.com/ehadsagency-ai/claude-code-memory                 ║
echo  ║    • ehads.agency@gmail.com                                               ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo  📖 Ouverture de la documentation...
notepad README.md
echo.
pause
goto menu

:quit
cls
echo.
echo  ╔════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                            ║
echo  ║    👋 Au revoir !                                                          ║
echo  ║                                                                            ║
echo  ║    Votre DEO Smart USB est toujours disponible.                           ║
echo  ║    Relancez ce menu quand vous voulez !                                    ║
echo  ║                                                                            ║
echo  ║    🚀 Digital Executive Officer - ehadsagency-ai                           ║
echo  ║                                                                            ║
echo  ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo  Fermeture dans 3 secondes...
timeout /t 3 /nobreak >nul
exit