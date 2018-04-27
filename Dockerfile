FROM ubuntu:16.04
ENV DEBIAN_FRONTEND="noninteractive"


COPY postfix /etc/postfix
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN LC_ALL=C.UTF-8  add-apt-repository ppa:ondrej/php -y
RUN apt-get update
RUN  apt-get install -y wget postfix-mysql 
RUN apt-get install vim php5.6 xterm dovecot-mysql dovecot-imapd dovecot-pop3d dovecot-lmtpd spamassassin php-imap postfixadmin roundcube php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml -y
RUN phpenmod intl mcrypt mbstring

RUN update-alternatives --set php /usr/bin/php5.6

RUN adduser vmail -q --home /var/vmail --uid 1150 --disabled-password --gecos ""
RUN usermod -d /var/lib/mysql mysql
RUN wget -q http://netix.dl.sourceforge.net/project/postfixadmin/postfixadmin/postfixadmin-3.1/postfixadmin-3.1.tar.gz
RUN tar -C /var/www/html/ -xf postfixadmin-3.1.tar.gz 
RUN ln -s /var/www/html/postfixadmin-3.1/ /var/www/html/postfixadmin

RUN wget -q http://netix.dl.sourceforge.net/project/roundcubemail/roundcubemail/1.1.4/roundcubemail-1.1.4-complete.tar.gz
RUN tar -C /var/www/html/ -xf roundcubemail-1.1.4-complete.tar.gz
RUN ln -s /var/www/html/roundcubemail-1.1.4 /var/www/html/roundcubemail
RUN chmod 775 /var/log/

COPY roundcube_postfixadmin.sql /

RUN sed -i "s/ENABLED=0/ENABLED=1/g" /etc/default/spamassassin
RUN sed -i 's/'^\;date.timezone*'/date.timezone="Asia\/Tehran"/g' /etc/php/5.6/apache2/php.ini 
COPY run.sh /run.sh
COPY dovecot /etc/dovecot
COPY postfixadmin /var/www/html/postfixadmin
COPY pa_dbconfig.inc.php /etc/postfixadmin/dbconfig.inc.php

COPY roundcubemail/config /var/www/html/roundcubemail/config

EXPOSE 25 80 110 143 465 993 995

ENTRYPOINT /run.sh
