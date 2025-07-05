#!/bin/bash
# ==============================================================================
# MonoMono Upgrade-Skript v1.0
# Aktualisiert den Workflow in einem bestehenden Fusions-Repo.
# ==============================================================================
CONFIG_FILE="$HOME/.monomono_config"

# Funktion zur PAT-Abfrage, falls nicht in der Config gefunden
ensure_pat() {
    if [ -f "$CONFIG_FILE" ]; then source "$CONFIG_FILE"; fi
    if [ -z "$MONOMONO_PAT" ]; then
        echo "--------------------------------------------------------------------"
        echo "🔑 INFO: Ein persönlicher Zugriffstoken (PAT) wird für die Authentifizierung benötigt."
        echo "‼️  AKTION ERFORDERLICH: Öffne https://github.com/settings/tokens/new"
        echo "   Anleitung: Wähle die Scopes 'repo' UND 'workflow' aus, generiere den Token und kopiere ihn."
        echo "--------------------------------------------------------------------"
        PAT_INPUT=""
        while [ -z "$PAT_INPUT" ]; do
            read -s -p "👉 Bitte füge den kopierten Token hier ein und drücke ENTER: " PAT_INPUT; echo
        done
        
        echo "-> Überprüfe den Access Token..."
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $PAT_INPUT" https://api.github.com/user)
        if [ "$HTTP_STATUS" -ne 200 ]; then echo "❌ FEHLER: Der Token ist ungültig (HTTP-Status: $HTTP_STATUS)." >&2; exit 1; fi
        
        echo "✔ Access Token ist gültig."
        echo "MONOMONO_PAT='$PAT_INPUT'" >> "$CONFIG_FILE"
        MONOMONO_PAT=$PAT_INPUT
    fi
    export GH_TOKEN=$MONOMONO_PAT
    echo "✔ Authentifizierung für diese Sitzung gesetzt."
}

# --- HAUPTLOGIK ---
echo "MonoMono Workflow Upgrade Assistent"
echo "-------------------------------------"
read -p "? Welches Fusions-Repo soll aktualisiert werden? (user/repo): " FUSION_REPO
if [ -z "$FUSION_REPO" ]; then echo "❌ Fehler: Eingabe darf nicht leer sein."; exit 1; fi

ensure_pat

# Logik, um die Sub-Repos aus der alten Workflow-Datei zu extrahieren
echo "-> Lese aktuelle Konfiguration aus dem Repo..."
TEMP_DIR=$(mktemp -d)
git clone "https://x-access-token:$MONOMONO_PAT@github.com/$FUSION_REPO.git" "$TEMP_DIR" >/dev/null 2>&1 || { echo "❌ Fehler beim Klonen des Repos."; rm -rf "$TEMP_DIR"; exit 1; }

WORKFLOW_FILE_PATH="$TEMP_DIR/.github/workflows/sync.yml"
if [ ! -f "$WORKFLOW_FILE_PATH" ]; then
    echo "❌ Fehler: Konnte keine 'sync.yml' im angegebenen Repository finden."
    rm -rf "$TEMP_DIR"
    exit 1
fi

SUB_REPOS_LINE=$(grep -m 1 'REPOS_TO_SYNC=' "$WORKFLOW_FILE_PATH")
SUB_REPOS=$(echo "$SUB_REPOS_LINE" | sed -e "s/.*inputs.repos || '//" -e "s/' *}}//")
if [ -z "$SUB_REPOS" ]; then
    echo "❌ Fehler: Konnte die Sub-Repo-Liste nicht aus dem bestehenden Workflow lesen."
    rm -rf "$TEMP_DIR"
    exit 1
fi
echo "✔ Gefundene Sub-Repos: $SUB_REPOS"

# Ab hier verwenden wir die gleiche Logik wie in `monomono`, um den neuen Workflow zu generieren
echo "-> Generiere den neuesten Workflow..."
# Extrahiere die alten Trigger, um sie beizubehalten
ON_TRIGGERS=$(sed -n '/^on:/,/^jobs:/p' "$WORKFLOW_FILE_PATH" | sed '$d')
WORKFLOW_NAME="Fusion-Repo Erstellen & Aktualisieren"

