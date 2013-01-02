## imnmj

import re
import sys
import datetime

RUNS = 0
SECOND = 1000
LOG = '/var/log/secure.log'
LOGIN_ATTEMPT_PATTERN = 'Got user: '


def check_log():
  for line in open(LOG, 'r'):
    time = re.match('^.*[0-9]{2}:[0-9]{2}:[0-9]{2}',line).group(0)
    # datetime.datetime.strptime to obtain comparable object

###############################################################################
## Main
#

## while read in from `tail -f /var/log/secure.log`


