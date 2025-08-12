{ pkgs }:

pkgs.writeShellScriptBin "simple_emacs" ''
  exec ${(pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: [
    epkgs.counsel
    epkgs.evil
    epkgs.general
    epkgs.ivy
    epkgs.jsonnet-mode
    epkgs.magit
    epkgs.nix-mode
    epkgs.vterm
  ])}/bin/emacs \
    --debug-init \
    --no-site-file \
    --no-site-lisp \
    --no-init-file \
    --directory ${./config} \
    --eval "(require 'init)" $@
''
