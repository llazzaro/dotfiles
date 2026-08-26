#Finder Settings
#AppleShowAllFiles 
defaults  write com.apple.Finder AppleShowAllFiles YES

#Select from quicklook from widget
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
# Show extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
#show full path in finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
# quickviewer for folders
defaults write com.apple.finder QLEnableXRayFolders 1

# No .DS_Store on network
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Safari developer mode
defaults write com.apple.Safari IncludeDebugMenu 1
defaults write com.apple.Safari WebKitDeveloperExtras -bool true

# Crash Reporter Modes (basic, developer, server)
# basic: clasic prompt
# developer: crashed thread 
# server: no prompt (good on fuzzing)
defaults write com.apple.CrashReporter DialogType -string developer

## Screenshots
mkdir -p "$HOME/screenshots"
defaults write com.apple.screencapture location -string "$HOME/screenshots"
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

## General Sec
# Enable Require password for screen saver.
sudo defaults -currentHost write com.apple.screensaver askForPassword -int 1
# Enable secure virtual memory.
sudo defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool yes
# Enable Firewall options: # 1 essential, 2 specific services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
# Enable the application firewall and stealth mode (modern macOS).
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
# Enable firewall logging.
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
