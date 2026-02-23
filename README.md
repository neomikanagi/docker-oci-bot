## 1. Infrastructure Preparation (Run once only)

```bash
mkdir -p /docker/oci-bot
```

## 2. Deploy and Start the Container

pulls the latest image from GitHub Container Registry.

```bash
docker run -d \
  --name oci-bot \
  --restart always \
  --log-driver json-file \
  --log-opt max-size=2m \
  --log-opt max-file=1 \
  -e TZ=Asia/Tokyo \
  -v /docker/oci-bot:/app \
  ghcr.io/neomikanagi/docker-oci-bot:latest
```
key_file=/app/
