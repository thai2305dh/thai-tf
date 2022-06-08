#File giúp cài đặt cấu hình cho máy chủ cho laravel

#!/bin/bash
sudo apt update
sudo apt dist-upgrade
sudo apt install nginx
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt install php8.0
sudo apt install php-curl php-cli php-mbstring wget git unzip php8.0-mysql php8.0-dom php8.0-xml php8.0-fpm php8.0-xmlwriter phpunit php-mbstring php-xml
# sudo apt install libapache2-mod-php8.0
# sudo a2enmod rewrite
sudo systemctl restart nginx

#install codedeploy agent
sudo apt install ruby-full
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile   

#install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

#install awscli
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install

#config nginx
