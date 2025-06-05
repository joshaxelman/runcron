#!/bin/bash

set -e

URL="https://runcron.com/runcron.sh"
INSTALL_DIR="$HOME/bin"
TARGET="$INSTALL_DIR/runcron"

mkdir -p "$INSTALL_DIR"
curl -fsSL "$URL" -o "$TARGET"
chmod 755 "$TARGET"

echo "✅ Installed to $TARGET"
echo "Make sure $INSTALL_DIR is in your PATH!"
