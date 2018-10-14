#!/bin/bash
 
# install.sh
# install and configure insight daemon
 
VERSION="1.7";
INSIGHT_PATH="$HOME/insight";
INSIGHT_LOGS="$INSIGHT_PATH/logs";
INSIGHT_GITHUB="$INSIGHT_PATH/github";
INSIGHT_BIN="$INSIGHT_GITHUB/bin";
INSIGHT_SAW="$INSIGHT_GITHUB/saw";
INSIGHT_AUTH_LOG="/var/log/auth.log";
SYSLOG="$INSIGHT_GITHUB/conf/syslog.conf";
SYSLOG_PATH="/etc/syslog.conf";
INSIGHT_DAEMON="com.iamnoah.insight.plist";
INSIGHT_DAEMON_PATH="/Library/LaunchDaemons/$INSIGHT_DAEMON";
INSIGHT_SCRIPT="insight.sh";
 
function e_header()   { echo -e "\n\n\033[1;35m☆\033[0m  $@"; }
function e_success()  { echo -e " \033[1;32m ✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m ✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m ➜\033[0m  $@"; }
 
function tmpl() {
  cp "$@.tmpl" "$@"
  sed -i .bak "s#{{insightPath}}#$INSIGHT_PATH#g" "$@"
  sed -i .bak "s#{{daemon}}#${INSIGHT_DAEMON%.plist}#g" "$@"
  sed -i .bak "s#{{user}}#$USER#g" "$@"
  sed -i .bak "s#{{bin}}#$INSIGHT_BIN#g" "$@"
  sed -i .bak "s#{{script}}#$INSIGHT_SCRIPT#g" "$@"
  sed -i .bak "s#{{logs}}#$INSIGHT_LOGS#g" "$@"
  sed -i .bak "s#{{authLog}}#$INSIGHT_AUTH_LOG#g" "$@"
  rm "$@.bak"
}
 
## Begin installation
e_header "Insight :: v$VERSION"
 
# Mac OS
if [[ ! "$OSTYPE" =~ ^darwin ]]; then
  e_error "Insight is made for Mac OSX."
  exit 1
fi
 
# prompt sudo password and update existing sudo timestamp until script finishes
e_arrow "You may be prompted for your admin password ..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
 
 
e_header "Downloading insight from github to $INSIGHT_GITHUB ..."
if [[ -d $INSIGHT_GITHUB ]]; then
  rm -rf $INSIGHT_GITHUB/*
fi
mkdir -p $INSIGHT_GITHUB
cd $INSIGHT_GITHUB
curl -L https://github.com/magus/insight/archive/master.zip | tar zx --strip 1
 
e_header "Configuration"
# syslog.conf
if [[ -e $SYSLOG_PATH ]]; then
  e_arrow "Backing up existing $SYSLOG_PATH to $SYSLOG_PATH.backup ..."
  sudo cp $SYSLOG_PATH $SYSLOG_PATH.backup
fi
 
e_arrow "Generating $SYSLOG entry ..."
tmpl $SYSLOG
 
cd $INSIGHT_GITHUB
 
if [[ ! -e $SYSLOG_PATH || ! "$(grep "$(cat $SYSLOG | tail -n2)" $SYSLOG_PATH)" ]];
then
  e_arrow "Appending $SYSLOG to $SYSLOG_PATH entries ..."
  cat $SYSLOG | sudo tee -a $SYSLOG_PATH > /dev/null
  rm $SYSLOG
fi
 
# restart syslogd with changes
sudo kill -HUP `cat /var/run/syslog.pid`
e_success "$SYSLOG_PATH updated successfully."
 
e_header "Insight Daemon"
if [[ "$(launchctl list | grep ${INSIGHT_DAEMON%.plist})" ]]; then
  e_header "BUG FIX: Unloading existing insight daemon ...";
  launchctl unload $INSIGHT_DAEMON_PATH
fi
if [[ "$(sudo launchctl list | grep ${INSIGHT_DAEMON%.plist})" ]]; then
  e_header "BUG FIX: Unloading existing sudo insight daemon ...";
  sudo launchctl unload $INSIGHT_DAEMON_PATH
fi
 
e_arrow "Generating insight daemon ..."
tmpl $INSIGHT_DAEMON
tmpl $INSIGHT_SCRIPT
e_success "insight daemon generated."
 
./log/setup.sh > /dev/null 2>&1
cd $INSIGHT_GITHUB
 
e_arrow "Installing insight daemon ...";
sudo cp $INSIGHT_SCRIPT $INSIGHT_BIN
sudo cp $INSIGHT_DAEMON $INSIGHT_DAEMON_PATH
 
sudo launchctl load -w -F $INSIGHT_DAEMON_PATH
sudo launchctl start ${INSIGHT_DAEMON%.plist}
e_success "insight daemon installed."
 
./history/finish.sh > /dev/null 2>&1 &
 
e_arrow "Cleaning up generated and backup files ..."
rm -rf $INSIGHT_GITHUB/history
rm -rf $INSIGHT_GITHUB/log*
rm $INSIGHT_GITHUB/com.*
rm $INSIGHT_GITHUB/com.*
rm $INSIGHT_SCRIPT
rm uninstall.sh
 
 
# All done!
e_header "All done!"
e_header "Try logging in or out (or even locking and unlocking your screen)!"
e_arrow "Insight records all screenshots to $INSIGHT_SAW" && rm ~/insight/github/install.sh
