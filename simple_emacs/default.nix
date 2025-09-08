{ pkgs }:

pkgs.writeShellScriptBin "simple_emacs" ''
  exec ${(pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: [
    epkgs.avy
    epkgs.counsel
    epkgs.evil
    epkgs.evil-nerd-commenter
    epkgs.general
    epkgs.ivy
    epkgs.jsonnet-mode
    epkgs.magit
    epkgs.multi-vterm
    epkgs.nix-mode
    epkgs.rust-mode
    epkgs.vterm
  ])}/bin/emacs \
    --debug-init \
    --no-site-file \
    --no-site-lisp \
    --no-init-file \
    --directory ${./config} \
    --eval "(require 'init)" $@
''
