#!/usr/bin/env bash

source "$HOME/AI/TARS/config/paths.sh"


build_agents() {

    AGENTS_FILE="$PWD/AGENTS.md"

    cat > "$AGENTS_FILE" <<EOF
# TARS Context

Este arquivo foi gerado automaticamente pelo TARS.

Utilize este contexto como orientação operacional para esta sessão.

---

EOF

    cat "$TARS_CACHE/current_context.md" >> "$AGENTS_FILE"

    cat >> "$AGENTS_FILE" <<EOF

---

Fim do contexto carregado pelo TARS.

EOF

    echo "$AGENTS_FILE"
}
