#!/bin/bash


DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASS=${db_password}
DB_HOST=${db_endpoint}

# Debugging: Print Variables
echo "Using Database: $DB_NAME"
echo "Using Username: $DB_USER"
echo "Using DB Host: $DB_HOST"

# Update the system packages
yum update -y

# Install Apache web server, PHP, and MySQL connector for PHP
yum install -y httpd php php-mysqlnd

# Start and enable Apache web server
systemctl start httpd
systemctl enable httpd

# Change to the web root directory
cd /var/www/html

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .

# Clean up downloaded and extracted files
rm -rf wordpress latest.tar.gz

# Set proper ownership and permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Create WordPress config file
cp wp-config-sample.php wp-config.php

# TODO: Add database configuration using the 4 variables passed in from the main.tf file
sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
sed -i "s/username_here/$DB_USER/g" wp-config.php
sed -i "s/password_here/$DB_PASS/g" wp-config.php
sed -i "s/localhost/$DB_HOST/g" wp-config.php

systemctl restart httpd
systemctl enable httpd


echo "WordPress installation completed with database configuration!"