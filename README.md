# Docker Compose  

This repo contains several installation scripts and docker-compose configuration files to install server management tools for game servers. This repo contains installation scripts for pelican panel, pterodactyl panel, wings, and grafana + prometheus. Installation is simple, and modular depending on what you want to install.

# Pterodactyl & Wings  

Create a directory in your file system for the docker compose file and scripts. Name it whatever you want, for example `mkdir panel`. `cd` into the new directory. You will then create new files to copy the scripts and docker-compose file into new files.
`nano docker-compose.yaml`
Copy the contents of `pterowings.yaml` into this file, save, then exit.
`nano script.sh`
Copy the contents of `pterowings.sh` into this file, save, then exit.
`nano docker.sh`
Copy the contents of https://github.com/docker/docker-install/blob/master/install.sh into this file, save, then exit.

Your docker container is not quite ready to build as you need to generate your Cloudflare Zero Trust token. Head to this link and generate a token: https://dash.cloudflare.com/profile/api-tokens

Once your token is generated, you are ready to build the containers and follow the prompts that appear in your terminal. Once that is complete, head to your panel URL and create your node. It is recommended, though to my knowledge not absolutely necessary, to use a different FQDN for wings. All you have to do for this is head to the [Cloudflare Dashboard](https://dash.cloudflare.com) and click on Zero Trust. In the tunnels section, configure your tunnel with a new public hostname (wings.example.com); the service will be `http://wings:8080`. Then, you can use your hostname as your FQDN in the node.
>[!NOTE]
>Select "Use SSL Connection", since Cloudflare will handle SSL. Select "Behind Proxy" and change the Daemon Port on the right side of the screen to 443 (http).

## Databases  

At this point, your node creation should be successful, and you can move on to creating the database host, allocations, and servers just like you would with a normal pterodactyl install. However, it is necessary to set ownership to the webserver user so the container will write to logs. Without it you will not be able to create databases either.
`cd` into the folder with `docker-compose.yaml` and execute `docker compose exec panel chown -R nginx: /app/storage/logs/`
As of the time of this message, you will also need to add two lines to `docker-compose.yaml`:
In between APP_ENV and APP_ENVIRONMENT_ONLY, add:
```
      HASHIDS_SALT: <characters> # generate 20 unique alphanumeric characters. If using special characters, put it in quotes
      HASHIDS_LENGTH: 8
```
Always take your docker stack down before editing `docker-compose.yaml`: `docker compose down` then after editing, `docker compose up -d`
Now you can create databases in your panel, both client and admin, without errors if done correctly.

To connect plugins to the database you created in the panel, use `127.0.0.1` as the endpoint. If you're trying to connect a plugin to the database on the server that's on a different machine, or another application (like Litebans-php for example,) use the **public IP** of the machine the database server is hosted on. Port 3306 will already be published in the docker container, but you also need to expose the port with `ufw allow 3306`.

# Blueprint

If you want to use [Blueprint](https://blueprint.zip) extensions, we need to yet again modify the docker-compose file.
`nano docker-compose.yaml`
Add the following lines under mounts:
```
      - "/srv/pterodactyl/extensions/:/blueprint_extensions"
      - "app:/app"
```
Change the panel image to `ghcr.io/blueprintframework/blueprint:v1.11.10`
`docker compose up -d`

Now Blueprint should work. You can upload extensions to `/srv/pterodactyl/extensions` using wget. Then cd back into the directory with the containers. You can install extensions with `docker compose exec panel blueprint -i <extension-name>`
