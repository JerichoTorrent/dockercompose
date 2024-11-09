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

export mysqlrootpass=$mysqlrootpass
export mysqlpass=$mysqlpass
export tunneltoken=$tunneltoken
export url=$url

if ! command -v docker &> /dev/null; then
    echo "Docker not found, installing..."
    curl -fsSL https://get.docker.com/ -o docker.sh
    chmod +x docker.sh
    ./docker.sh
else
    echo "Docker is already installed."
fi

curl http://cdn.craftsupport.dev/api/cdn/download/docs/install.yaml -o docker-compose.yaml

envsubst < docker-compose.yaml > docker-compose.yaml.tmp && mv docker-compose.yaml.tmp docker-compose.yaml
docker compose up -d
