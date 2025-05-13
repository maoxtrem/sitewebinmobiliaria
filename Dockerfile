# Imagen base PHP con Apache optimizada para producción
FROM php:8.2-apache-bookworm

# Instalar dependencias necesarias y extensiones PHP
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        curl \
        unzip \
        libzip-dev \
        libsqlite3-dev \
    && docker-php-ext-install pdo pdo_sqlite zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js LTS (estable) y npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Copiar configuración personalizada de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf && a2enmod rewrite

WORKDIR /workspaces/sitewebinmobiliaria

# Asignar permisos adecuados (ajusta según tu framework y seguridad)
RUN chown -R www-data:www-data /workspaces/sitewebinmobiliaria