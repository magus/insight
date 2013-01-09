#!/bin/bash

# insight.sh
# periodically check for login attempts and catch 'em

function e_header()   { echo -e "\n\n\033[1;35m☆\033[0m  $@"; }
function e_success()  { echo -e " \033[1;32m ✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m ✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m ➜\033[0m  $@"; }

LOGIN_LOG="/var/log/secure.log";

INSIGHT_DIR="$HOME/.insight";
INSIGHT_SAW="$INSIGHT_DIR/saw";
LOGIN_ATTEMPT_PATT='Got user';
OLD_LOG="$INSIGHT_DIR/secure.log.old";
CUR_LOG="$INSIGHT_DIR/secure.log.cur";

# diff log from last run and determine if there were login attempts
function insight() {
  local loginAttempts 
  #create insight dir and initial log
  if [[ ! -d "$INSIGHT_DIR" ]]; then
    mkdir $INSIGHT_DIR
    cp $LOGIN_LOG $CUR_LOG
  fi

  # refresh log, backup old
  cp $CUR_LOG $OLD_LOG
  cp $LOGIN_LOG $CUR_LOG

  # diff current with old
  loginAttempts="$(diff $CUR_LOG $OLD_LOG | grep "$LOGIN_ATTEMPT_PATT")"
  if [[ "$loginAttempts" ]]; then
    e_arrow 'Login attempt found!'
    e_arrow "$loginAttempts"
    [[ -d "$INSIGHT_SAW" ]] || mkdir -p $INSIGHT_SAW
    imagesnap -q "$INSIGHT_SAW/insight-$(date "+%Y_%m_%d-%H_%M_%S")" &
    e_arrow 'Insight saw and captured.'
  fi
}

insight
