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

# Apply Dockerfile patch for Python 3.12+ compatibility (distutils removed)
echo "Patching Dockerfile for ARM64/Python 3.12+ compatibility..."
sed -i 's/python3 \\/python3 \\\n  py3-setuptools \\/' "$BUILD_DIR/Dockerfile"

# Also fix the deprecated npm flag
sed -i 's/npm ci --only=production/npm ci --omit=dev/' "$BUILD_DIR/Dockerfile"

echo "Build directory prepared at: $BUILD_DIR"
echo ""
echo "To build and run:"
echo "  docker compose up -d --build"
