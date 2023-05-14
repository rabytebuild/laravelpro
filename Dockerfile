# Start with a base image
FROM php:7.4-apache

# Update the package index and install required dependencies
RUN apt-get update && \
    apt-get install -y git zip unzip libzip-dev && \
    docker-php-ext-install pdo_mysql zip && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy the Laravel application files to the container
COPY . .

# Install Composer and the project dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize

# Set the appropriate permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose the necessary ports
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
