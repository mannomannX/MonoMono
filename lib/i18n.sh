#!/bin/bash
# Internationalization (i18n) Strings for MonoMono

setup_language() {
  LANGUAGE="en" # Standard ist Englisch
  if [[ "$LANG" == "de"* ]]; then
    LANGUAGE="de"
  fi

  # Textbausteine definieren
  if [[ "$LANGUAGE" == "de" ]]; then
    # Deutsche Texte
    TEXT_PROMPT_USERNAME="? Bitte gib deinen GitHub-Benutzernamen ein: "
    TEXT_PROMPT_FUSION_NAME="? Wie soll das neue Fusions-Repo heißen? "
    TEXT_PROMPT_SCHEDULE="? Möchtest du einen automatischen, zeitgesteuerten Sync aktivieren? (j/n) "
    TEXT_PROMPT_SCHEDULE_HOURS="? In welchem Intervall (in Stunden) soll der Sync laufen? (1-24) "
    TEXT_PROMPT_WEBHOOKS="? Sollen Webhooks für Echtzeit-Updates eingerichtet werden? (j/n) "
    TEXT_ALL_DONE="✅ Alles erledigt! Dein Fusions-Repo wird jetzt befüllt."
    # ... weitere Texte hier ...
  else
    # Englische Texte
    TEXT_PROMPT_USERNAME="? Please enter your GitHub username: "
    TEXT_PROMPT_FUSION_NAME="? What should the new fusion repo be named? "
    TEXT_PROMPT_SCHEDULE="? Do you want to enable an automatic, scheduled sync? (y/n) "
    TEXT_PROMPT_SCHEDULE_HOURS="? At what interval (in hours) should the sync run? (1-24) "
    TEXT_PROMPT_WEBHOOKS="? Set up webhooks for real-time updates? (y/n) "
    TEXT_ALL_DONE="✅ All done! Your fusion repo is now being populated."
    # ... more texts here ...
  fi
}