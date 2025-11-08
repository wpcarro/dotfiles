let
  sources = import ./third_party/sources/sources.nix;
  depot = import sources.depot { };
  pkgs = depot.third_party.nixpkgs // { inherit depot; };
  
  dotfiles = pkgs.lib.fix (self: {
    simple_emacs = import ./simple_emacs { inherit pkgs; };
    simple_vim = import ./simple_vim { inherit pkgs; };

    path = pkgs.lib.makeBinPath (with pkgs; [
      age
      atuin 
      cargo
      clang-tools
      coreutils 
      curl
      direnv 
      emacs
      entr
      fd
      findutils 
      fzf 
      gawk 
      gh
      git
      gitui
      gnugrep 
      gnused 
      gnutar 
      gzip
      hexyl
      hostname
      httpie
      jq
      jsonnet
      less
      netcat
      # nix
      nmap
      openssh
      ripgrep 
      tcpdump
      tokei
      tree
      tshark
      vim
      which
      wrk
      zellij
      self.simple_emacs
      self.simple_vim
    ]);
    # NOTE: This is all a bit insane in PS1, Bash needs \[ and \]
    # around non-printing chars for proper readline behavior. Here is
    # a breakdown of some of the codes:
    #   - \e: Bash shorthand for ASCII escape (octal=\033, hex=\x1B)
    #   - [:  Introduces a control sequence
    colors = let
      wrap = code: x: ''\[\e[${toString code}m\]${x}\[\e[0m\]'';
    in {
      red     = wrap 31;
      green   = wrap 32;
      yellow  = wrap 33;
      blue    = wrap 34;
      magenta = wrap 35;
      cyan    = wrap 36;
    };
    bashrc = pkgs.writeText "bashrc" ''
      export PATH=${self.path}:${if true then "/opt/homebrew/bin:$PATH" else "$PATH"}

      alias m='cd ~/programming/matrix'
      alias base='cd ~/programming/base'

      alias depot='cd ~/programming/depot'
      alias dotfiles='cd ~/programming/dotfiles'

      alias eb='vim ~/programming/dotfiles/default.nix'
      alias sb='nix-env -f ~/programming/dotfiles -iA dotfiles.shell && exec billsh'
      alias la='ls -al'
      alias rgh='rg --hidden'
      alias tpr='tput reset'

      alias gst='git status'
      alias gd='git diff'
      alias gco='git checkout'
      alias gcb='git checkout -b'
      alias gprom='git pull --rebase origin main'
      alias gfrom='git rebase -i --autosquash origin/main'
      alias grbc='git rebase --continue'
      alias grh='git reset --hard'
      alias glp='git log --graph --oneline --decorate-refs=r/ --decorate-refs=refs/remotes/origin/'
      alias gpf='git push --force'
      alias gcan='git commit --amend --no-edit --no-verify'
      alias gca='git commit --amend --no-verify'
      alias gcf='git commit --fixup --no-verify'
      alias gcp='git cherry-pick'
      alias gds='git diff --staged'
      alias gsh='git show HEAD'
      alias gc='git commit'
      alias gp='git push'
      alias gpr='gh pr create --title="$(git log -1 --format=%s)" --body="$(git log -1 --format=%b)"'

      alias vim='simple_vim'
      export EDITOR=${depot.users.wpcarro.tools.simple_vim}/bin/simple_vim
      export GIT_EDITOR=$EDITOR

      # apps
      eval "$(direnv hook bash)"
      source $HOME/.nix-profile/etc/profile.d/nix.sh
      source ${pkgs.bash-preexec}/share/bash/bash-preexec.sh
      eval "$(atuin init bash)"

      # sensitive cleartext
      [ -f $HOME/secrets.sh ] && source $HOME/secrets.sh

      # prompt
      fmt_git_branch() {
        x=$(git branch --show-current 2>/dev/null)
        [ -n "$x" ] && printf "[%s]" "$x"
      }
      export PS1='${self.colors.red "["}${self.colors.blue "\\u"}${self.colors.yellow "@"}${self.colors.magenta "\\h"}${self.colors.red "]"} ${self.colors.cyan "\\w"} $(fmt_git_branch)\n\t ${self.colors.yellow "λ"} '
    '';

    shell = pkgs.writeShellScriptBin "billsh" ''
      exec ${pkgs.bashInteractive}/bin/bash --rcfile ${self.bashrc}
    '';
  });
in
{
  inherit pkgs dotfiles;
}
