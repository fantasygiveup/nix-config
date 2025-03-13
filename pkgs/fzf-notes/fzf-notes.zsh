#!/usr/bin/env zsh

# Copyright (c) 2025 Illia Danko

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# TODO: do not define the fallback global variables.
[ -z "${FZF_NOTES_DIRECTORY-}" ] && FZF_NOTES_DIRECTORY="$HOME/github.com/fantasygiveup/zettelkasten"
[ -z "${FZF_NOTES_PREVIEW_LINES_COUNT-}" ] && FZF_NOTES_PREVIEW_LINES_COUNT="14"
[ -z "${FZF_NOTES_PREVIEWER-}" ] && FZF_NOTES_PREVIEWER="fzf-notes-previewer"
[ -z "${FZF_NOTES_PREVIEW_WINDOW-}" ] && FZF_NOTES_PREVIEW_WINDOW="nohidden|hidden,down"
[ -z "${FZF_NOTES_PREVIEW_COLUMNS_THRESHOLD-}" ] && FZF_NOTES_PREVIEW_COLUMNS_THRESHOLD="160"
[ -z "${FZF_NOTES_PROMPT-}" ] && FZF_NOTES_PROMPT='Notes> '
[ -z "${FZF_NOTES_COPY_COMMAND-}" ] && FZF_NOTES_COPY_COMMAND="$CLIPBOARD_COPY_COMMAND"
[ -z "${FZF_NOTES_CMD-}" ] && FZF_NOTES_CMD="rg \
    --no-column \
    --line-number \
    --no-heading \
    --color=always \
    --colors='match:none' \
    --smart-case \
    -- '\S'"
local copy_key=${FZF_NOTES_COPY_KEY:-alt-w}
local new_note_key=${FZF_NOTES_NEW_NOTE_KEY:-ctrl-o}

# Ensure precmds are run after cd.
function _fzf_notes_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N _fzf_notes_redraw_prompt

function _fzf_notes_preview {
    local states=("${(s[|])FZF_NOTES_PREVIEW_WINDOW}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_NOTES_PREVIEW_WINDOW}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_NOTES_PREVIEW_WINDOW}" && return
    [ $(tput cols) -lt "${FZF_NOTES_PREVIEW_COLUMNS_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function _fzf_notes_new_entry {
    mkdir -p $(dirname ${FZF_NOTES_DIRECTORY}/$1)
    $EDITOR ${FZF_NOTES_DIRECTORY}/$1
}

function _fzf_notes_jump {
    file=$(cut -d':' -f1 <<< "$1")
    column=$(cut -d':' -f2 <<< "$1")
    # vim compatible editor.
    $EDITOR +$column ${FZF_NOTES_DIRECTORY}/$file
}

function _fzf_notes {
    local lines=$(eval ${FZF_NOTES_CMD} ${FZF_NOTES_DIRECTORY} | \
        ${FZF_NOTES_PREVIEWER} -ns ${FZF_NOTES_DIRECTORY} | fzf \
        --prompt "${FZF_NOTES_PROMPT}" \
        --print-query \
        --ansi \
        --delimiter=":" \
        --multi \
        --query="$*" \
        --expect="$new_note_key" \
        --bind "${copy_key}:execute-silent(echo -n {3..} | ${FZF_NOTES_COPY_COMMAND})" \
        --header="${copy_key}:copy, ${new_note_key}:new" \
        --preview="${FZF_NOTES_PREVIEWER} -np ${FZF_NOTES_DIRECTORY} {1} {2} ${FZF_NOTES_PREVIEW_LINES_COUNT}" \
        --preview-window=$(_fzf_notes_preview) \
    )
    if [[ -z "$lines" ]]; then
        zle && zle _fzf_notes_redraw_prompt
        return 1
    fi

    local key="$(head -n2 <<< "$lines" | tail -n1)"
    if [[ "$key" == "$new_note_key" ]]; then
        _fzf_notes_new_entry "$(head -n1 <<< "${lines}")"
    else
        _fzf_notes_jump "$(tail -n1 <<< "${lines}")"
    fi
    zle && zle _fzf_notes_redraw_prompt || true
}

zle -N _fzf_notes
