{
  #home.language = {
  #  "ru_RU.UTF8"
  #};
  accounts.email.accounts = {
    alex = {
       address = "alexei_sylver1@mail.ru";
    };
  };

  programs.bash.enableCompletion = true;
  programs.gnome-terminal = {
    use-transparent-background = true;
    use-theme-transparency = true;
    background-transparency-percent = 40;
};

  environment.interactiveShellInit = ''
    export PATH="$PATH:$HOME/bin"
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/on \1/'
    }
    echo_tmux_title() {
        printf "\033k`whoami`@`pwd`:\033\\"
    }
    PS1="$PS1\[\e[0;33;49m\]\$(parse_git_branch)\[\e[0;0m\]\$(echo_tmux_title)\n$ "
    # append history instead of overwrite
    shopt -s histappend
    # big history, record everything
    # export HISTCONTROL=   #ignoredups:erasedups  # no duplicate entries
    export HISTSIZE=
    export HISTFILESIZE=
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    #tmux attach || tmux new
  '';
}
