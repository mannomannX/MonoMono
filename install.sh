#!/bin/bash
# ==============================================================================
# MonoMono Installationsskript v3.0 (final & einfach)
# ==============================================================================
INSTALL_DIR="/usr/local/bin"

if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "❌ Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden oder keine Schreibrechte." >&2
  echo "   Bitte führe das Skript mit 'sudo' aus." >&2
  exit 1
fi

echo "Installiere MonoMono-Befehle nach $INSTALL_DIR..."

# Kopiere alle ausführbaren Skripte in den Systempfad
for cmd in monomono monomono-update monomono-disconnect; do
    # Wir nehmen an, dass das install.sh aus dem Projekt-Root ausgeführt wird
    if [ ! -f "bin/$cmd" ]; then
        echo "❌ Fehler: Die Skript-Datei 'bin/$cmd' wurde nicht gefunden." >&2
        echo "   Bitte führe das Skript aus dem MonoMono-Hauptverzeichnis aus." >&2
        exit 1
    fi
    cp "bin/$cmd" "$INSTALL_DIR/$cmd"
    chmod +x "$INSTALL_DIR/$cmd"
done

echo "✅ MonoMono erfolgreich installiert!"
echo "Du kannst jetzt die Befehle 'monomono', 'monomono-update' und 'monomono-disconnect' von überall ausführen."