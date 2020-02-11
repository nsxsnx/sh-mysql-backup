#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
TIMESTAMP=`/bin/date "+%y%m%d_%H%M%S"`
LOCAL_DUMP_PATH=/backup/db/

MYSQL_USER=root
MYSQL_PASS=**********
MYSQLDUMP_SWITCHES="-u ${MYSQL_USER} -p${MYSQL_PASS} --single-transaction " # format: '-u login [-p[password]]'

FTP_HOST=HOSTNAME
FTP_USER=srv-admin
FTP_PASS=*************
FTP_DIR=srv-admin

backup_db()
{
	db=$1
	echo backing up database \"$db\"...
	mysqldump $MYSQLDUMP_SWITCHES $db | xz > ${LOCAL_DUMP_PATH}${db}_${TIMESTAMP}.sql.xz
}

ftp_upload_db()
{
	db=$1
	echo uploading to ftp server database \"$db\"...
	file=${LOCAL_DUMP_PATH}${db}_${TIMESTAMP}.sql.xz
	if [ -f ${file} ]
	then
		cd `dirname ${file}`
		ftp -n ${FTP_HOST} > /dev/null << EOT
user ${FTP_USER} ${FTP_PASS}
mkdir ${FTP_DIR}
cd ${FTP_DIR}
put `basename ${file}`
bye
EOT
	fi
}
	
if [ $# -eq 0 ]
then
	echo "no database name given"
	exit
fi

while [ $# -gt 0 ]
do
	backup_db $1
	ftp_upload_db $1
	shift
done
