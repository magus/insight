## imnmj

import re
import sys
import datetime

RUNS = 0
SECOND = 1000
LOG = '/var/log/secure.log'
LOGIN_ATTEMPT_PATTERN = 'Got user: (.*)'
LOGIN_FAIL_PATTERN = 'Failed to authenticate user <(.*)>'


def check_log():
  for line in open(LOG, 'r'):
    time = re.match('^.*[0-9]{2}:[0-9]{2}:[0-9]{2}',line).group(0)
    # datetime.datetime.strptime to obtain comparable object
    print time

    login_attempt = re.search(LOGIN_ATTEMPT_PATTERN,line)
    if login_attempt:
      print 'attempt for: %s'%login_attempt.group(1)

    login_fail = re.search(LOGIN_FAIL_PATTERN,line)
    if login_fail:
      print 'fail for: %s'%login_fail.group(1)

###############################################################################
## Main
#

## while read in from `tail -f /var/log/secure.log`

check_log()


