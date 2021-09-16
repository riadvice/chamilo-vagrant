#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Provision script ==

info "Provision-script user: `whoami`"

info "Install project dependencies"
cd /app
wget https://github.com/chamilo/chamilo-lms/releases/download/v1.11.16/chamilo-1.11.16.zip
unzip chamilo-1.11.16.zip
mv chamilo-1.11.16 chamilo
# composer --no-progress --prefer-dist install

info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc
