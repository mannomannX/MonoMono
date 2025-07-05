#!/bin/bash
# ==============================================================================
# MonoMono Installationsskript v3.2 (final)
# ==============================================================================
INSTALL_DIR="/usr/local/bin"

if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "❌ Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden..." >&2
  exit 1
fi

echo "Installiere MonoMono-Befehle nach $INSTALL_DIR..."
# Wir installieren jetzt vier Befehle
for cmd in monomono monomono-connect monomono-update monomono-upgrade monomono-disconnect; do
    if [ ! -f "bin/$cmd" ]; then
        echo "❌ Fehler: 'bin/$cmd' nicht gefunden." >&2; exit 1
    fi
    cp "bin/$cmd" "$INSTALL_DIR/$cmd"
    chmod +x "$INSTALL_DIR/$cmd"
done

echo "✅ MonoMono erfolgreich installiert!"