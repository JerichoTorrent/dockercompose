#!/bin/sh

echo "Please enter the tunnel token:"
read -s tunneltoken
echo ""

export tunneltoken=$tunneltoken


if ! command -v docker &> /dev/null; then
    echo "Docker not found, installing..."
    curl -fsSL https://get.docker.com/ -o docker.sh
    chmod +x docker.sh
    ./docker.sh
else
    echo "Docker is already installed."
fi

curl http://dev.craftsupport.dev:81/api/cdn/download/docs/ghost.yaml -o docker-compose.yaml

envsubst < docker-compose.yaml > docker-compose.yaml.tmp && mv docker-compose.yaml.tmp docker-compose.yaml
docker compose up -d
