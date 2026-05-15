#!/bin/bash

# Script per automatizzare git add, commit e push
# Utilizzo: ./sync.sh "Il tuo messaggio di commit"

# Verifica se è stato fornito un messaggio di commit
if [ -z "$1" ]; then
    echo "❌ Errore: Devi inserire un messaggio per il commit tra virgolette."
    echo "Esempio: ./sync.sh 'aggiornato il layout'"
    exit 1
fi

COMMIT_MSG="$1"

# Recupera il nome del branch attuale
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -z "$BRANCH" ]; then
    echo "❌ Errore: Non sei in un repository Git o non ci sono branch."
    exit 1
fi

echo "🚀 Inizio sincronizzazione su branch: $BRANCH..."

# Aggiunge tutte le modifiche
git add .

# Controlla se ci sono modifiche da committare
if git diff-index --quiet HEAD --; then
    echo "ℹ️ Nessuna modifica rilevata da caricare."
else
    # Esegue il commit
    git commit -m "$COMMIT_MSG"
    
    # Esegue il push
    echo "📤 Caricamento su GitHub..."
    git push origin "$BRANCH"
    
    if [ $? -eq 0 ]; then
        echo "✅ Sincronizzazione completata con successo!"
    else
        echo "❌ Errore durante il push. Controlla la tua connessione o le credenziali."
    fi
fi
