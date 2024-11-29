#!/bin/sh

echo "Please enter the MySQL root password:"
read -s mysqlrootpass
echo ""

echo "Please enter the MySQL password:"
read -s mysqlpass
echo ""

echo "Please enter the tunnel token:"
read -s tunneltoken
echo ""

echo "Please enter the URL:"
read url
echo ""

echo "Do you want to enable email configuration? (y/n)"
read enable_email

if [ "$enable_email" = "y" ]; then
    echo "Please enter the email 'From' address:"
    read mail_from
    echo ""

    echo "Please enter the mail driver (e.g., smtp):"
    read mail_driver
    echo ""

    echo "Please enter the mail host:"
    read mail_host
    echo ""

    echo "Please enter the mail port:"
    read mail_port
    echo ""

    echo "Please enter the mail username:"
    read mail_username
    echo ""

    echo "Please enter the mail password:"
    read -s mail_password
    echo ""

    echo "Please enter the mail encryption type (true/false):"
    read mail_encryption
    echo ""
else
    mail_from="noreply@example.com"
    mail_driver="smtp"
    mail_host="mail"
    mail_port="1025"
    mail_username=""
    mail_password=""
    mail_encryption="true"
fi

export mysqlrootpass=$mysqlrootpass
export mysqlpass=$mysqlpass
export tunneltoken=$tunneltoken
export url=$url
export mail_from=$mail_from
export mail_driver=$mail_driver
export mail_host=$mail_host
export mail_port=$mail_port
export mail_username=$mail_username
export mail_password=$mail_password
export mail_encryption=$mail_encryption

if ! command -v docker &> /dev/null; then
    echo "Docker not found, installing..."
    curl -fsSL https://get.docker.com/ -o docker.sh
    chmod +x docker.sh
    ./docker.sh
else
    echo "Docker is already installed."
fi

envsubst < docker-compose.yaml > docker-compose.yaml.tmp && mv docker-compose.yaml.tmp docker-compose.yaml
docker compose up -d
