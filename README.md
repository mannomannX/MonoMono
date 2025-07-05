# MonoMono  आसान

> "So good, they named it twice."

**MonoMono** ist ein einfaches, aber mächtiges Kommandozeilen-Tool, das dir hilft, mehrere zusammengehörige Git-Repositories in einem einzigen "Fusions-Repo" zu spiegeln. Perfekt für Projekte, bei denen Frontend, Backend und andere Dienste in getrennten Repos entwickelt werden, du aber eine zentrale, stets aktuelle Gesamtansicht benötigst.

---

## ✨ Features

* **Interaktiver Assistent:** Ein geführter Prozess (`monomono`), der dich durch die gesamte Einrichtung führt – von der Auswahl der Repos bis zur Konfiguration der Update-Methoden.
* **Flexible Synchronisierung:** Wähle die für dich passende Update-Methode:
    * **Manuell:** Stoße ein Update jederzeit per Befehl an (`monomono-update`).
    * **Zeitgesteuert:** Lass das Fusions-Repo automatisch in einem von dir festgelegten Intervall (z.B. stündlich, täglich) aktualisieren.
    * **Echtzeit (Power-User):** Richte eine "Action-zu-Action"-Brücke ein, die das Fusions-Repo sofort aktualisiert, sobald du etwas in eines deiner Sub-Repos pushst.
* **Intelligente Einrichtung:** Automatische Installation von Abhängigkeiten (`gh`, `fzf`, `jq`) und eine robuste Konfiguration, die auch in speziellen Umgebungen wie GitHub Codespaces funktioniert.
* **Volle Kontrolle:** Entscheide bei der Erstellung, ob dein Fusions-Repo **öffentlich** oder **privat** sein soll.
* **Sauberes Management:** Eigene Befehle zum Aktualisieren (`monomono-update`) und zum sauberen Trennen aller Verbindungen und Konfigurationen (`monomono-disconnect`).
* **Sicher:** Verwendet von GitHub empfohlene Methoden zur Authentifizierung (Personal Access Tokens & Repository Secrets).

## 🚀 Erste Schritte

### Voraussetzungen

Bevor du loslegst, stelle sicher, dass die folgenden Kommandozeilen-Tools auf deinem System installiert sind. Falls nicht, wird dich der `monomono`-Assistent bei der ersten Ausführung durch die Installation führen.

* [**GitHub CLI (`gh`)**](https://cli.github.com/)
* [**fzf (fuzzy finder)**](https://github.com/junegunn/fzf)
* [**jq (JSON processor)**](https://stedolan.github.io/jq/)

### Installation & Ausführung

Die empfohlene Methode ist, das Repository zu klonen und die Skripte direkt auszuführen. Das ist die robusteste Methode, besonders in Cloud-Umgebungen wie Codespaces.

```bash
# 1. Klone das MonoMono-Repository
git clone [https://github.com/mannomannX/MonoMono.git](https://github.com/mannomannX/MonoMono.git)

# 2. Navigiere in den Projektordner
cd MonoMono

# 3. Mache die Skripte ausführbar (nur einmalig nötig)
chmod +x ./bin/monomono
chmod +x ./bin/monomono-update
chmod +x ./bin/monomono-disconnect
```

Danach kannst du die Befehle immer aus dem Hauptverzeichnis des Projekts ausführen.

## ⚙️ Verwendung

#### Ein neues Fusions-Repo erstellen
Der Hauptbefehl startet den interaktiven Assistenten, der dich durch den gesamten Prozess führt.

```bash
./bin/monomono
```

#### Ein bestehendes Fusions-Repo manuell aktualisieren
Dieser Befehl ist nützlich, wenn du eine sofortige Synchronisierung erzwingen möchtest. Er muss aus dem Verzeichnis des geklonten Fusions-Repos ausgeführt werden.

```bash
# Beispiel
monomono-update
```
*(Hinweis: Wenn du die optionale `install.sh`-Datei verwendest, um die Befehle global zu installieren, kannst du diesen Befehl von überall aus nutzen.)*


#### Eine Verbindung sauber trennen
Dieses Skript entfernt alle von MonoMono erstellten Konfigurationen (Trigger-Workflows und Secrets) aus deinen Sub-Repos und fragt dich optional, ob auch das Fusions-Repo selbst gelöscht werden soll.

```bash
./bin/monomono-disconnect
```

---

## Wie es funktioniert

MonoMono nutzt die **GitHub CLI** und die **GitHub API**, um Repositories zu erstellen und zu verwalten. Das Herzstück ist ein **GitHub Actions Workflow**, der im Fusions-Repo installiert wird. Dieser Workflow ist dafür verantwortlich, die Inhalte der Sub-Repos zu klonen und das Fusions-Repo aktuell zu halten.

Für die Echtzeit-Synchronisierung wird eine **Action-zu-Action-Brücke** gebaut: Ein winziger "Trigger-Workflow" wird in den Sub-Repos platziert, der bei einem `push` eine Nachricht an den Haupt-Workflow im Fusions-Repo sendet und so den Synchronisierungsprozess anstößt.
