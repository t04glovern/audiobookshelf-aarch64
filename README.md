# Audiobookshelf Docker Setup

Self-hosted audiobook and podcast server running on ARM64 (Raspberry Pi/similar).

## Quick Start

1. **Adjust the configuration** in `docker-compose.yml`:
   - Update `TZ` to your timezone
   - Modify volume paths if your audiobooks/podcasts are stored elsewhere
   - Optionally set `user: "UID:GID"` to run as a specific user (run `id` to get your UID/GID)

2. **Create the data directories**:
   ```bash
   mkdir -p audiobooks podcasts config metadata
   ```

3. **Build and start the container**:
   ```bash
   docker compose up -d --build
   ```
   
   > ⚠️ **Note**: The first build will take a while (10-30+ minutes on a Pi) as it compiles from source.

4. **Access the web UI**:
   - Open http://<your-device-ip>:13378
   - Create your admin account on first visit

## Managing the Container

```bash
# View logs
docker compose logs -f audiobookshelf

# Stop the container
docker compose down

# Rebuild (after updates)
docker compose build --no-cache
docker compose up -d

# Update to latest version
docker compose pull  # Won't work since we're building locally
docker compose build --pull --no-cache  # This forces a fresh build
docker compose up -d
```

## Volumes

| Path in Container | Purpose |
|-------------------|---------|
| `/audiobooks` | Your audiobook library |
| `/podcasts` | Your podcast library |
| `/config` | Database and configuration |
| `/metadata` | Cached metadata, covers, etc. |

You can add more library volumes by adding entries like:
```yaml
- /path/to/more/books:/library2
```

## Network Access

The server runs on port **13378** by default. To access from other devices on your network, use your device's IP address.

Find your IP with:
```bash
hostname -I
```

## Troubleshooting

### Build fails
- Ensure you have enough disk space (2GB+ recommended)
- Check Docker is properly installed: `docker --version`
- Try building with more verbose output: `docker compose build --progress=plain`

### Container won't start
- Check logs: `docker compose logs audiobookshelf`
- Verify volume permissions if using a specific user

### Performance
- Initial library scans can be slow on ARM devices
- Consider using a faster storage device (SSD vs SD card)
