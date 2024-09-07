#!/bin/bash

# Variables - set these to your desired values
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASSWORD="strong_password"
DB_HOST="localhost"
MYSQL_ROOT_PASSWORD="your_mysql_root_password"

# Check if MySQL is installed
if ! command -v mysql &> /dev/null
then
    echo "MySQL is not installed. Please install it and try again."
    exit 1
fi

# Create the database
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $DB_NAME;"

# Create the database user and grant privileges
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Output the result
echo "WordPress database '$DB_NAME' and user '$DB_USER' created with the specified password."

