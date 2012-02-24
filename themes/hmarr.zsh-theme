ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="(D)"
ZSH_THEME_GIT_PROMPT_UNTRACKED="(U)"
ZSH_THEME_GIT_PROMPT_CLEAN="(C)"

ZSH_GIT_STAGED="%{%F{cyan}%}+%{$reset_color%}"
ZSH_GIT_CHANGES="%{%F{yellow}%}*%{$reset_color%}"
ZSH_GIT_INIT="#"

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

git_dirtyness() {
    if [ "true" != "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        return
    fi

    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo -n $ZSH_THEME_GIT_PROMPT_PREFIX
    echo -n "${ref#refs/heads/}"
    echo -n $ZSH_THEME_GIT_PROMPT_SUFFIX

    echo -n ' '

    git diff --no-ext-diff --quiet --exit-code || echo -n $ZSH_GIT_CHANGES
    if git rev-parse --quiet --verify HEAD >/dev/null; then
        git diff-index --cached --quiet HEAD -- || echo -n $ZSH_GIT_STAGED
    else
        echo -n $ZSH_GIT_INIT
    fi
}

function rvm_info() {
    GEMSET=`echo $GEM_HOME| egrep -o '@[A-Za-z0-9_-]+' | cut -c 2-`
    if [[ -n $GEMSET ]]; then
        echo "[$GEMSET] "
    fi
}

PROMPT_DIR='%{$fg_bold[magenta]%}%c%{$reset_color%}'

PROMPT="$PROMPT_DIR %(?,%{$fg[green]%},%{$fg[red]%})⚡%{$reset_color%} "
RPROMPT='%{$fg_bold[yellow]%}$(rvm_info)$(virtualenv_info)%{$reset_color%}$(git_dirtyness)'
