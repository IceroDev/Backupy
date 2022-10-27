#!/bin/bash
############Variables############
timecode=$(date +%d-%m-%Y--%H+%M)
fileName="name-${timecode}"
dataPath="/path/to/data"
backupPath="/path/to/external/drive"
deletingPolicy=44640 #In Minutes
AES129Passwd="MyKey"
discordWebhook="https://discordapp.com/api/webhooks/XXXXX"
#################################

mkdir /tmpbackup
cd /tmpbackup

tar -czf ${fileName}.clear.tar.gz ${dataPath}/*


openssl enc -aes128 -pbkdf2 -e -in ${fileName}.clear.tar.gz -out ${fileName}.tar.gz -pass pass:${AES129Passwd}

find ${backupPath} -mindepth 1 -mmin +${deletingPolicy} -delete
rclone cleanup gdrive:

sleep 5

cp ${fileName}.tar.gz ${backupPath} || curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"@everyone :x: A backup failed on the server\"}" ${discordWebhook}

sleep 5

rm -r /tmpbackup
