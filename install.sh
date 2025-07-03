#!/bin/bash
# MonoMono Installationsskript v1.1

INSTALL_DIR="/usr/local/bin"
# Der neue, zentrale "Heimatordner" für Konfigurations- und Hilfsdateien
MONOMONO_HOME="$HOME/.monomono"

# Erstelle den Heimatordner
mkdir -p "$MONOMONO_HOME/lib"

if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "❌ Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden oder keine Schreibrechte." >&2
  echo "   Bitte führe das Skript mit 'sudo' aus." >&2
  exit 1
fi

echo "Installiere MonoMono nach $INSTALL_DIR und richte den Heimatordner in $MONOMONO_HOME ein..."

# Kopiere die Hilfsdateien in den Heimatordner
cp lib/i18n.sh "$MONOMONO_HOME/lib/i18n.sh"
cp monomono-trigger.yml "$MONOMONO_HOME/monomono-trigger.yml"

# Kopiere die ausführbaren Skripte in den Systempfad
for cmd in monomono monomono-update monomono-disconnect; do
    if [ ! -f "bin/$cmd" ]; then
        echo "❌ Fehler: Die Skript-Datei 'bin/$cmd' wurde nicht gefunden." >&2
        exit 1
    fi
    cp "bin/$cmd" "$INSTALL_DIR/$cmd"
    chmod +x "$INSTALL_DIR/$cmd"
done

echo "✅ MonoMono erfolgreich installiert!"