let
  sources = import ./third_party/sources/sources.nix;
  depot = import sources.depot { };
  pkgs = depot.third_party.nixpkgs // { inherit depot; };

  bashrc = pkgs.writeText "bashrc" ''
    alias rgh="rg --hidden"
  '';
  
  billpkgs = pkgs.lib.fix (self: {
    bashrc = pkgs.writeText "bashrc" ''
      export PATH=${pkgs.lib.makeBinPath (with pkgs; [
        coreutils 
        direnv 
        emacs
        findutils 
        fzf 
        gawk 
        git
        gnugrep 
        gnused 
        gnutar 
        nix
        openssh
        ripgrep 
        vim
        which
      ])}

      alias m='cd ~/programming/matrix'
      alias client='cd ~/programming/matrix/client'
      alias server='cd ~/programming/matrix/server'

      alias h='cd ~/programming/hadrian'
      alias bbom='cd ~/programming/hadrian/factory/bbom'
      alias qms='cd ~/programming/hadrian/flow/qms'

      alias d='cd ~/programming/depot'

      alias eb='vim ~/programming/billpkgs/default.nix'
      alias sb='source $(nix-build ~/programming/billpkgs -A billpkgs.bashrc --no-out-link)'
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
      alias gcan='git commit --amend --no-edit'
      alias gca='git commit --amend'
      alias gcf='git commit --fixup'
      alias gds='git diff --staged'
      alias gsh='git show HEAD'
      alias gc='git commit'
      alias gp='git push'
      alias gpr='gh pr create --title="$(git log -1 --format=%s)" --body="$(git log -1 --format=%b)"'

      # apps
      eval "$(fzf --bash)"
      eval "$(direnv hook bash)"

      # prompt
      export PS1="\w\nλ "
    '';

    shell = pkgs.writeShellScriptBin "billsh" ''
      exec ${pkgs.bashInteractive}/bin/bash --rcfile ${self.bashrc}
    '';
  });
in
{
  inherit pkgs billpkgs;
}
