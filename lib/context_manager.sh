#!/usr/bin/env bash

find_context_files() {

    CURRENT_DIR="$(pwd)"

    while [[ "$CURRENT_DIR" != "/" ]]; do

        if [[ -f "$CURRENT_DIR/.tars" ]]; then
            echo "$CURRENT_DIR/.tars"
        fi

        CURRENT_DIR="$(dirname "$CURRENT_DIR")"

    done
}

build_context() {

    CONTEXT_FILE="$TARS_HOME/context/cache/current_context.md"

    > "$CONTEXT_FILE"

    find_context_files | tac | while read FILE
    do
        echo "# Contexto: $FILE" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"

        cat "$FILE" >> "$CONTEXT_FILE"

        echo "" >> "$CONTEXT_FILE"
        echo "---" >> "$CONTEXT_FILE"
        echo "" >> "$CONTEXT_FILE"
    done


    echo "$CONTEXT_FILE"
}
