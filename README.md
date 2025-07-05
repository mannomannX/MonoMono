# MonoMono  आसान

> "So good, they named it twice."

**MonoMono** is a simple yet powerful command-line tool that helps you mirror multiple, related Git repositories into a single "fusion repo." It's perfect for projects where the frontend, backend, and other services are developed in separate repos, but you need a central, always up-to-date overview.

---

## ✨ Features

* **Interactive Wizard:** A guided process (`monomono`) that walks you through the entire setup—from selecting repos to configuring update methods.
* **Flexible Synchronization:** Choose the update method that fits your needs:
    * **Manual:** Trigger an update anytime with a simple command (`monomono-update`).
    * **Scheduled:** Let the fusion repo update automatically at a predefined interval (e.g., hourly, daily).
    * **Real-time (Power-User):** Set up an "action-to-action" bridge that instantly updates the fusion repo as soon as you push to any of your sub-repos.
* **Intelligent Setup:** Automatically installs dependencies (`gh`, `fzf`, `jq`) and uses a robust configuration that works reliably even in special environments like GitHub Codespaces.
* **Full Control:** Decide whether your new fusion repo should be **public** or **private** during creation.
* **Clean Management:** Dedicated commands for updating (`monomono-update`) and cleanly disconnecting all links and configurations (`monomono-disconnect`).
* **Secure:** Uses GitHub-recommended authentication methods (Personal Access Tokens & Repository Secrets).

## 🚀 Getting Started

### Prerequisites

Before you begin, make sure the following command-line tools are installed. If not, the `monomono` wizard will guide you through the installation on its first run.

* [**GitHub CLI (`gh`)**](https://cli.github.com/)
* [**fzf (fuzzy finder)**](https://github.com/junegunn/fzf)
* [**jq (JSON processor)**](https://stedolan.github.io/jq/)

### Installation & Usage

The recommended method is to clone the repository and run the scripts directly. This is the most robust approach, especially in cloud environments like Codespaces.

```bash
# 1. Clone the MonoMono repository
git clone [https://github.com/mannomannX/MonoMono.git](https://github.com/mannomannX/MonoMono.git)

# 2. Navigate into the project directory
cd MonoMono

# 3. Make the scripts executable (one-time setup)
chmod +x ./bin/monomono
chmod +x ./bin/monomono-update
chmod +x ./bin/monomono-disconnect
```

After this setup, you can run the commands from the main project directory.

## ⚙️ How to Use

#### Create a New Fusion Repo
The main command launches the interactive wizard that guides you through the entire process.

```bash
./bin/monomono
```

#### Manually Update an Existing Fusion Repo
This command is useful when you want to force an immediate synchronization. It must be run from within the directory of the cloned fusion repo.

```bash
# Example
monomono-update
```
*(Note: If you use the optional `install.sh` file to install the commands globally, you can run this command from anywhere.)*

#### Cleanly Disconnect a Fusion Repo
This script removes all configurations created by MonoMono (trigger workflows and secrets) from your sub-repos and optionally asks if you want to delete the fusion repo itself.

```bash
./bin/monomono-disconnect
```

---

## How It Works

MonoMono leverages the **GitHub CLI** and the **GitHub API** to create and manage repositories. The core of the system is a **GitHub Actions Workflow** that is installed in the fusion repo. This workflow is responsible for cloning the contents of the sub-repos and keeping the fusion repo up to date.

For real-time synchronization, an **action-to-action bridge** is built: a tiny "trigger workflow" is placed in the sub-repos, which sends a message to the main workflow in the fusion repo upon a `push`, thus initiating the synchronization process.
