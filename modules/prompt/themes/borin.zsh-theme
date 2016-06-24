# Borin Prompt
# It's a clone of the sorin prompt from prezto
# based on Anish Athalye async prompt

setopt prompt_subst # enable command substition in prompt

function prompt_cmd() {
  echo "lprompt"
}

function rprompt_cmd() {
  echo "rprompt"
}

PROMPT='$(prompt_cmd)' # single quotes to prevent immediate execution
RPROMPT='' # no initial prompt, set dynamically

ASYNC_PROC=0
function precmd() {
    function async() {
        # save to temp file
        printf "%s" "$(rprompt_cmd)" > "${HOME}/.zsh_tmp_prompt"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
       # kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    RPROMPT="$(cat ${HOME}/.zsh_tmp_prompt)"
    rm "${HOME}/.zsh_tmp_prompt"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}
