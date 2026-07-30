#!/usr/bin/env bash

###############################################################################
# Model Manager
#
# Responsável pelo gerenciamento dos modelos do TARS.
#
###############################################################################

MODELS_FILE="$TARS_HOME/models/available"
CURRENT_MODEL_FILE="$TARS_HOME/models/current"


get_current_model() {
    cat "$CURRENT_MODEL_FILE"
}


get_model_by_index() {
    local INDEX="$1"

    grep "^$INDEX|" "$MODELS_FILE" | cut -d "|" -f3
}


get_model_by_alias() {
    local ALIAS="$1"

    grep "|$ALIAS|" "$MODELS_FILE" | cut -d "|" -f3
}


resolve_model() {
    local INPUT="$1"

    if [[ "$INPUT" =~ ^[0-9]+$ ]]; then
        get_model_by_index "$INPUT"
    else
        get_model_by_alias "$INPUT"
    fi
}

list_models() {
    echo "TARS Models"
    echo "==========="
    echo ""

    printf "%-4s %-18s %-35s %s\n" "ID" "ALIAS" "MODELO" "DESCRIÇÃO"
    printf "%-4s %-18s %-35s %s\n" "--" "-----" "------" "----------"

    while IFS="|" read -r ID ALIAS MODEL DESCRIPTION
    do
        # Ignora linhas vazias
        [[ -z "$ID" ]] && continue

        # Ignora comentários
        [[ "$ID" =~ ^# ]] && continue

        printf "%-4s %-18s %-35s %s\n" \
            "$ID" \
            "$ALIAS" \
            "$MODEL" \
            "$DESCRIPTION"

    done < "$MODELS_FILE"

    echo ""
    echo "Modelo atual:"
    echo "$(get_current_model)"
}

set_default_model() {
    local MODEL="$1"

    echo "$MODEL" > "$CURRENT_MODEL_FILE"
}

update_default_model() {
    local INPUT="$1"
    local MODEL

    MODEL=$(resolve_model "$INPUT")

    if [[ -z "$MODEL" ]]; then
        echo "Modelo não encontrado: $INPUT"
        return 1
    fi

    set_default_model "$MODEL"

    echo "Modelo padrão atualizado:"
    echo "$MODEL"
}
