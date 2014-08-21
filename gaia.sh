#!/usr/bin/env bash

# Gaia shell tools by Everything.me


###############################################################################
# Setup                                                                       #
###############################################################################

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
alias ffreset='ga && GAIA_DISTRIBUTION_DIR=customization make reset-gaia && cd - && fffwd'

# build the homescreen app twice
alias ffhs='ga && for x in {1..2}; do BUILD_APP_NAME=homescreen make install-gaia; done && cd -'

# build a DEBUG profile
alias ffdbuild='ga && make clean && DEBUG=1 make && cd -'

###############################################################################
# Testing                                                                     #
###############################################################################

# unit tests
alias ffunit="ga && rm -rf profile-gaia-test-b2g/ && ./bin/gaia-test -d"

# marionette test
alias ffmario="TEST_FILES=$1 ./bin/gaia-marionette --verbose"

# python tests
alias ffpy="GAIATEST_SKIP_WARNING=1 GAIATEST_ACKNOWLEDGED_RISKS=1 gaiatest --binary=/Applications/B2G.app/Contents/MacOS/b2g $1"


###############################################################################
# TOOLS                                                                       #
###############################################################################

# launch b2g desktop with a clean profile
alias ffb2g='ga && DESKTOP_SHIMS=1 NOFTU=1 DEBUG=1 make && /Applications/B2G.app/Contents/MacOS/b2g-bin -profile ./profile-debug -start-debugger-server 6000'

# launch Nightly with debug profile
alias ffnight='/Applications/FirefoxNightly.app/Contents/MacOS/firefox -profile "$GAIADIR"/profile-debug'
alias ffnightest='ffnightly http://test-agent.gaiamobile.org:8080/'

###############################################################################
# ADB                                                                         #
###############################################################################

# start b2g
alias ffon='adb shell start b2g'

# stop b2g
alias ffoff='adb shell stop b2g'

# reboot
alias ffboot='adb shell reboot'

# port forwarding for app manager
alias fffwd='adb forward tcp:6000 localfilesystem:/data/local/debugger-socket'

# logcat with Everything.me highlights
alias fflog='adb logcat | grep E/GeckoConsole'

# erase wifi data and reboot
alias ffwipefy='adb shell rm -r data/misc/wifi && adb shell reboot'

# save a device screenshot in current directory
# Note: this method may generate a chunky screenshot. for better quality
# press 'home' and 'power' buttons simultaneously and then use 'adb pull' to
# retrieve the file
#
# usage: ffshot [filename]
function ffscreenshot() {
  TARGET="/sdcard/ffshot.png"

  FILENAME=$1
  : ${FILENAME:="ffshot"}

  adb shell /system/bin/screencap -p $TARGET && adb pull $TARGET $FILENAME.png
}

alias ffshot='ffscreenshot'

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
