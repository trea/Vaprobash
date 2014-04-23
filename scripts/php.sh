#!/usr/bin/env bash
#
#
if [ -z "$1" ]; then
    php_version="distributed"
else
    php_version="$1"
fi

echo ">>> Installing PHP $1 version"

if [ $php_version == "latest" ]; then
    sudo add-apt-repository -y ppa:ondrej/php5
fi

if [ $php_version == "previous" ]; then
    sudo add-apt-repository -y ppa:ondrej/php5-oldstable
fi

sudo apt-get update

# Install PHP
sudo apt-get install -y php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp php5-mcrypt php5-memcached php5-imagick php5-intl


# PHP Error Reporting Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
sed -i "s/html_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

# PHP Date Timezone
sed -i "s/;date.timezone =.*/date.timezone = ${2/\//\\/}/" /etc/php5/fpm/php.ini
sed -i "s/;date.timezone =.*/date.timezone = ${2/\//\\/}/" /etc/php5/cli/php.ini

# Make sure php5-fpm is running as a Unix socket on "distributed" version
if [ $php_version == "distributed" ]; then
    sed -i "s/listen = .*/listen = \/var\/run\/php5-fpm.sock/" /etc/php5/fpm/pool.d/www.conf
fi

sudo service php5-fpm restart
