# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Extension point (for further customization without changing this file).
if [ -f ~/.bashrc_ext ]; then
  . ~/.bashrc_ext
fi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# Infinite history.
HISTSIZE=
HISTFILESIZE=

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

git_prompt() {
  modified=""
  added=""
  deleted=""
  untracked=""
  tmp_ifs=$IFS
  IFS=$'\n'
  for line in $(git status --porcelain 2> /dev/null); do
    if [[ ${line:0:2} == "??" ]]; then
      untracked="?"
      continue
    fi
    for c in ${line:0:1} ${line:1:1}; do
      case $c in
        "M")
          modified="*"
          ;;
        "A")
          added="+"
          ;;
        "D")
          deleted="-"
          ;;
        "R")
          added="+"
          deleted="-"
          ;;
        "C")
          added="+"
          ;;
      esac
    done
  done
  IFS=$tmp_ifs
  # Start dark green coloring.
  PS1+='\[\e[0;32m\]'
  # Note: using sed to add parentheses instead of printf prevents them from
  # showing up when we're *not* on a git branch.  There might be a cleaner way
  # to do this, but this one is simple enough and works.
  PS1+=$(git rev-parse --abbrev-ref HEAD 2> /dev/null | xargs printf "%s$modified$added$deleted$untracked" | sed -e 's/\(.*\)/\(\1\)/')
  # End dark green coloring.
  PS1+='\[\e[m\]'
}

if [[ "${#PROMPT_SEGMENTS[@]}" -eq 0 ]]; then
  declare -a PROMPT_SEGMENTS=(
      'git_prompt'
      # Add more by overriding PROMPT_SEGMENTS.
      # For example,
      # declare -a PROMPT_SEGMENTS=(
      #   'ext_prompt'
      #   'git_prompt'
      # )
  )
fi

prompt_command() {
  if [ "$color_prompt" = yes ]; then
    # Explanation of formatting:
    # \e[{color_code}m to start coloring.
    # \e[1m starts bold.
    # \e[1;{color_code}m starts bold and coloring.
    # \e[0m resets formatting.
    # Where {color_code} is a color.  32 is dark green, 34 is dark blue.
    PS1='${debian_chroot:+($debian_chroot)}\[\e[1;34m\]\u@\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]'
    for segment in "${PROMPT_SEGMENTS[@]}"; do
      "$segment"
    done
    PS1+='\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
    for segment in "${PROMPT_SEGMENTS[@]}"; do
      "$segment"
    done
    PS1+='\$ '
  fi
}

unset PROMPT_COMMAND
PROMPT_COMMAND=prompt_command

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Kill the terrible extension-based filename completions from bash_completion.
_filedir_xspec() {
  _minimal $@
}

export PATH=$PATH:$HOME/bin
export EDITOR="vi"

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# -----------------------------------------------------------------------------
# Function definitions that should respect aliases:
# -----------------------------------------------------------------------------

# Easily start/attach to grouped tmux sessions.
#   $1 - base session/group name
#   $2 - sub-session name
tm() {
  tmux has-session -t ${1} &> /dev/null
  if [ $? != 0 ]; then
    tmux new-session -d -s ${1}
  fi
  tmux new-session -A -t ${1} -s ${1}-${2}
}
