#!/bin/bash

# --- UNIVERSAL DNA SKELETONIZER (TOON 2.0 - DENSE) ---
# Version: 2026.15 | Format: High-Density Sigil Stream
# Optimized for: Token savings and LLM architectural "Recall."

TARGET_DIR="${1:-.}"
ABS_TARGET_DIR=$(cd "$TARGET_DIR" && pwd || exit 1)
PROJECT_NAME=$(basename "$ABS_TARGET_DIR")
OUTPUT_FILE="$ABS_TARGET_DIR/project_dna.toon"

detect_folder_stack() {
    local dir=$1
    if [ -f "$dir/shopify.extension.toml" ]; then echo "Shopify"
    elif [ -f "$dir/scrapy.cfg" ]; then echo "Scrapy"
    elif [ -f "$dir/Gemfile" ]; then echo "Rails"
    elif [ -f "$dir/package.json" ]; then echo "Node"
    else echo "Gen"; fi
}

extract_dna() {
    {
        # --- HEADER ---
        echo "P:$PROJECT_NAME"
        echo "S:$(detect_folder_stack "$ABS_TARGET_DIR")"
        echo "T:$(date +%s)"
        echo "---"

        find "$ABS_TARGET_DIR" -maxdepth 4 -type d \
            -not -path '*/.*' -not -path '*node_modules*' -not -path '*vendor*' -not -path '*bundle*' | sort | while read -r current_dir; do
            
            if ls -p "$current_dir" | grep -v / | grep -qv "project_dna.toon"; then
                CLEAN_DIR=$(echo "$current_dir" | sed "s|$ABS_TARGET_DIR/||")
                [ "$current_dir" == "$ABS_TARGET_DIR" ] && CLEAN_DIR="root"

                # § = Folder Start
                echo "§$CLEAN_DIR"
                
                # ! = Manifests
                find "$current_dir" -maxdepth 1 -type f \( -name "package.json" -o -name "Gemfile" -o -name "requirements.txt" -o -name "scrapy.cfg" \) | while read -r m; do
                    echo "!$(basename "$m")"
                    grep -E "^[[:space:]]*[\"']?(name|version|ruby|gem|module|import)[\"']?[:= ]" "$m" | \
                    sed -E 's/[",{}]//g' | head -n 15 | awk '{$1=$1; print "  " $0}'
                done

                # Symbol Cache for this folder
                SYM_TMP=$(mktemp)
                ctags --languages=javascript,typescript,ruby,go,rust,python \
                --ruby-kinds=+fmf --python-kinds=+fm --fields=+nK --excmd=n -f - "$current_dir"/* 2>/dev/null > "$SYM_TMP"

                # ~ = File | > = Symbol
                find "$current_dir" -maxdepth 1 -type f -not -path '*/.*' | sort | while read -r f; do
                    fname=$(basename "$f")
                    [[ "$fname" == "project_dna.toon" ]] && continue
                    echo "~$fname"
                    # We strip the path from the symbol line because it's redundant under the file header
                    awk -v file_path="$f" -F'\t' '$2 == file_path {print ">" $4 ":" $1}' "$SYM_TMP" | head -n 12
                done
                rm "$SYM_TMP"
            fi
        done
        
        echo "---"
        echo "TOKENS_EST:$(wc -w < "$OUTPUT_FILE" | awk '{print int($1 * 1.2)}')"

    } > "$OUTPUT_FILE"
}

if ! command -v ctags &>/dev/null; then echo "❌ ctags required"; exit 1; fi
extract_dna
echo "✅ TOON 2.0 (Dense) Created: $OUTPUT_FILE"
