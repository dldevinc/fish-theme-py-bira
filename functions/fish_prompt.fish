function __user_host
  set -l content 
  if [ (id -u) = "0" ];
    echo -n (set_color --bold red)
  else
    echo -n (set_color --bold green)
  end
  echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __current_path
  echo -n (set_color --bold blue) (pwd) (set_color normal) 
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function __git_status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '<'$git_branch"*"'>'
    else
      set git_info '<'$git_branch'>'
    end

    if test -n "$git_info"
      echo -n (set_color yellow)$git_info (set_color normal)
    end
  end
end

function __python_version
  if type "python3" > /dev/null 2>&1
    set python_version (python3 -V | cut -d ' ' -f2)
    echo -n (set_color red)‹$python_version› (set_color normal)
  else if type "python" > /dev/null 2>&1
    set python_version (python -V | cut -d ' ' -f2)
    echo -n (set_color red)‹$python_version› (set_color normal)
  end
end

function __last_status
  echo -n (set_color --bold magenta)\(status: $argv[1]\) (set_color normal)
end

function fish_prompt
  set -l st $status

  echo -n (set_color white)"╭─"(set_color normal)
  __user_host
  __current_path
  __python_version
  __git_status
  __last_status $st
  echo ''
  echo (set_color white)"╰─"(set_color --bold white)"\$ "(set_color normal)
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo (set_color red) ↵ $st(set_color normal)
  end
end
