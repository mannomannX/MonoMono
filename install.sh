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
        # Spezielle Fehlermeldung, wenn der neue Befehl fehlt
        if [ "$cmd" == "monomono-upgrade" ]; then
            echo "❌ Fehler: Die neue Skript-Datei 'bin/monomono-upgrade' wurde nicht gefunden." >&2
            echo "   Bitte erstelle die Datei mit dem bereitgestellten Code." >&2
        else
            echo "❌ Fehler: 'bin/$cmd' nicht gefunden." >&2
        fi
        exit 1
    fi
    cp "bin/$cmd" "$INSTALL_DIR/$cmd"
    chmod +x "$INSTALL_DIR/$cmd"
done

echo "✅ MonoMono erfolgreich installiert!"