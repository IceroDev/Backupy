#!/bin/bash
############Variables############
timecode=$(date +%d-%m-%Y--%H+%M)
fileName="name-${timecode}"
dataPath="/path/to/data"
backupPath="/path/to/external/drive"
deletingPolicy=44640 #In Minutes
AES256Passwd=""
#################################

mkdir /tmpbackup
cd /tmpbackup

tar -czf ${fileName}.clear.tar.gz ${dataPath}/*


openssl enc -aes256 -pbkdf2 -e -in ${fileName}.clear.tar.gz -out ${fileName}.tar.gz -pass pass:${AES256Passwd}

find ${backupPath} -mindepth 1 -mmin +${deletingPolicy} -delete
rclone cleanup gdrive:

sleep 5

cp ${fileName}.tar.gz ${backupPath} || echo "${timecode} : Error while backuping to external drive." > /var/log/backupy.log

sleep 5

rm -r /tmpbackup
