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

# Search for local git projects using fd(find) and fzf commands.

[ -x "$(command -v fdir)" ] && cmd="fdir"
[ -z "${FZF_PROJECT_ROOT_DIRS-}" ] && FZF_PROJECT_ROOT_DIRS="$HOME"
[ -z "${FZF_PROJECT_PATTERNS-}" ] && FZF_PROJECT_PATTERNS=".git"
[ -z "${FZF_PROJECT_STATIC_DIRS-}" ] && FZF_PROJECT_STATIC_DIRS="$HOME/Downloads $HOME/Documents $HOME/Videos $HOME/Music $HOME/Pictures $HOME/Desktop"
[ -z "${FZF_PROJECT_CMD-}" ] && FZF_PROJECT_CMD="$cmd ${FZF_PROJECT_ROOT_DIRS[@]} --patterns ${FZF_PROJECT_PATTERNS[@]} --static ${FZF_PROJECT_STATIC_DIRS[@]}"
[ -z "${FZF_PROJECT_COLORS-}" ] && FZF_PROJECT_COLORS="0"
[ -z "${FZF_PROJECT_MATCH_COLOR_FG-}" ] && FZF_PROJECT_MATCH_COLOR_FG="34"
[ -z "${FZF_PROJECT_PREVIEW_CONFIG-}" ] && FZF_PROJECT_PREVIEW_CONFIG="nohidden|hidden,down"
[ -z "${FZF_PROJECT_PREVIEW_THRESHOLD-}" ] && FZF_PROJECT_PREVIEW_THRESHOLD="160"
[ -z "${FZF_PROJECT_PROMPT-}" ] && FZF_PROJECT_PROMPT='Projects> '

# Ensure precmds are run after cd.
function fzf_project_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N fzf_project_redraw_prompt

function _fzf_project_color {
    [ "${FZF_PROJECT_COLORS-}" -eq "0" ] && cat && return
    local esc="$(printf '\033')"
    perl -p -e "s/(.*)/${esc}[${FZF_PROJECT_MATCH_COLOR_FG}m\1${esc}[0;0m/;"
}

function _fzf_project_preview_window {
    states=("${(s[|])FZF_PROJECT_PREVIEW_CONFIG}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_PROJECT_PREVIEW_CONFIG}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_PROJECT_PREVIEW_CONFIG}" && return
    [ $(tput cols) -lt "${FZF_PROJECT_PREVIEW_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function _fzf_project {
    local line=$(eval ${FZF_PROJECT_CMD} | \
        sort -u | \
        _fzf_project_color | \
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
            cd "$HOME/$line"
        fi
    fi

    zle && zle fzf_project_redraw_prompt || true
}

zle -N _fzf_project

bindkey ${FZF_PROJECT_TRIGGER_KEYMAP:-'^g'} _fzf_project
