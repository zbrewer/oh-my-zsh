function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
  print -D $PWD
}

function battery_charge() {
  if [ -e ~/bin/battery.py ]
  then
    echo `python2 ~/bin/battery.py`
  else
    echo ''
  fi
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi

  local bat=$(battery_charge)
  if [ ${#bat} != 0 ]; then
    ((bat = ${#bat} - 18))
  else
    bat=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${bat} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} " 
  done
  echo $spacing
}

PROMPT='%F{cyan}%m: %F{yellow}$(get_pwd)
%f→ '

RPROMPT='$(git_prompt_info) $(battery_charge)'

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}+"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}"
