#!/bin/bash

set -e

# Change to project root directory
cd "$(dirname "$0")/.."

APP_NAME="LogsTokenizer"
TARGET_ARG=""
TARGET_DIR="target/release"

if [ -n "$1" ]; then
    TARGET_ARG="--target $1"
    TARGET_DIR="target/$1/release"
fi

APP_DIR="$TARGET_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "Building release binary..."
cargo build --release $TARGET_ARG

echo "Creating App Bundle structure..."
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "Copying binary..."
cp "$TARGET_DIR/logstokenizer" "$MACOS_DIR/$APP_NAME"

echo "Generating icons..."
ICONSET_DIR="/tmp/$APP_NAME.iconset"
mkdir -p "$ICONSET_DIR"

# Create a temporary SVG with a dark grey background and white icon for better visibility
TMP_SVG="/tmp/${APP_NAME}_icon.svg"
sed 's/fill="#666666"/fill="#FFFFFF"/g' src/ico/ico.svg \
  | sed 's|<svg width="16" height="16" viewBox="0 0 16 16"|<svg width="20" height="20" viewBox="0 0 20 20"|' \
  | sed 's|<svg[^>]*>|& <rect width="20" height="20" rx="4" fill="#333333"/><g transform="translate(2, 2)">|' \
  | sed 's|</svg>|</g></svg>|' > "$TMP_SVG"

# Convert SVG to high-res PNG first
sips -s format png "$TMP_SVG" -z 1024 1024 --out /tmp/base_icon.png > /dev/null

# Generate required icon sizes
sips -z 16 16     /tmp/base_icon.png --out "$ICONSET_DIR/icon_16x16.png" > /dev/null
sips -z 32 32     /tmp/base_icon.png --out "$ICONSET_DIR/icon_16x16@2x.png" > /dev/null
sips -z 32 32     /tmp/base_icon.png --out "$ICONSET_DIR/icon_32x32.png" > /dev/null
sips -z 64 64     /tmp/base_icon.png --out "$ICONSET_DIR/icon_32x32@2x.png" > /dev/null
sips -z 128 128   /tmp/base_icon.png --out "$ICONSET_DIR/icon_128x128.png" > /dev/null
sips -z 256 256   /tmp/base_icon.png --out "$ICONSET_DIR/icon_128x128@2x.png" > /dev/null
sips -z 256 256   /tmp/base_icon.png --out "$ICONSET_DIR/icon_256x256.png" > /dev/null
sips -z 512 512   /tmp/base_icon.png --out "$ICONSET_DIR/icon_256x256@2x.png" > /dev/null
sips -z 512 512   /tmp/base_icon.png --out "$ICONSET_DIR/icon_512x512.png" > /dev/null
sips -z 1024 1024 /tmp/base_icon.png --out "$ICONSET_DIR/icon_512x512@2x.png" > /dev/null

iconutil -c icns "$ICONSET_DIR" -o "$RESOURCES_DIR/AppIcon.icns"
rm -rf "$ICONSET_DIR"
rm /tmp/base_icon.png

echo "Copying Info.plist..."
cp Info.plist "$CONTENTS_DIR/Info.plist"

echo "Signing App Bundle..."
codesign --force --deep --sign - "$APP_DIR"

echo "Done! App Bundle created at $APP_DIR"
