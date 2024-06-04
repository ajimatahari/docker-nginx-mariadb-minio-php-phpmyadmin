FROM php:8.1-fpm

# Install PHP extensions for Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Expose port 9000
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

ARG PUID=1000
ARG PGID=1000

RUN groupmod -g "${PGID}" www-data && usermod -u "${PUID}" -g "${PGID}" www-data

