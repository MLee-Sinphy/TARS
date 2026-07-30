#!/usr/bin/env bash

source "$HOME/AI/TARS/config/paths.sh"


build_prompt() {

    PROMPT_FILE="$TARS_CONTEXT/runtime_prompt.md"

    mkdir -p "$TARS_CONTEXT"

    cat > "$PROMPT_FILE" <<EOF
# TARS Runtime Context

Este arquivo contém o contexto operacional carregado pelo TARS para esta sessão.

---

EOF

    cat "$TARS_CACHE/current_context.md" >> "$PROMPT_FILE"

    cat >> "$PROMPT_FILE" <<EOF

---

# Fim do Contexto

Use estas informações como contexto operacional.
A identidade principal do agente permanece definida pelo Hermes.

EOF

    echo "$PROMPT_FILE"
}
