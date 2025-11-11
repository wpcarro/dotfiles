# dotfiles

[![asciicast](https://asciinema.org/a/dGFCIZchaqIil0xKHuHbzqjqM.svg)](https://asciinema.org/a/dGFCIZchaqIil0xKHuHbzqjqM)

## Install

You have a few installation options:
1. Use Nix Profiles (recommended)
2. Overwrite existing `~/.bashrc`
3. Standalone executable: `billsh`

Use Nix Profiles (recommended)

```shell
$ nix-env -f https://github.com/wpcarro/dotfiles/archive/main.tar.gz -iA dotfiles.bashrc
$ vim ~/.bashrc # add "source ~/.nix-profile/etc/bashrc"
```

Overwrite existing `~/.bashrc`

```shell
$ mv ~/.bashrc{,.bak} # backup your bashrc
$ ln -sf $(nix-build https://github.com/wpcarro/dotfiles/archive/main.tar.gz -A dotfiles.bashrc --no-out-link)/etc/bashrc ~/.bashrc
```

Standalone executable: `billsh`

```shell
$ nix-env -f https://github.com/wpcarro/dotfiles/archive/main.tar.gz -iA dotfiles.shell
```

## Nix

You may need to install Nix:

```shell
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```
