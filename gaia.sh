#!/usr/bin/env bash

# Gaia shell tools by Everything.me


###############################################################################
# Setup                                                                       #
###############################################################################

# gaia repo
GAIADIR="$HOME"/projects/gaia

# r2b2g repo
R2D2B2G_DIR="$HOME"/Library/Application\ Support/Firefox/Profiles/1v31ahcl.default/extensions/r2d2b2g\@mozilla.org/
# r2b2g clean profile
R2D2B2G_CLEAN_PROFILE_DIR="$HOME"/r2d2b2g-clean-profile/

# where to create PR redirect files
PR_REDIRECT_FILES_DIR="$HOME"/Downloads/

alias ga="cd $GAIADIR"


###############################################################################
# Building                                                                    #
###############################################################################

# reset gaia
alias ffreset='cd "$GAIADIR" && make reset-gaia && cd - && fffwd'

# build the homescreen app twice
alias ffhs='cd "$GAIADIR" && for x in {1..2}; do BUILD_APP_NAME=homescreen make install-gaia; done && cd -'

# build a DEBUG profile
alias ffdbuild='cd "$GAIADIR" && make clean && DEBUG=1 make && cd -'

# launch Nightly with debug profile
alias ffnightly='/Applications/FirefoxNightly.app/Contents/MacOS/firefox -profile "$GAIADIR"/profile-debug'

alias ffunit='ffnightly http://test-agent.gaiamobile.org:8080/'

# launch Firefox simulator with a clean profile and a copy homescreen app
alias ffsimulator='killall b2g; make clean && make profile && rm -rf "$R2D2B2G_DIR"/profile && cp -R "$R2D2B2G_CLEAN_PROFILE_DIR" "$R2D2B2G_DIR"/profile && cp "$GAIADIR"/profile/webapps/homescreen.gaiamobile.org/application.zip "$R2D2B2G_DIR"/profile/webapps/homescreen.gaiamobile.org/ && open /Applications/Firefox.app'


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
alias fflogme='adb logcat | grep -E -i "xxx|error|query|feature|session|nativeinfo|evme|rocketbar"'

# erase wifi data and reboot
alias ffwipefy='adb shell rm -r data/misc/wifi && adb shell reboot'

# save a device screenshot in current directory
# Note: this method may generate a chunky screenshot. for better quality
# press 'home' and 'power' buttons simultaneously and then use 'adb pull' to
# retrieve the file
#
# usage: ffshot [filename]
function screenshot() {
  FILENAME=$1
  : ${FILENAME:="screenshot"}

  adb shell /system/bin/screencap -p /sdcard/img.png && adb pull /sdcard/img.png $FILENAME.png
}

alias ffshot='screenshot'

# copy device's settings.json to local folder
alias ffpull-settings='adb pull system/b2g/defaults/settings.json'

###############################################################################
# Helpers                                                                     #
###############################################################################

# create a Github PR redirect page
# an HTML file will be created in the PR_REDIRECT_FILES_DIR directory
# usage: ffpr <pull-request-id>
function ffpr(){
    [ -z "$1" ] && echo "Usage:
    $ ffpr [pull-request-id]"
    echo "<html><head><title>Redirect to pull request #$1</title><meta http-equiv=\"Refresh\" content=\"2; url=https://github.com/mozilla-b2g/gaia/pull/$1\"/></head><body>Redirect to pull request #$1 </body></html>" > "$PR_REDIRECT_FILES_DIR/redirect to PR $1.html"
}