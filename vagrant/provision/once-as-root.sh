#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==

timezone=$(echo "$1")

#== Provision script ==

info "Provision-script user: `whoami`"

export DEBIAN_FRONTEND=noninteractive

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "adding ondrej/php repository"
sudo add-apt-repository -y ppa:ondrej/php

info "Enable Percoan PostgreSQL distribution"
sudo wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo rm percona-release_latest.generic_all.deb

info "Update OS software"
sudo apt-get update
sudo apt-get upgrade -y

info "Install ubuntu tools"
sudo apt-get install -y wget gnupg2 lsb-release curl zip unzip nginx-full bc ntp xmlstarlet bash-completion

info "Install PHP 7.4 with its dependencies"
sudo apt-get install -y php7.4-curl php7.4-cli php7.4-intl php7.4-gd php7.4-fpm php7.4-mysql php7.4-mbstring php7.4-xml php7.4-zip php7.4-apcu php7.4-ldap php7.4-bcmath php-xdebug

info "Installing MySQL"
sudo percona-release setup ps80
sudo -E apt-get -q -y install percona-server-server

info "Configure PHP-FPM"
sudo rm /etc/php/7.4/fpm/php.ini
sudo ln -s /app/vagrant/dev/php-fpm/php.ini /etc/php/7.4/fpm/php.ini
sudo rm /etc/php/7.4/fpm/pool.d/www.conf
sudo ln -s /app/vagrant/dev/php-fpm/www.conf /etc/php/7.4/fpm/pool.d/www.conf
sudo rm /etc/php/7.4/mods-available/xdebug.ini
sudo ln -s /app/vagrant/dev/php-fpm/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini
echo "Done!"

info "Configure NGINX"
sudo sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
echo "Done!"

info "Enabling site configuration"
sudo ln -s /app/vagrant/dev/nginx/app.conf /etc/nginx/sites-enabled/app.conf
echo "Done!"

info "Install composer"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

info "allow authentication from external hosts"
# TODO

info "Install user defined MySQL functions"
sudo mysql -e "CREATE FUNCTION fnvla_64 RETURNS INTEGER SONAME 'libfnvla_udf.so'"
sudo mysql -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
sudo mysql -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"

info "Initializing dev databases and users for PostgreSQL"
sudo mysql -e "CREATE DATABASE chamilo;"
sudo mysql -e "CREATE USER 'chamilouser'@'localhost' IDENTIFIED BY 'chamilopassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON chamilo.* TO 'chamilouser'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Done!"
