# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "idanko";
    homeDirectory = "/home/idanko";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.bash.enable = false;
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Allow unfree packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # required for viber
  ];

  home.packages = with pkgs; ([
    # (pkgs.callPackage ../../modules/nixos/fdir.nix { })
    (pkgs.google-cloud-sdk.withExtraComponents
      [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    pkgs.neovim
    pkgs.qbittorrent
    pkgs.signal-desktop
    pkgs.teams-for-linux
    pkgs.wezterm
    pkgs.yt-dlp
    # pkgs-unstable.neovim
    # pkgs-unstable.qbittorrent
    # pkgs-unstable.signal-desktop
    # pkgs-unstable.teams-for-linux
    # pkgs-unstable.wezterm
    # pkgs-unstable.yt-dlp
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
    pkgs.eza # modern ls replacement
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

  home.file = { };

  home.sessionVariables = {
    # Fix the libsqlite.so not found issue for https://github.com/kkharji/sqlite.lua.
    LD_LIBRARY_PATH =
      "${pkgs.lib.makeLibraryPath (with pkgs; [ sqlite ])}:$LD_LIBRARY_PATH";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
