#!/bin/bash
 
# Cronlock - A simple to use locking mechanism for cronjobs in distributed environment
# Author - Vivek Vaskuttan
# Email - vivekv@vivekv.com
# Website - www.vivekv.com
 
# Usage
#------
# * * * * * /usr/bin/cronlock logKey ping google.com
# * * * * * cd /var/www/; /usr/bin/cronlock /usr/bin/php logKey test.php
#
# where,
# logKey is a filename where the output of the cron will be saved
# ping google.com is the command that needs to be executed
 
# Configuration
# LOCK_DIR and LOG_DIR must be a shared volume between the servers for this to work
# LOG_DIR/last_successful_start file is created with the timestamp when the cron starts executing
# LOG_DIR/last_successful_exit file is created when cron completes executing the command
 
LOCK_DIR=/mnt/volume/logs/lock
LOG_DIR=/mnt/volume/logs/cron
 
MD5=`echo -n "$@" | md5sum | awk '{print $1}'`
COMMAND="${@:2}"
mkdir -p ${LOG_DIR}
mkdir -p ${LOCK_DIR}
 
( /usr/bin/flock -n -x 200 && date > ${LOG_DIR}/last_successful_start_$1.log && ${COMMAND} && date > ${LOG_DIR}/last_successful_exit_$1.log ) 2>&1 200> ${LOCK_DIR}/${MD5} | while read line ; do echo `date` "- $line" ; done >> ${LOG_DIR}/$1.log
