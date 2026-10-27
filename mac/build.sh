#!/bin/bash
# Builds Ideate.app from the web page in ../index.html.
#   ./build.sh            build into mac/build/Ideate.app
#   ./build.sh --install  also copy it to ~/Applications
set -euo pipefail
cd "$(dirname "$0")"

swift build -c release
BIN="$(swift build -c release --show-bin-path)/Ideate"

APP="build/Ideate.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources/web"
cp "$BIN" "$APP/Contents/MacOS/Ideate"
cp Info.plist "$APP/Contents/Info.plist"
cp ../index.html "$APP/Contents/Resources/web/index.html"

if [ -f icon/icon-1024.png ]; then
  ICONSET="build/AppIcon.iconset"
  rm -rf "$ICONSET"; mkdir -p "$ICONSET"
  for s in 16 32 128 256 512; do
    sips -z $s $s icon/icon-1024.png --out "$ICONSET/icon_${s}x${s}.png" >/dev/null
    d=$((s * 2))
    sips -z $d $d icon/icon-1024.png --out "$ICONSET/icon_${s}x${s}@2x.png" >/dev/null
  done
  iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"
fi

# Ad-hoc signature so it runs on this Mac. Sharing it needs a Developer ID instead.
codesign --force --deep -s - "$APP"
echo "Built $(pwd)/$APP"

if [ "${1:-}" = "--install" ]; then
  mkdir -p "$HOME/Applications"
  rm -rf "$HOME/Applications/Ideate.app"
  cp -R "$APP" "$HOME/Applications/"
  echo "Installed to $HOME/Applications/Ideate.app"
fi
