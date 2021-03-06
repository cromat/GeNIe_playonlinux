#!/bin/bash
# Rise of Nations - Play On Linux script
# Version: 0.1.0
# Installation Requirements:
#        wine 1.7.18, directmusic, dsound, mfc40, mfc42, msvcirt, msxml4, vcrun6
# Author: ekultails@gmail.com
# Website: https://github.com/ekultails/playonlinux
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
# enable debugging
POL_Debug_Init
 
# set global variables
TITLE="Rise of Nations"
PREFIX="RoN"
FULL_POL_PREFIX="$HOME/.PlayOnLinux/wineprefix/$PREFIX"
GAME_PATH="$FULL_POL_PREFIX/drive_c/Program Files/Microsoft Games/Rise of Nations"
 
# start the installation window
POL_SetupWindow_Init
POL_SetupWindow_presentation "$TITLE" "Big Huge Games" "http://bighugegames.com" "EkulTails" "$PREFIX"
 
# tell the user's about compatibility
POL_SetupWindow_message "This PlayOnLinux script will work with any version of the non-Steam Rise of Nations game. That includes the base Rise of Nations game, the Thrones and Patriots expansion, and the Gold Edition. The Steam version does not work because the game was rebuilt to use DirectX10 instead of DirectX9. Better support for DirectX10 in Wine is still a work-in-progress." "Compatibility"
 
# locate the CD mount point and then check to see if the required executable exists
POL_SetupWindow_cdrom
POL_SetupWindow_check_cdrom "Setup.exe"
 
# CHECK FOR INTERNET CONNECTION!!!


# use our unique prefix for installing Wine
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "3.4"
 
# install required depedencies in the Wine environment
POL_Call POL_Install_directmusic
POL_Call POL_Install_dsound
POL_Call POL_Install_mfc40
POL_Call POL_Install_mfc42
POL_CALL POL_Install_msxml4
POL_CALL POL_Install_vcrun6
 
# inform the user about the false-positive PoL error
POL_SetupWindow_message "When the installation starts, PlayOnLinux will throw a false-positive error saying Wine crashed. Click \"Next\" and then continue on with the installation. After it is installed, close the launcher. DO NOT START THE GAME." "Read Before Installation"
 
# run the RoN installation and wait for it to complete
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$CDROM/Setup.exe"
POL_Wine_WaitExit "$TITLE"
 
POL_SetupWindow_question "Are you also installing a seperate Thrones and Partiots expansion CD? Select \"No\" if you are only installing the base Rise of Nations game or the Rise of Nations: Gold Edition." "Expansion Pack Installation"
if [[ $APP_ANSWER == "TRUE" ]]; then
        POL_SetupWindow_cdrom
        POL_SetupWindow_check_cdrom "Setup.exe"
        POL_Wine_WaitBefore "$TITLE"
        POL_Wine "$CDROM/Setup.exe"
        POL_Wine_WaitExit "$TITLE"
fi


# this file needs a few tweaks for RoN to run smoothly
rise2ini_path="$FULL_POL_PREFIX/drive_c/users/$USER/Application Data/Microsoft Games/Rise of Nations"
rise2ini="$rise2ini_path/rise2.ini"
# create the rise2.ini file if it does not exist already
if [[ ! -d "$rise2ini_path" ]]; then
        mkdir -p "$rise2ini_path"
fi
if [[ ! -f $rise2ini ]]; then
        touch "$rise2ini"
fi
# delete these entries, if they exist
sed -i '/ForceGDICursor=/d' "$rise2ini"
sed -i '/ForceLowCPUBackgroundVid=/d' "$rise2ini"
sed -i '/SkipIntroMovies=/d' "$rise2ini"
sed -i '/Windowed Width=/d' "$rise2ini"
sed -i '/Windowed Height=/d' "$rise2ini"
sed -i '/AllowAllResolutions=/d' "$rise2ini"
sed -i '/CPU_grade_override(A-F or AUTO)=/d' "$rise2ini"


# add the necessary values
echo -e "[RISE OF NATIONS]\nCPU_grade_override(A-F or AUTO)=C\nAllowAllResolutions=1\nWindowed Width=1366\nWindowed Height=768\nForceGIDCursor=1\nSkipIntroMovies=1\nForceLowCPUBackgroundVid=1\n" >> "$rise2ini"
 
# create the shortcut and exit
if [[ -f "$GAME_PATH/patriots.exe" ]]; then
        POL_Shortcut "patriots.exe" "$TITLE"
else
        POL_Shortcut "rise.exe" "$TITLE"       
fi
POL_SetupWindow_message "Installation successfully completed. Please submit any bugs to \"https://github.com/ekultails/playonlinux\". Enjoy!" "Rise of Nations Installed."
POL_SetupWindow_Close
exit 0
Status API Training Shop Blog About