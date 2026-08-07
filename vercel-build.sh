#!/usr/bin/env bash
set -e

FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR" --depth 1
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --enable-web --no-analytics
flutter pub get
flutter build web --release