read -r -d '' NEW_WORKFLOW_CONTENT << EOM
name: '$WORKFLOW_NAME'
$ON_TRIGGERS
jobs:
  sync-repos:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Checkout fusion repo
        uses: actions/checkout@v4
        with:
          token: \${{ secrets.ACCESS_TOKEN }}
      - name: Clone sub-repos
        run: |
          git config --global url."https://x-access-token:\${{ secrets.ACCESS_TOKEN }}@github.com/".insteadOf "https://github.com/"
          REPOS_TO_SYNC=\${{ inputs.repos || '$SUB_REPOS' }}
          for repo in \$(echo "\$REPOS_TO_SYNC" | sed 's/,/ /g'); do
            folder_name=\$(basename \$repo)
            echo "-> Cloning \$repo into \$folder_name..."
            rm -rf "\$folder_name"
            git clone --depth 1 https://github.com/\$repo.git "\$folder_name" && rm -rf "\$folder_name/.git"
          done
      - name: Create intelligent README
        run: |
          sudo apt-get update && sudo apt-get install -y tree
          echo "# 🤖 MonoMono Fusions-Repo" > README.md
          echo "" >> README.md
          echo "Dieses Repository ist eine automatisch generierte und synchronisierte Zusammenführung mehrerer einzelner Repositories, erstellt von [MonoMono](https://github.com/mannomannX/MonoMono)." >> README.md
          echo "Es dient als zentraler Überblick und für übergreifende Analysen." >> README.md
          echo "" >> README.md
          echo "---" >> README.md
          echo "" >> README.md
          echo "## 🗺️ Projekt-Map" >> README.md
          echo "" >> README.md
          echo "### 🧩 Projekt-Komponenten" >> README.md
          echo "Die folgenden Ordner sind die eigentlichen Projekt-Komponenten. Jede ist ein Klon eines eigenständigen Sub-Repos:" >> README.md
          for repo in \$(echo "\${{ inputs.repos || '$SUB_REPOS' }}" | sed 's/,/ /g'); do
            echo "- **[\$(basename \$repo)](./\$(basename \$repo))** (Original: [\$repo](https://github.com/\$repo))" >> README.md
          done
          echo "" >> README.md
          echo "### 🛠️ MonoMono-Infrastruktur" >> README.md
          echo "Die folgenden Dateien und Ordner sind Teil der MonoMono-Automatisierung und nicht Teil der Kernprojekte:" >> README.md
          echo "- **[.github/workflows/sync.yml](./.github/workflows/sync.yml)**: Der GitHub Actions Workflow, der dieses Repo aktuell hält." >> README.md
          echo "" >> README.md
          echo "### 🌳 Visuelle Verzeichnisstruktur" >> README.md
          echo \`\`\` >> README.md
          tree -L 2 -I 'README.md' >> README.md
          echo \`\`\` >> README.md
          echo "" >> README.md
          echo "> Letzte Aktualisierung: \$(date)" >> README.md
      - name: Commit and push changes
        run: |
          git config --global user.name 'github-actions[bot]'
          git config --global user.email 'github-actions[bot]@users.noreply.github.com'
          git add .
          if ! git diff-index --quiet HEAD; then
            git commit -m "feat(workflow): Upgrade MonoMono sync logic"
            git push
          else
            echo "No changes to workflow found."
          fi
EOM

echo -e "$NEW_WORKFLOW_CONTENT" > "$WORKFLOW_FILE_PATH"
cd "$TEMP_DIR" || exit
git add .github/workflows/sync.yml
git commit -m "feat(workflow): Upgrade MonoMono sync logic"
git push
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo "✅ Workflow für '$FUSION_REPO' erfolgreich auf die neueste Version aktualisiert!"
echo "   Führe 'monomono-update $FUSION_REPO' aus, um die Änderungen (wie die neue README) zu sehen."