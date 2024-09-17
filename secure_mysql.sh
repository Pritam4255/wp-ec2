#!/bin/bash

# Define MySQL root password
MYSQL_ROOT_PASS="your_root_password"

# Function to run MySQL commands
mysql_cmd() {
    mysql -u root -p"${MYSQL_ROOT_PASS}" -e "$1"
}

# Update package index
echo "Updating package index..."
sudo apt-get update

# Install mysql-server if not installed
echo "Checking MySQL installation..."
if ! dpkg -l | grep -q mysql-server; then
    echo "MySQL server not found. Installing..."
    sudo apt-get install -y mysql-server
else
    echo "MySQL server is already installed."
fi

# Secure MySQL installation
echo "Securing MySQL installation..."
mysql_secure_installation <<EOF

y
${MYSQL_ROOT_PASS}
${MYSQL_ROOT_PASS}
y
y
y
y
EOF

# Remove anonymous users
echo "Removing anonymous users..."
mysql_cmd "DELETE FROM mysql.user WHERE User='';"

# Remove test database
echo "Removing test database..."
mysql_cmd "DROP DATABASE IF EXISTS test;"

# Disallow root login remotely
echo "Disallowing root login remotely..."
mysql_cmd "UPDATE mysql.user SET Host='localhost' WHERE User='root';"

# Reload privilege tables
echo "Reloading privilege tables..."
mysql_cmd "FLUSH PRIVILEGES;"

# Restrict access to MySQL port
echo "Restricting access to MySQL port..."
sudo ufw deny 3306
sudo ufw allow from 127.0.0.1 to any port 3306

# Enforce strong passwords policy
echo "Enforcing strong passwords policy..."
mysql_cmd "INSTALL PLUGIN validate_password SONAME 'validate_password.so';"

# Set up basic firewall rules if not already set
echo "Setting up firewall rules..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 3306/tcp

# Restart MySQL service to apply changes
echo "Restarting MySQL service..."
sudo systemctl restart mysql

echo "MySQL database secured successfully."
