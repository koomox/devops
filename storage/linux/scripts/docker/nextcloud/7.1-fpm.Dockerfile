FROM php:7.1-fpm
MAINTAINER allen.w koomoxs@gmail.com

# 更换阿里云的镜像源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
	echo "deb http://mirrors.aliyun.com/debian jessie main contrib non-free" > /etc/apt/sources.list && \
	echo "deb-src http://mirrors.aliyun.com/debian jessie main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb http://mirrors.aliyun.com/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb-src http://mirrors.aliyun.com/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb http://mirrors.aliyun.com/debian-security jessie/updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb-src http://mirrors.aliyun.com/debian-security jessie/updates main contrib non-free" >> /etc/apt/sources.list && \
# 更新系统
	apt-get update && \
# apt-get install 
	apt-get install -y \
		libcurl4-openssl-dev \
		libpng12-dev \
		libjpeg-dev \
		libfreetype6-dev \
		libxpm-dev \
		libvpx-dev \
		libmcrypt-dev \
		libicu-dev \
		bzip2 \
		libldap2-dev \
		libmemcached-dev \
		libpq-dev \
		libxml2-dev \
		&& rm -rf /var/lib/apt/lists/* \
		&& \
# docker-php-ext-configure GD
		debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" && \
		docker-php-ext-configure gd \
		--with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
		--with-png-dir=/usr/lib/x86_64-linux-gnu/ \
		--with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
		--with-xpm-dir=/usr/lib/x86_64-linux-gnu/ \
		--with-vpx-dir=/usr/lib/x86_64-linux-gnu/ \
		&& \
		docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch" && \
# docker-php-ext-install GD CURL Intl
		docker-php-ext-install -j $(nproc) json \
		mbstring \
		curl \
		gd \
		gettext \
		mbstring \
		mcrypt \
		mysqli \
		opcache \
		pdo \
		pdo_mysql \
		pgsql \
		pdo_pgsql \
		zip \
		intl \
		ldap \
		exif \
		pcntl \
		&& \
# www.conf
		cp /usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf.bak \
		&& \
# Enable PHP Opcache
		echo "opcache.enable=1" > /usr/local/etc/php/conf.d/opcache-recommended.ini && \
		echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
		echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
		echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
		echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
		echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
		echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
# PECL extensions
		set -ex \
		&& pecl install APCu-5.1.8 \
		&& pecl install memcached-3.0.3 \
		&& pecl install redis-3.1.3 \
		&& docker-php-ext-enable apcu redis memcached
VOLUME /var/www/html
EXPOSE 9000
CMD ["php-fpm"]