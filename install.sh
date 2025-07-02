#!/bin/bash
# MonoMono Installationsskript

INSTALL_DIR="/usr/local/bin"

if [ ! -d "$INSTALL_DIR" ] || [ ! -w "$INSTALL_DIR" ]; then
  echo "❌ Fehler: Installationsverzeichnis $INSTALL_DIR nicht gefunden oder keine Schreibrechte."
  exit 1
fi

echo "Installiere MonoMono-Befehle nach $INSTALL_DIR..."

# Kopiere alle drei ausführbaren Skripte
cp bin/monomono "$INSTALL_DIR/monomono"
cp bin/monomono-connect "$INSTALL_DIR/monomono-connect"
cp bin/monomono-disconnect "$INSTALL_DIR/monomono-disconnect"

# Mache sie ausführbar
chmod +x "$INSTALL_DIR/monomono"
chmod +x "$INSTALL_DIR/monomono-connect"
chmod +x "$INSTALL_DIR/monomono-disconnect"

echo "✅ MonoMono erfolgreich installiert!"
echo "Du kannst jetzt die Befehle 'monomono', 'monomono-connect' und 'monomono-disconnect' von überall in deinem Terminal ausführen."