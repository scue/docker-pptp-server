# VPN (PPTP) for Docker

This is a docker image with simple VPN (PPTP) server with chap-secrets authentication.

## Starting VPN server


docker-compose.yaml

```yaml
version: "2"

services:
  pptp-server:
    image: scue/pptp-server:0.1.0
    environment:
      - USERNAME=scue
      - PASSWORD=awesome
    privileged: yes
    ports:
      - "1723:1723"
    network_mode: "bridge"
```

```sh
docker-compose up
```

## Starting VPN client for test

docker-compose.yaml

```yaml
pptp:
  image: vimagick/pptp
  environment:
    - SERVER=172.17.0.2
    - TUNNEL=ppp0
    - USERNAME=scue
    - PASSWORD=awesome
  privileged: yes
  restart: unless-stopped
```

```sh
docker-compose up
```
