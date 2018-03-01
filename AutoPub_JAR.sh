#!/bin/bash
BAK_DIR=/home/backup
DATE=`date +%Y%m%d%H%M`
RMDATE="5"
JARNAME=xxxx.jar
JARHOME=/home/XXXX

# Use kill -9 to shutdown wechat.server
ps -ef | grep ${JARNAME}  | grep -v grep | awk '{print $2}'  | xargs kill -9

#Backup
cd /home/${JARHOME}
mv ${JARNAME} ${BAK_DIR}/${DATE}-${JARNAME}
find ${BACKUP_DIR} -type f -mtime +${RMDATE} -exec rm -rf {} \;
echo "Backup finished!"

#Publish jarservices
cp /home/tmp/${JARNAME} /${JARHOME}/
nohup java -jar -Dspring.profiles.active=production /${JARHOME}/${JARNAME} >xxxx.out 2>&1 &
//nohup java -jar -Dspring.profiles.active=test /${JARHOME}/${JARNAME} >xxxx.out 2>&1 &


#Remove tmp
rm -rf /home/tmp/${JARNAME}
