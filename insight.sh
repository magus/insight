#!/bin/bash

# insight.sh
# periodically check for login attempts and catch 'em

function e_header()   { echo -e "\n\n\033[1;35m☆\033[0m  $@"; }
function e_success()  { echo -e " \033[1;32m ✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m ✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m ➜\033[0m  $@"; }

INSIGHT_DIR="$HOME/.insight";
LOGIN_LOG="/var/log/secure.log";
OLD_LOG="$INSIGHT_DIR/secure.log.old";
CUR_LOG="$INSIGHT_DIR/secure.log.cur";
LOGIN_ATTEMPT_PATT='Got user';

# diff log from last run and determine if there were login attempts
function insight() {
  local logDiff

  #create insight dir and initial log
  if [[ ! -d "$INSIGHT_DIR" ]]; then
    e_header "Creating $INSIGHT_DIR"
    mkdir $INSIGHT_DIR
    cp $LOGIN_LOG $CUR_LOG
  fi

  # refresh log, backup old
  cp $CUR_LOG $OLD_LOG
  cp $LOGIN_LOG $CUR_LOG

  # diff current with old
  if [[ "$(diff $CUR_LOG $OLD_LOG | grep "$LOGIN_ATTEMPT_PATTi")" ]]; then
    echo 'login attempt found!'
  else
    echo 'no login attempts.'
  fi
}

insight
