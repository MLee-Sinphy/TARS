#!/usr/bin/env bash

get_current_model() {
    cat "$TARS_HOME/models/current"
}


get_model_by_index() {
    local INDEX="$1"

    grep "^$INDEX|" "$TARS_HOME/models/available" | cut -d "|" -f3
}
