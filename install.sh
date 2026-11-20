#!/usr/bin/env bash
# Copy the theme into your default Firefox profile (Flatpak or regular install).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
for ROOT in "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox" "$HOME/.mozilla/firefox" "$HOME/.config/mozilla/firefox"; do
  [ -f "$ROOT/installs.ini" ] && break
done
[ -f "$ROOT/installs.ini" ] || { echo "No Firefox profile found." >&2; exit 1; }
PROFILE="$(awk -F= '/^Default=/{print $2; exit}' "$ROOT/installs.ini")"
DEST="$ROOT/$PROFILE"
mkdir -p "$DEST/chrome"
cp -v "$HERE/userChrome.css" "$HERE/userContent.css" "$DEST/chrome/"
grep -q 'legacyUserProfileCustomizations.stylesheets' "$DEST/user.js" 2>/dev/null || cat "$HERE/user.js" >> "$DEST/user.js"
echo "Done. In about:addons → Themes pick \"System theme — auto\", then restart Firefox."
