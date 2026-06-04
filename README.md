# Samba in Docker

Samba file server in a Docker container. Manages user creation automatically via environment variables.

## Docker Compose

Copy the template below into a `docker-compose.yml` file.

```yaml
services:
  samba:
    container_name: samba
    image: ghcr.io/madhukraft/samba:latest
    # network_mode: host  # uncomment if you want IP whitelisting via hosts allow in smb.conf
    ports:
      - 445:445
      - 139:139
    volumes:
      - ./smb.conf:/etc/samba/smb.conf
      - ./share1:/mnt/share1 # change ./share1 to the path of the folder you want to share
      - ./share2:/mnt/share2
    environment:
      - user_count=2
      - user1=admin
      - password1=changeme
      - user2=john
      - password2=changeme
    restart: unless-stopped
```

## Volumes & Shares

Your host directories are mapped into the container under `/mnt/`. The `smb.conf` file then references those `/mnt/` paths.

For example, if you map `./share1:/mnt/share1`, you set `path = /mnt/share1` in your `smb.conf`. You can place the host directories anywhere on your system, they just need to be mounted somewhere under `/mnt/` inside the container.

## smb.conf

Create a `smb.conf` file in the same directory as the `docker-compose.yml` file. Here's a minimal template to get started:

```ini
[global]
workgroup = WORKGROUP
server role = standalone server
map to guest = never
log file = /var/log/samba/log.%m
max log size = 1000
logging = file

# Optional: restrict access by IP (requires network_mode: host in compose.yml)
# hosts allow = 192.168.1.2 192.168.1.3 192.168.1.4
# hosts deny = ALL

# Optional: enforce encryption (SMB3 clients only)
# smb encrypt = required
# server signing = mandatory

[Admin_Share]
path = /mnt/share1
valid users = admin
write list = admin

[My_Media]
path = /mnt/share2
valid users = john admin
write list = john admin
```

## Running the container

```bash
docker compose up -d
```

## Connecting

**Linux:** Open any file manager and click on the netowrk section → `smb://<your-server-ip>/Share Name`

**macOS:** Right click on Finder → Connect to Server → `smb://<your-server-ip>/Share Name`

**Windows:** Open File Explorer and navigate to `\\<your-server-ip>\Share Name`

> `Share Name` is the section heading from your `smb.conf` (e.g. `Admin_Share`, `My_Media`)
