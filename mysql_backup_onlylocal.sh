#!/bin/sh
BACKUP_PATH=/u01/backup
BACKUP_SUFFIX=_`date "+%y%m%d"`.xz
MYSQLDUMP_SWITCHES='-p --single-transaction'

backup_db()
{
    db=$1
    echo backing up database \"$db\"...
    #mysqldump $MYSQLDUMP_SWITCHES $db | bzip2 -c --best > ${BACKUP_PATH}/${db}${BACKUP_SUFFIX}
    mysqldump $MYSQLDUMP_SWITCHES $db | xz > ${BACKUP_PATH}/${db}${BACKUP_SUFFIX}
}

if [ $# -eq 0 ]
then
    echo "no database name given"
    exit
fi

while [ $# -gt 0 ]
do
    backup_db $1
    shift
done
