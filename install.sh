#!/bin/bash
# MonoMono Installationsskript v1.0

# Finde den passenden Installationsort
INSTALL_DIR="/usr/local/bin"

# Prüfe, ob das Verzeichnis existiert und schreibbar ist
if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "❌ Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden oder keine Schreibrechte."
  echo "   Bitte führe das Skript mit 'sudo' aus oder erstelle das Verzeichnis manuell."
  exit 1
fi

echo "Installiere MonoMono-Befehle nach $INSTALL_DIR..."

# Stelle sicher, dass die Quelldateien existieren
if [ ! -f "bin/monomono" ] || [ ! -f "bin/monomono-update" ] || [ ! -f "bin/monomono-disconnect" ]; then
    echo "❌ Fehler: Eine der benötigten Skript-Dateien im 'bin'-Ordner wurde nicht gefunden."
    exit 1
fi

# Kopiere alle drei ausführbaren Skripte
cp bin/monomono "$INSTALL_DIR/monomono"
cp bin/monomono-update "$INSTALL_DIR/monomono-update"
cp bin/monomono-disconnect "$INSTALL_DIR/monomono-disconnect"

# Mache sie ausführbar
chmod +x "$INSTALL_DIR/monomono"
chmod +x "$INSTALL_DIR/monomono-update"
chmod +x "$INSTALL_DIR/monomono-disconnect"

echo "✅ MonoMono erfolgreich installiert!"
echo "Du kannst jetzt die Befehle 'monomono', 'monomono-update' und 'monomono-disconnect' von überall in deinem Terminal ausführen."