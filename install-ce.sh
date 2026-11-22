#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then echo "Run as root: curl -fsSL https://obsydia.tech/install-ce.sh | sudo bash" >&2; exit 1; fi
[ -r /etc/os-release ] && . /etc/os-release
case "${ID:-}:${VERSION_ID:-}" in
  ubuntu:22.04|ubuntu:24.04) ;;
  *) case " ${ID_LIKE:-} " in
       *" ubuntu "*) echo "Warning: ${PRETTY_NAME:-this system} is not officially supported. Community Edition is tested on Ubuntu 22.04 and 24.04 LTS." >&2 ;;
       *) echo "Unsupported system: ${PRETTY_NAME:-unknown}. Community Edition requires Ubuntu 22.04 or 24.04 LTS." >&2; exit 1 ;;
     esac ;;
esac
set -e

cat << 'BANNER'

  ██████╗ ██████╗ ███████╗██╗   ██╗██████╗ ██╗ █████╗
 ██╔═══██╗██╔══██╗██╔════╝╚██╗ ██╔╝██╔══██╗██║██╔══██╗
 ██║   ██║██████╔╝███████╗ ╚████╔╝ ██║  ██║██║███████║
 ██║   ██║██╔══██╗╚════██║  ╚██╔╝  ██║  ██║██║██╔══██║
 ╚██████╔╝██████╔╝███████║   ██║   ██████╔╝██║██║  ██║
  ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═╝

  Core0 Community Edition  ·  Data that doesn't exist can't be stolen.
  ─────────────────────────────────────────────────────────────

BANNER

INSTALL_PATH="/usr/local/bin/obsydia-connector-ce"
RELEASE_BASE="https://updates.obsydia.tech/public/connector-ce"
WAS_CONFIGURED=0
if [ -f /etc/obsydia/connector.json ]; then WAS_CONFIGURED=1; fi

echo "  [1/3] Downloading Connector (Community Edition)..."
META=$(curl -fsSL "${RELEASE_BASE}/latest.json") || { echo "  ERROR: could not fetch release information. Aborting." >&2; exit 1; }
CE_VERSION=$(printf '%s' "$META" | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)".*/\1/p')
CE_SHA256=$(printf '%s' "$META" | sed -n 's/.*"sha256"[[:space:]]*:[[:space:]]*"\([0-9a-f]\{64\}\)".*/\1/p')
if [ -z "$CE_VERSION" ] || [ -z "$CE_SHA256" ]; then
  echo "  ERROR: invalid release information. Aborting." >&2
  exit 1
fi
echo "        version ${CE_VERSION}"
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
curl -fSL --progress-bar "${RELEASE_BASE}/${CE_VERSION}/linux-amd64" -o "$TMP"
GOT=$(sha256sum "$TMP" | cut -d' ' -f1)
if [ "$GOT" != "$CE_SHA256" ]; then
  echo "  ERROR: checksum mismatch for ${CE_VERSION} (expected ${CE_SHA256}, got ${GOT}). Nothing was changed. Aborting." >&2
  exit 1
fi
echo "        sha256 verified"
systemctl stop obsydia-connector-ce 2>/dev/null || true
sleep 1
mv "$TMP" "$INSTALL_PATH"
chmod 755 "$INSTALL_PATH"
echo "  [1/3] Done."

echo "  [2/3] Installing systemd service..."
cat > /etc/systemd/system/obsydia-connector-ce.service << 'UNIT'
[Unit]
Description=Obsydia Connector (Community Edition)
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/bin/sh -c '/usr/local/bin/obsydia-connector-ce >> /var/log/obsydia-connector-ce.log 2>&1'
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable obsydia-connector-ce
systemctl restart obsydia-connector-ce
echo "  [2/3] Done."

echo "  [3/3] Starting Connector..."
sleep 2
IP=$(hostname -I | awk '{print $1}')
echo "  [3/3] Done."

if [ "$WAS_CONFIGURED" = 1 ]; then
  echo ""
  echo "  ─────────────────────────────────────────────────────────────"
  echo "  ✓ Obsydia Connector (Community Edition) updated to ${CE_VERSION}."
  echo ""
  echo "  Configuration and data were kept. Open the panel:"
  echo ""
  echo "    https://$IP:8443/"
  echo ""
else
cat << 'FOOTER'

  ─────────────────────────────────────────────────────────────
  ✓ Obsydia Connector (Community Edition) is running.

  Next step — open the installation wizard in your browser:

FOOTER
echo "    https://$IP:8443/installer"
echo ""
echo "  Have your license.json and 24h update token from the signup email ready."
echo ""
fi
