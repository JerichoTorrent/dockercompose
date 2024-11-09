#!/bin/sh

echo "Please enter the tunnel token:"
read -s tunneltoken
echo ""

export tunneltoken=$tunneltoken
export path=${PWD}/prometheus.yml

if ! command -v docker &> /dev/null; then
    echo "Docker not found, installing..."
    curl -fsSL https://get.docker.com/ -o docker.sh
    chmod +x docker.sh
    ./docker.sh
else
    echo "Docker is already installed."
fi

curl http://cdn.craftsupport.dev/api/cdn/download/docs/grafprom.yaml -o docker-compose.yaml
curl https://raw.githubusercontent.com/prometheus/prometheus/refs/heads/main/documentation/examples/prometheus.yml -o prometheus.yml
envsubst < docker-compose.yaml > docker-compose.yaml.tmp && mv docker-compose.yaml.tmp docker-compose.yaml
docker compose up -d
