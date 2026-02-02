#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPSTREAM_DIR="$SCRIPT_DIR/upstream"
BUILD_DIR="$SCRIPT_DIR/build"

echo "=== Audiobookshelf ARM64 Build Setup ==="

# Check submodule is initialized
if [ ! -f "$UPSTREAM_DIR/Dockerfile" ]; then
    echo "Error: Submodule not initialized. Run: git submodule update --init"
    exit 1
fi

# Create build directory
echo "Creating build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy upstream source to build directory
echo "Copying upstream source..."
cp -r "$UPSTREAM_DIR"/* "$BUILD_DIR"/

# Copy our custom Dockerfile that works on ARM64
echo "Copying ARM64-compatible Dockerfile..."
cp "$SCRIPT_DIR/Dockerfile.arm64" "$BUILD_DIR/Dockerfile"

echo "Build directory prepared at: $BUILD_DIR"
echo ""
echo "To build and run:"
echo "  docker compose up -d --build"
