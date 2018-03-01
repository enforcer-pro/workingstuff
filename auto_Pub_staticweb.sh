# !/bin/bash
PROJECT_NAME=xxxx.tar.gz
APP_DIR=/home/tomcat/webapps
TMP_DIR=/home/tmp
BACKUP_DIR=/home/backup
DATE=`date +%Y%m%d%H%M`
RMDATE="20"

# Backup
cd ${APP_DIR}
tar -zcvf ${BACKUP_DIR}/${DATE}-ROOT.tar.gz ROOT/
echo "Backup finished!"

# Publish
rm ROOT/index.html
rm -rf ROOT/static/
tar zxvf ${TMP_DIR}/${PROJECT_NAME} -C ${APP_DIR}/ROOT


#clean
rm -rf /home/tmp/$PROJECT_NAME
find ${BACKUP_DIR} -type f -mtime +${RMDATE} -exec rm -rf {} \;
echo "Publish finished!"
