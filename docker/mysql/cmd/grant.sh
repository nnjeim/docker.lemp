credentialsFile=/root/mysql-credentials.cnf
echo "[client]" > $credentialsFile
echo "user=root" >> $credentialsFile
echo "password=$MYSQL_ROOT_PASSWORD" >> $credentialsFile

mysql --defaults-extra-file=$credentialsFile -e "grant all privileges on *.* to $MYSQL_USER@'%'"
