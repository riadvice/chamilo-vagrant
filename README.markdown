# Vagrant VM for Chamilo (for Development only)

This is a Vagrant configuration VM to be used for "Chamilo LMS". This is meant to be used for production only.

## Usage
- Copy ./vagrant/config/vagrant-local.example.yml to ./vagrant/config/vagrant-local.yml and replace by the values you want to use.
- Launch the VM using `vagrant up`
- Browse to `http://chami.lo` !

## What is inside
 - nginx
 - Percona MySQL 8.0
 - PHP 7.4