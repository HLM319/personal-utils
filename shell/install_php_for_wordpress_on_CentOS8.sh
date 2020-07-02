# This script should *not* be execute in *any* case.
# It's just a memo for steps to compile install php for wordpress.
# PHP: 7.4.7
# Wordpress 5.4.2
# CentOS 8.2.2004

# install dnf official and epel dependences
dnf config-manager --set-enabled PowerTools
dnf install epel-release
dnf install gcc gcc-c++ autoconf automake tar xz libtool bison libcurl libcurl-devel libsodium libsodium-devel openssl openssl-devel libzip libzip-devel libssh2 libssh2-devel gd ImageMagick ImageMagick-devel ghostscript zlib zlib-devel systemd-devel libxml2 libxml2-devel sqlite sqlite-devel re2c oniguruma oniguruma-devel

# php configureflags
./configure --with-curl --enable-exif --enable-gd --with-webp --with-jpeg --with-freetype --enable-gd-jis-conv --enable-mbstring --with-mysqli --with-sodium --with-openssl --with-zip --with-zlib  --enable-ftp --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx --with-fpm-systemd --disable-short-tags --with-libdir=lib64
make
make test
make install

# copy php config files
cp php.ini-production /usr/local/lib/php.ini
cp sapi/fpm/php-fpm.service /etc/systemd/system/
cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf

# Any variables below is *not* recommend setting, but they probably should be modified and these settings works well(or as my except) when I install.

### php-fpm.conf
# pid=/run/php-fpm.pid
# error_log = /var/log/php-fpm.log
# include=etc/php-fpm.d/*.conf
### remember to change php-fpm.service for pid path too.

### www.conf
# listen=/run/php-fpm
# pm.max_children = 3
# pm.start_servers = 1
# pm.min_spare_servers = 1
# pm.max_spare_servers = 1
##

### php.ini
# memory_limit = 128M
# upload_max_filesize = 32M
# post_max_size = 32M
# max_execution_time = 60
# max_input_time = 60
# session.use_strict_mode = 1
# session.use_only_cookies = 1
# session.cookie_secure = 1 # need SSL?
# data.timezone = "Area/City"
# cgi.fix_pathinfo = 1
# expose_php = Off
### ref:tkacz.pro/nginx-and-php-configure-php-ini-file

# php extension imagick install
curl -O https://pecl.php.net/get/imagick-3.4.4.tgz
tar -xf imagick-3.4.4.tgz
cd imagick-3.4.4
phpize
./configure
make
make install

### /usr/local/lib/php.ini
# extension=imagick
###

# php extension ssh2 install (same as above)
curl -O https://pecl.php.net/get/ssh2-1.2.tgz
# note that this version is not stable, check if update exists.
