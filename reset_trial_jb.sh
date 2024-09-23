#!/bin/bash
# https://gist.github.com/Hedgehogues/123eb27100608d248cf8370e666b29ce/

# declare array of tools
declare -a tools=(
    "DataGrip"
    "CLion"
    "Rider"
    "WebStorm"
    "GoLand"
    "PyCharm"
)

for tool in "${tools[@]}"
do
    rm -rf ~/.config/JetBrains/$tool*/eval
    rm -rf ~/.config/JetBrains/$tool*/options/usage.statistics.xml
    rm -rf ~/.config/JetBrains/$tool*/options/other.xml
    rm -rf ~/.config/JetBrains/$tool*/options/recentProjects.xml
    rm -rf ~/.config/JetBrains/$tool*/options/updates.xml
    rm -rf ~/.config/JetBrains/$tool*/options/usage.statistics.xml
    rm -rf ~/.java/.userPrefs/jetbrains
    rm -rf ~/.java/.userPrefs/prefs.xml
    rm -rf ~/.java/.userPrefs/.user.lock.user
    rm -rf ~/.java/.userPrefs/.userRootModFile.user
done
