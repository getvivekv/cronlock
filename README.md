# cronlock
Run cronjobs in distributed environments

# Usage

`
* * * * * /usr/bin/cronlock logKey ping google.com
* * * * * cd /var/www/; /usr/bin/cronlock /usr/bin/php logKey test.php
`

where,
* logKey is a filename where the output of the cron will be saved
* ping google.com is the command that needs to be executed
 
# Configuration
* LOCK_DIR and LOG_DIR must be a shared volume between the servers for this to work
* LOG_DIR/last_successful_start file is created with the timestamp when the cron starts executing
* LOG_DIR/last_successful_exit file is created when cron completes executing the command
