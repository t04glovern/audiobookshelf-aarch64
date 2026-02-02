# Audiobookshelf Docker Setup (ARM64)

Self-hosted audiobook and podcast server running on ARM64 (Raspberry Pi/similar).

This repo uses the official [audiobookshelf](https://github.com/advplyr/audiobookshelf) as a git submodule and applies patches needed for ARM64 builds.

## Quick Start

1. **Clone this repo with submodules**:
   ```bash
   git clone --recurse-submodules https://github.com/t04glovern/audiobookshelf-aarch64.git
   cd audiobookshelf-aarch64
   ```

   Or if already cloned:
   ```bash
   git submodule update --init
   ```

2. **Run the prepare script** (copies source and applies patches):
   ```bash
   ./prepare-build.sh
   ```

3. **Adjust the configuration** in `docker-compose.yml`:
   - Update `TZ` to your timezone
   - Modify volume paths if your audiobooks/podcasts are stored elsewhere
   - Optionally set `user: "UID:GID"` (run `id` to get your values)

4. **Build and start the container**:
   ```bash
   docker compose up -d --build
   ```
   
   > ⚠️ **Note**: The first build takes 15-40+ minutes on ARM as it compiles from source.

5. **Access the web UI**:
   - Open http://<your-device-ip>:13378
   - Create your admin account on first visit

## Updating

To update to the latest audiobookshelf version:

```bash
# Update the submodule to latest
cd upstream
git pull origin master
cd ..

# Re-run prepare script to apply patches
./prepare-build.sh

# Rebuild
docker compose build --no-cache
docker compose up -d
```

## What the Patch Does

The `prepare-build.sh` script applies the following fixes:

1. **Adds `py3-setuptools`** - Python 3.12+ removed the `distutils` module which `node-gyp` requires to build native modules like `sqlite3`
2. **Fixes deprecated npm flag** - Changes `--only=production` to `--omit=dev`

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
