#!/usr/bin/env zsh
# Copyright (c) 2025 Illia Danko
#

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

# Search for and navigate projects in the file system.
# Requirements: "zsh", "fzf", "fd", "xargs", "dirname", "sort", "perl", "tput", "tree".

[ -z "${FZF_PROJECT_ROOT_DIRECTORY-}" ] && FZF_PROJECT_ROOT_DIRECTORY="$HOME"
[ -z "${FZF_PROJECT_SEARCH_PATTERN-}" ] && FZF_PROJECT_SEARCH_PATTERN="'^\.git$|^\.hg$|^\.bzr$|^\.svn$'"
[ -z "${FZF_PROJECT_FD_IGNORE_FILTER-}" ] && FZF_PROJECT_FD_IGNORE_FILTER="--exclude 'vendor' --exclude 'deps' --exclude 'node_modules' --exclude 'dist' --exclude 'venv' --exclude 'elm-stuff' --exclude '.clj-kondo' --exclude '.lsp' --exclude '.cpcache' --exclude '.ccls-cache' --exclude '_build' --exclude '.elixir_ls' --exclude '.cache'"
[ -z "${FZF_PROJECT_CMD-}" ] && FZF_PROJECT_CMD="fd --hidden --case-sensitive --base-directory ${FZF_PROJECT_ROOT_DIRECTORY} "$FD_IGNORE_FILTER" --relative-path --prune ${FZF_PROJECT_SEARCH_PATTERN}"
[ -z "${FZF_PROJECT_PREVIEW_FZF_SETTINGS-}" ] && FZF_PROJECT_PREVIEW_FZF_SETTINGS="nohidden|hidden,down"
[ -z "${FZF_PROJECT_PREVIEW_COLUMNS_THRESHOLD-}" ] && FZF_PROJECT_PREVIEW_COLUMNS_THRESHOLD="160"
[ -z "${FZF_PROJECT_PROMPT-}" ] && FZF_PROJECT_PROMPT='Project> '

function fzf_project_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N fzf_project_redraw_prompt

function _fzf_project_preview_window {
    states=("${(s[|])FZF_PROJECT_PREVIEW_FZF_SETTINGS}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_PROJECT_PREVIEW_FZF_SETTINGS}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_PROJECT_PREVIEW_FZF_SETTINGS}" && return
    [ $(tput cols) -lt "${FZF_PROJECT_PREVIEW_COLUMNS_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function _fzf_project {
    local line=$(eval ${FZF_PROJECT_CMD} | \
        sort -u | \
        xargs dirname | \
        fzf \
        --ansi \
        --prompt "${FZF_PROJECT_PROMPT}" \
        --preview="tree -C -L 1 $HOME/{}" \
        --preview-window=$(_fzf_project_preview_window))

    if [ "$line" != "" ] && [ -d "$HOME/$line" ]; then
        if [ "$#" -gt 0 ]; then
            case $1 in
                '--print') printf "%s\n" "$line";;
            esac
        else
            builtin cd -- "$HOME/$line"
        fi
    fi

    zle && zle fzf_project_redraw_prompt || true
}

zle -N _fzf_project

bindkey ${FZF_PROJECT_TRIGGER_KEYMAP:-'^g'} _fzf_project
