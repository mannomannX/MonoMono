#!/bin/bash
# MonoMono Installationsskript

# Finde den passenden Installationsort
# /usr/local/bin ist Standard für macOS/Linux
INSTALL_DIR="/usr/local/bin"

# Prüfe, ob das Verzeichnis existiert und schreibbar ist
if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden oder keine Schreibrechte."
  echo "Bitte führe das Skript mit sudo aus oder erstelle das Verzeichnis manuell."
  exit 1
fi

echo "Installiere MonoMono-Befehle nach $INSTALL_DIR..."

# Kopiere die ausführbaren Skripte
cp bin/monomono "$INSTALL_DIR/monomono"
cp bin/monomono-update "$INSTALL_DIR/monomono-update"
cp bin/monomono-cleanup "$INSTALL_DIR/monomono-cleanup"

# Mache sie ausführbar
chmod +x "$INSTALL_DIR/monomono"
chmod +x "$INSTALL_DIR/monomono-update"
chmod +x "$INSTALL_DIR/monomono-cleanup"

echo "✅ MonoMono erfolgreich installiert!"
echo "Du kannst jetzt die Befehle 'monomono', 'monomono-update' und 'monomono-cleanup' von überall in deinem Terminal ausführen."