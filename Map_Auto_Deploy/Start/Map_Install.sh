#!/bin/bash

Start() {
	
	clear

	if [ $UID != "0" ]

	then

		echo "* 警告：当前账号不是root账号，安装过程中可能出现权限问题，请先登录root ==> [ sudo su root ]"

	else

		echo -e "* 程序即将初始化,请稍等\c"
		Geek_YiZhang
		Main_Install

		echo -e "* 初始化完成，即将配置和导入数据库，请稍等\c"
		Geek_YiZhang
		Mysql_OUT_DB

		echo -e "* 配置和导入数据库完成，即将安装地图和统计图，请稍等\c"
		Geek_YiZhang
		Map_Install

		echo -e "* 地图和统计图安装完成，即将导入计划任务，请稍等\c"
		Geek_YiZhang
		Map_Crontab

		clear
		echo -e "* 恭喜，程序安装完成，即将重启电脑，请稍等\c"
		Geek_YiZhang
		sleep 3
		init 6
	fi
}

Geek_YiZhang() {

	sleep 0.5
	echo -e ".\c"
	sleep 0.5
	echo -e ".\c"
	sleep 0.5
	echo -e ".\c"
	sleep 0.5
	echo -e ".\c"
	sleep 0.5
	echo -e ".\c"
	sleep 0.5
	echo "."
}

Main_Install() {

	apt-get update
	apt-get install ssh -y
	apt-get install gcc -y
	apt-get install curl -y
	apt-get install jq . -y
	apt-get install vim -y
	apt-get install git -y
	apt-get install apache2 -y
	apt-get install php5 php5-odbc php5-dev php5-mysql -y
	debconf-set-selections Start/mysql-passwd
	apt-get install mysql-server -y
	#apt-get install phpmyadmin -y
}

Mysql_OUT_DB() {

	#mysqladmin -u root password "root"
	mysql -uroot -proot -e "create database rimag_show character set gbk;"
	mysql -uroot -proot rimag_show < Start/rimag_show.sql
}

Map_Install() {

	tar xvzf Start/Map.tar.gz -C /var/www/html/
	chmod 777 -R /var/www/html/
	#ln -s /usr/share/phpmyadmin /var/www/html/
	ln -s /var/www/html /home/setup/
	mv /var/www/html/Map/index.php /var/www/html/
	mv /var/www/html/index.html /var/www/html/index.html.bak
}

Map_Crontab() {

	echo "0 16 * * * root php /var/www/html/Map/Crontab/Crontab_Application.php" >> /etc/crontab
	echo "0 16 * * * root php /var/www/html/Map/Crontab/Crontab_Dtorage_Data.php" >> /etc/crontab
}

Start

