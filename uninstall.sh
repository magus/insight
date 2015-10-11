#!/bin/bash

function removeDaemon() {
  sudo launchctl unload "/Library/LaunchDaemons/$@";
  sudo rm "/Library/LaunchDaemons/$@";
}

# remove daemon
removeDaemon "com.iamnoah.insight.plist"

# remove insight
sudo rm -rf $HOME/insight
