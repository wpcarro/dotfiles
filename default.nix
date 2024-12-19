let
  sources = import ./third_party/sources/sources.nix;
  depot = import sources.depot { };
  pkgs = depot.third_party.nixpkgs // { inherit depot; };
  
  dotfiles = pkgs.lib.fix (self: {
    path = pkgs.lib.makeBinPath (with pkgs; [
      age
      coreutils 
      curl
      direnv 
      emacs
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
      hostname
      httpie
      less
      nix
      openssh
      ripgrep 
      tree
      vim
      which
      wrk
      depot.users.wpcarro.tools.simple_vim
    ]);
    colors = {
      yellow = x: "\\033[0;33m${x}\\033[0m";
      pink = x: "\\033[0;35m${x}\\033[0m";
      cyan = x: "\\033[0;36m${x}\\033[0m";
      blue = x: "\\033[0;34m${x}\\033[0m";
      red = x: "\\033[0;31m${x}\\033[0m";
      white = x: "\\033[0;37m${x}\\033[0m";
    };
    bashrc = pkgs.writeText "bashrc" ''
      export PATH=${self.path}:${if true then "/opt/homebrew/bin:$PATH" else "$PATH"}

      alias m='cd ~/programming/matrix'
      alias client='cd ~/programming/matrix/client'
      alias server='cd ~/programming/matrix/server'

      alias h='cd ~/programming/hadrian'
      alias bbom='cd ~/programming/hadrian/factory/bbom'
      alias qms='cd ~/programming/hadrian/flow/qms'

      alias d='cd ~/programming/depot'
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
      alias gprom='git pull --rebase origin HEAD'
      alias gfrom='git rebase -i --autosquash origin/main'
      alias grbc='git rebase --continue'
      alias grh='git reset --hard'
      alias glp='git log --graph --oneline --decorate-refs=r/ --decorate-refs=refs/remotes/origin/'
      alias gpf='git push --force'
      alias gcan='git commit --amend --no-edit'
      alias gca='git commit --amend'
      alias gcf='git commit --fixup'
      alias gds='git diff --staged'
      alias gsh='git show HEAD'
      alias gc='git commit'
      alias gp='git push'
      alias gpr='gh pr create --title="$(git log -1 --format=%s)" --body="$(git log -1 --format=%b)"'

      alias vim='simple_vim'
      export EDITOR=${depot.users.wpcarro.tools.simple_vim}/bin/simple_vim
      export GIT_EDITOR=$EDITOR

      # apps
      eval "$(fzf --bash)"
      eval "$(direnv hook bash)"
      source $HOME/.nix-profile/etc/profile.d/nix.sh

      # prompt
      export PS1="${self.colors.red "["}${self.colors.blue "\\u"}${self.colors.yellow "@"}${self.colors.pink "\\h"}${self.colors.red "]"} ${self.colors.cyan "\\w"}\n${self.colors.white "\\t"} ${self.colors.cyan "λ"} "
    '';

    shell = pkgs.writeShellScriptBin "billsh" ''
      exec ${pkgs.bashInteractive}/bin/bash --rcfile ${self.bashrc}
    '';
  });
in
{
  inherit pkgs dotfiles;
}
