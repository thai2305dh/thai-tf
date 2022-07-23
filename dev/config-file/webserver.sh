#File giúp cài đặt cấu hình cho máy chủ cho laravel

#!/bin/bash -ex
                  sudo rm -rf /var/lib/apt/lists/lock
                  sudo apt update
                  sudo apt install nginx -y
sudo apt dist-upgrade -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php8.0 -y
sudo apt install php-curl php-cli php-mbstring wget git unzip php8.0-mysql php8.0-dom php8.0-xml php8.0-fpm php8.0-xmlwriter phpunit php-mbstring php-xml -y
# sudo apt install libapache2-mod-php8.0
# sudo a2enmod rewrite
sudo systemctl restart nginx

#install codedeploy agent
sudo apt install ruby-full -y
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
