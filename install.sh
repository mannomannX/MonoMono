#!/bin/bash
# ==============================================================================
# MonoMono Installationsskript v2.0 (intelligent & robust)
# ==============================================================================

# Finde den Pfad, in dem das install.sh-Skript selbst liegt.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Der systemweite Installationsordner für die Befehle
INSTALL_DIR="/usr/local/bin"
# Der zentrale "Heimatordner" für Konfigurations- und Hilfsdateien
MONOMONO_HOME="$HOME/.monomono"

# Erstelle den Heimatordner
mkdir -p "$MONOMONO_HOME/lib"

if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "❌ Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden oder keine Schreibrechte." >&2
  echo "   Bitte führe das Skript mit 'sudo' aus." >&2
  exit 1
fi

echo "Installiere MonoMono nach $INSTALL_DIR und richte den Heimatordner in $MONOMONO_HOME ein..."

# Speichere den Pfad zum Projekt-Root in einer Konfigurationsdatei
echo "MONOMONO_PROJECT_ROOT='$SCRIPT_DIR'" > "$MONOMONO_HOME/config"

# Kopiere die Hilfsdateien in den Heimatordner
cp "$SCRIPT_DIR/lib/i18n.sh" "$MONOMONO_HOME/lib/i18n.sh"
cp "$SCRIPT_DIR/monomono-trigger.yml" "$MONOMONO_HOME/monomono-trigger.yml"

# Kopiere die ausführbaren Skripte in den Systempfad
for cmd in monomono monomono-update monomono-disconnect; do
    if [ ! -f "$SCRIPT_DIR/bin/$cmd" ]; then
        echo "❌ Fehler: Die Skript-Datei '$SCRIPT_DIR/bin/$cmd' wurde nicht gefunden." >&2
        exit 1
    fi
    cp "$SCRIPT_DIR/bin/$cmd" "$INSTALL_DIR/$cmd"
    chmod +x "$INSTALL_DIR/$cmd"
done

echo "✅ MonoMono erfolgreich installiert!"
echo "Du kannst jetzt die Befehle 'monomono', 'monomono-update' und 'monomono-disconnect' von überall ausführen."