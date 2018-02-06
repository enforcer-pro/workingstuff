#!/bin/bash
# Shell script to backup MySql database
# To backup Nysql databases file to backup/mysql dir and later pick up by your

MyUSER="" # USERNAME
MyPASS="" # PASSWORD
MyHOST="" # Hostname

# Linux bin paths, change this if it can not be autodetected via which command
MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"

# Backup Dest directory, change this if you have someother location
DEST="/backup/mysql"

# Main directory where backup will be stored
MBD="$DEST/daily"

# delete old files
find $MBD -mtime +30 -name "*.gz" -exec rm -rf {} \;

# Get hostname
HOST="$(hostname)"

# Get data in yyyy-mm-dd format
NOW="$(date +"%Y%m%d%H%M%I%S")"

# File to store current backup file
FILE=""
# Store list of databases
DBS=""

# DO NOT BACKUP these databases
IGGY="test information_schema mysql performance_schema"

[ ! -d $MBD ] && mkdir -p $MBD || :

# Only root can access it!
$CHOWN 0.0 -R $DEST
$CHMOD 0600 $DEST

# Get all database list first
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"

for db in $DBS
do
skipdb=-1
if [ "$IGGY" != "" ];
then
for i in $IGGY
do
[ "$db" == "$i" ] && skipdb=1 || :
done
fi

if [ "$skipdb" == "-1" ] ; then
FILE="$MBD/$db.$HOST.$NOW.gz"
# do all inone job in pipe,
# connect to mysql using mysqldump for select mysql database
# and pipe it out to gz file in backup dir :)
$MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
fi
done
