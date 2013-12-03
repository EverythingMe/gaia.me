#!/usr/bin/env bash

# Gaia shell tools by Everything.me


###############################################################################
# Setup                                                                       #
###############################################################################

# gaia repo
GAIA_DIR="$HOME"/projects/gaia

# r2b2g repo
R2D2B2G_DIR="$HOME"/Library/Application\ Support/Firefox/Profiles/1v31ahcl.default/extensions/r2d2b2g\@mozilla.org/
# r2b2g clean profile
R2D2B2G_CLEAN_PROFILE_DIR="$HOME"/r2d2b2g-clean-profile/

# where to create PR redirect files
PR_REDIRECT_FILES_DIR="$HOME"/Downloads/

alias ga="cd $GAIA_DIR"


###############################################################################
# Building                                                                    #
###############################################################################

# reset gaia
alias ffreset='cd "$GAIA_DIR" && make reset-gaia && cd -'

# build the homescreen app twice
alias ffhs='cd "$GAIA_DIR" && for x in {1..2}; do BUILD_APP_NAME=homescreen make install-gaia; done && cd -'

# build a DEBUG profile
alias ffdbuild='cd "$GAIA_DIR" && make clean && DEBUG=1 make && cd -'

# launch Nightly with debug profile
alias ffnightly='/Applications/FirefoxNightly.app/Contents/MacOS/firefox -profile "$GAIA_DIR"/profile-debug'

# launch Firefox simulator with a clean profile and a copy homescreen app
alias ffsimulator='killall b2g; make clean && make profile && rm -rf "$R2D2B2G_DIR"/profile && cp -R "$R2D2B2G_CLEAN_PROFILE_DIR" "$R2D2B2G_DIR"/profile && cp "$GAIA_DIR"/profile/webapps/homescreen.gaiamobile.org/application.zip "$R2D2B2G_DIR"/profile/webapps/homescreen.gaiamobile.org/ && open /Applications/Firefox.app'


###############################################################################
# ADB                                                                         #
###############################################################################

# start b2g
alias ffart='adb shell start b2g'

# stop b2g
alias fftop='adb shell stop b2g'

# reboot
alias ffboot='adb shell reboot'

# port forwarding for app manager
alias fffwd='adb forward tcp:6000 localfilesystem:/data/local/debugger-socket'

# logcat with Everything.me highlights
alias fflogme='adb logcat | sed "s/E\/Gecko.*homescreen.gaiamobile.org\/everything.me/evme/g" | grep -E -i "xxx|error|query|feature|session|nativeinfo|evme"'

# erase wifi data and reboot
alias ffwipefy='adb shell rm -r data/misc/wifi && adb shell reboot'

# save a device screenshot in current directory
# Note: this method may generate a chunky screenshot. for better quality
# press 'home' and 'power' buttons simultaneously and then use 'adb pull' to
# retrieve the file
alias ffshot='adb shell /system/bin/screencap -p /sdcard/img.png && adb pull /sdcard/img.png screenshot.png'

# copy device's settings.json to local folder
alias ffpull-settings='adb pull system/b2g/defaults/settings.json'

###############################################################################
# Helpers                                                                     #
###############################################################################

# create a Github PR redirect page
# an HTML file will be created in the PR_REDIRECT_FILES_DIR directory
# usage: ffpr <pull-request-id>
ffpr(){
    [ -z "$1" ] && echo "Usage:
    $ ffpr [pull-request-id]"
    echo "<html><head><title>Redirect to pull request #$1</title><meta http-equiv=\"Refresh\" content=\"2; url=https://github.com/mozilla-b2g/gaia/pull/$1\"/></head><body>Redirect to pull request #$1 </body></html>" > "$PR_REDIRECT_FILES_DIR/redirect to PR $1.html"
}