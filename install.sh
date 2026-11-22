#!/bin/sh
set -e

cat << 'BANNER'

  ██████╗ ██████╗ ███████╗██╗   ██╗██████╗ ██╗ █████╗ 
 ██╔═══██╗██╔══██╗██╔════╝╚██╗ ██╔╝██╔══██╗██║██╔══██╗
 ██║   ██║██████╔╝███████╗ ╚████╔╝ ██║  ██║██║███████║
 ██║   ██║██╔══██╗╚════██║  ╚██╔╝  ██║  ██║██║██╔══██║
 ╚██████╔╝██████╔╝███████║   ██║   ██████╔╝██║██║  ██║
  ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═╝

  Core0 Installer  ·  Data that doesn't exist can't be stolen.
  ─────────────────────────────────────────────────────────────

BANNER

INSTALL_PATH="/usr/local/bin/obsydia-connector"
UPDATES="https://updates.obsydia.tech"

echo "  [1/3] Downloading Connector..."
META=$(curl -fsSL "${UPDATES}/versions.json") || { echo "  ERROR: could not fetch release information. Aborting." >&2; exit 1; }
ENTRY=$(printf '%s' "$META" | tr -d '\n\r' | sed -n 's/.*"connector"[[:space:]]*:[[:space:]]*{\([^}]*\)}.*/\1/p')
CONNECTOR_VERSION=$(printf '%s' "$ENTRY" | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)".*/\1/p')
CONNECTOR_SHA256=$(printf '%s' "$ENTRY" | sed -n 's/.*"sha256"[[:space:]]*:[[:space:]]*"\([0-9a-f]\{64\}\)".*/\1/p')
if [ -z "$CONNECTOR_VERSION" ] || [ -z "$CONNECTOR_SHA256" ]; then
  echo "  ERROR: invalid release information. Aborting." >&2
  exit 1
fi
echo "        version ${CONNECTOR_VERSION}"
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
curl -fSL --progress-bar "${UPDATES}/public/connector/${CONNECTOR_VERSION}/linux-amd64" -o "$TMP"
GOT=$(sha256sum "$TMP" | cut -d' ' -f1)
if [ "$GOT" != "$CONNECTOR_SHA256" ]; then
  echo "  ERROR: checksum mismatch for connector ${CONNECTOR_VERSION}. Nothing was installed." >&2
  exit 1
fi
systemctl stop obsydia-connector 2>/dev/null || true
sleep 1
install -m 0755 "$TMP" "$INSTALL_PATH"
echo "  [1/3] Done."

echo "  [2/3] Installing systemd service..."
cat > /etc/systemd/system/obsydia-connector.service << 'UNIT'
[Unit]
Description=Obsydia Connector
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/bin/sh -c '/usr/local/bin/obsydia-connector >> /var/log/obsydia-connector.log 2>&1'
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable obsydia-connector
systemctl restart obsydia-connector
echo "  [2/3] Done."

echo "  [3/3] Starting Connector..."
sleep 2
IP=$(hostname -I | awk '{print $1}')
TOKEN=""
INSTALLED=""
if [ -f /etc/obsydia/connector.json ]; then
  INSTALLED=1
else
  i=0
  while [ "$i" -lt 15 ] && [ ! -s /etc/obsydia/install-token ]; do
    sleep 1
    i=$((i + 1))
  done
  TOKEN=$(cat /etc/obsydia/install-token 2>/dev/null || true)
fi
echo "  [3/3] Done."

cat << 'FOOTER'

  ─────────────────────────────────────────────────────────────
  ✓ Obsydia Connector is running.

  Next step — open the installation wizard in your browser:

FOOTER
if [ -n "$INSTALLED" ]; then
  echo "    This machine already holds a Core0 installation."
  echo "    Manage it in the admin panel: https://$IP:8443/"
  echo ""
  exit 0
fi
echo "    https://$IP:8443/installer"
echo ""
if [ -n "$TOKEN" ]; then
  echo "  Installer access code (the wizard asks for it once):"
  echo ""
  echo "    $TOKEN"
  echo ""
  echo "  Keep it to yourself: whoever holds it can drive the installer."
  echo "  It is also in /etc/obsydia/install-token (root only) and is removed"
  echo "  when the installation completes."
else
  echo "  WARNING: the connector has not created an installer access code yet." >&2
  echo "  Read it later with: cat /etc/obsydia/install-token" >&2
  echo "  If it does not appear, see /var/log/obsydia-connector.log" >&2
fi
echo ""
echo "  Have your license.json ready."
echo ""
