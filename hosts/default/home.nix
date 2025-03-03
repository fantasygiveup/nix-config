{ pkgs, pkgs-unstable, ... }:

rec {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "idanko";
  home.homeDirectory = "/home/idanko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # required for viber
  ];

  home.packages = with pkgs; ([
    (pkgs.callPackage ../../modules/nixos/fdir.nix { })
    (pkgs.google-cloud-sdk.withExtraComponents
      [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    pkgs-unstable.neovim
    pkgs-unstable.qbittorrent
    pkgs-unstable.signal-desktop
    pkgs-unstable.teams-for-linux
    pkgs-unstable.yt-dlp
    pkgs.alacritty # terminal of choice
    pkgs.anki
    pkgs.ansible
    pkgs.bemenu
    pkgs.bloomrpc
    pkgs.ccls # Language Server Protocol based on Clang
    pkgs.clang-tools
    pkgs.cliphist
    pkgs.clipnotify
    pkgs.cmake
    pkgs.dconf
    pkgs.dconf-editor
    pkgs.delve # golang debugger
    pkgs.devcontainer
    pkgs.discord
    pkgs.dive # inspect docker images
    pkgs.docker-compose
    pkgs.drawio
    pkgs.emmet-ls
    pkgs.espeak # speach-module for speechd
    pkgs.filezilla
    pkgs.firefox
    pkgs.foliate # awz3 viewer
    pkgs.gimp
    pkgs.gnome-tweaks
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.unite # merge title with gnome top dock
    pkgs.go
    pkgs.golangci-lint # golang linter package
    pkgs.golines # split long code lines in golang
    pkgs.google-chrome
    pkgs.gopls # golang language server protocol
    pkgs.gotools # set of go language code tools
    pkgs.graphviz
    pkgs.imagemagick
    pkgs.imv # image viewer
    pkgs.inkscape
    pkgs.krita
    pkgs.kubectl
    pkgs.lazygit
    pkgs.lf # terminal file manager
    pkgs.libnotify # provides notify-send
    pkgs.libreoffice-fresh # ms office, but better
    pkgs.libxml2 # xmllint
    pkgs.lua-language-server
    pkgs.luajit # lua interpreter
    pkgs.luarocks
    pkgs.meld # diff folders and files
    pkgs.memtester # memory test
    pkgs.mpv
    pkgs.ngrok # route tcp from the public internet url to your host machine
    pkgs.nix-index # for nix-locate
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.nodePackages.eslint # javascript linter
    pkgs.nodePackages.prettier # javascript formatter
    pkgs.nodePackages.typescript-language-server # typescript language server protocol
    pkgs.nodejs
    pkgs.obs-studio # record camera and desktop
    pkgs.opera
    pkgs.papirus-icon-theme
    pkgs.pgformatter
    pkgs.pistol # file previewer written in go
    pkgs.pkgs.pandoc # convert/generate documents in different formats
    pkgs.prismlauncher # minecraft launcher
    pkgs.pyright # python code formatter
    pkgs.rlwrap # wrap a command to make stdin interactive
    pkgs.sbcl
    pkgs.shfmt # shell files formatter
    pkgs.slack
    pkgs.speechd # speech-dispatcher for foliate
    pkgs.stylua
    pkgs.tailwindcss-language-server
    pkgs.telegram-desktop
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.texliveFull
    pkgs.thunderbird
    pkgs.tmux
    pkgs.typescript
    pkgs.vagrant
    pkgs.viber
    pkgs.vlc
    pkgs.vscode-langservers-extracted # cssls
    pkgs.wezterm
    pkgs.wireshark
    pkgs.xcape
    pkgs.xclip
    pkgs.xorg.xev
    pkgs.xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
    pkgs.xorg.xmodmap
    pkgs.yapf
    pkgs.yarn
    pkgs.zk # zettelkasten cli
    pkgs.zotero # citation tool
  ]);

  imports = [
    ../../modules/home-manager/app-settings.nix
    ../../modules/home-manager/yarr-service.nix
    ../../modules/home-manager/clipboard-history-service.nix
  ];

  home.file = { };

  home.sessionVariables = {
    # Fix the libsqlite.so not found issue for https://github.com/kkharji/sqlite.lua.
    LD_LIBRARY_PATH =
      "${pkgs.lib.makeLibraryPath (with pkgs; [ sqlite ])}:$LD_LIBRARY_PATH";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
