#!/bin/bash
ZABBIX=
PORT=
KEY=
HOST=
TLS_IDENTION=
PSKFILE=
MYSQL_USER=
MYSQL_PASS=
DATE=$(date +"%m-%d-%Y")
DIR=/backupmysql
RETENTION=$(date --date="2 days ago" +"%m-%d-%Y")
FTP_HOST=
FTP_USER=
FTP_PASS=
set -x
mysqldump -u $MYSQL_USER  -p$MYSQL_PASS  --single-transaction --quick --lock-tab                                                                                                                                                       les=false --all-databases > $DIR/$DATE.sql
if [ $? -eq 0 ]
then
   cd $DIR
   gzip  $DATE.sql
   if [ $? -eq 0 ]
   then
       lftp -u $FTP_USER,$FTP_PASS $FTP_HOST -e "set net:reconnect-interval-base                                                                                                                                                        60;set net:reconnect-interval-multiplier 1;set net:max-retries 3;set net:idle 1                                                                                                                                                       0;set net:connection-limit 2;set ftp:ssl-allow true;set ftp:ssl-force true;set f                                                                                                                                                       tp:ssl-protect-data true;set ftp:ssl-protect-list true;set ssl:ca-file "/etc/ssl                                                                                                                                                       /certs/server-crt.pem";mput -c $DIR/$DATE.sql.gz*;exit" 2>&1
       if [ $? -eq 0 ]
       then
         rm -r  $RETENTION.sql.*
         if [ $? -eq 0 ]
         then
             exit 0
         else
            MSG="Removing old backup files failed"
            zabbix_sender -z $ZABBIX -p $PORT -s "$HOST" -k $KEY -o "$MSG"   --t                                                                                                                                                       ls-connect psk    --tls-psk-identity "$TLS_IDENTION"  --tls-psk-file $PSKFILE
            exit 1
         fi
       else
         MSG="Sendibg files has error to FTP srver "
         zabbix_sender -z $ZABBIX -p $PORT -s "$HOST" -k $KEY -o "$MSG"   --tls-                                                                                                                                                       connect psk    --tls-psk-identity "$TLS_IDENTION"  --tls-psk-file $PSKFILE
         exit 1
       fi
   else
        MSG="There is an error in compressing files "
        zabbix_sender -z $ZABBIX -p $PORT -s "$HOST" -k $KEY -o "$MSG"   --tls-c                                                                                                                                                       onnect psk    --tls-psk-identity "$TLS_IDENTION"  --tls-psk-file $PSKFILE
        exit 1
   fi
else
    MSG="Error in creating backup "
    zabbix_sender -z $ZABBIX -p $PORT -s "$HOST" -k $KEY -o "$MSG"   --tls-conne                                                                                                                                                       ct psk    --tls-psk-identity "$TLS_IDENTION"  --tls-psk-file $PSKFILE
    exit 1
fi
