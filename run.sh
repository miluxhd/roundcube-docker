#!/bin/sh
chown -R vmail /var/vmail
chown -R www-data /var/www/html/
chown -R mysql /var/lib/mysql
chown :syslog /var/log/
chmod 775 /var/log/
mkdir -p /var/log/apache2 /var/log/mysql
if [ ! -d "/var/lib/mysql/mysql" ]; then /usr/bin/mysql_install_db;fi
/etc/init.d/mysql start;
PSSW=`doveadm pw -s MD5-CRYPT -p $PADMP | sed 's/{MD5-CRYPT}//'`
if [ ! -d "/var/lib/mysql/mail" ]; 
then mysql < /roundcube_postfixadmin.sql;mysql -e "insert into admin values('$PADMIN','$PSSW',1,'2016-03-02 15:23:14','2016-03-03 16:24:44',1);insert into domain_admins values('$PADMIN', 'ALL', NOW(), 1)" mail;
fi
/etc/init.d/postfix start;/etc/init.d/rsyslog start;/etc/init.d/spamassassin start;/etc/init.d/apache2 start;/usr/sbin/dovecot -F
