# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # X11 clipboard history module.
    # TODO: disable in wayland.
    # TODO: consider to merge options to avoid repeatedly adding a new entry.
    outputs.homeManagerModules."environments/gnome3"
    outputs.homeManagerModules."services/clipist-clipboard"
    outputs.homeManagerModules."development/git"
    outputs.homeManagerModules."development/search"
    outputs.homeManagerModules."development/code"
    outputs.homeManagerModules."toolbox/wezterm-plus-tmux"
    outputs.homeManagerModules."toolbox/lf"
    outputs.homeManagerModules."toolbox/lazygit"

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

    # Configure your nixpkgs instance.
    config = {
      allowUnfree = true;

      # Required by Viber.
      permittedInsecurePackages = [ "openssl-1.1.1w" ];
    };
  };

  environments.gnome3.enable = true;
  services.cliphist-clipboard.enable = true;
  development.git.enable = true;
  development.search.enable = true;
  development.code.enable = true;
  toolbox.wezterm-plus-tmux.enable = true;
  toolbox.lf.enable = true;
  toolbox.lazygit.enable = true;

  home = {
    username = "idanko";
    homeDirectory = "/home/idanko";
  };

  home.sessionVariables = {
    VISUAL = "${pkgs.neovim}/bin/nvim";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    MANPAGER = "${pkgs.neovim}/bin/nvim +Man!";
    MANWIDTH = "80";

    # for "${pkgs.zk}/bin/zk".
    ZK_NOTEBOOK_DIR = "$HOME/github.com/fantasygiveup/zettelkasten";

    # Fix the libsqlite.so not found issue for https://github.com/kkharji/sqlite.lua.
    LD_LIBRARY_PATH =
      "${pkgs.lib.makeLibraryPath (with pkgs; [ sqlite ])}:$LD_LIBRARY_PATH";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = { enable = true; };
    defaultKeymap = "emacs";
    shellAliases = {
      urldecode =
        "${pkgs.python3}/bin/python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";

      urlencode =
        "${pkgs.python3}/bin/python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

      lg = "${pkgs.lazygit}/bin/lazygit";
      e = "$EDITOR";
    };
  };

  programs.eza = {
    enable = true;
    extraOptions = [ "--group-directories-first" "--header" ];
    icons = "auto";
  };

  # The modern shell prompt.
  # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;

  # TODO: check more about sd-switch.
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # NOTE: It is still necessary to set "programs.gnupg.agent = true" in the NixOS configuration for full integration.
  programs.gpg = { enable = true; };

  # GTK configuration.
  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
  };

  # QT configuration.
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  # Xresources configuration.
  xresources.properties = {
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = true;
    "Xft.antialias" = true;
    "Xft.rgba" = "rgb";
  };

  # TODO: split packages and configuration for xorg and wayland.
  home.packages = with pkgs; [
    anki
    bemenu
    bemenu-commander
    cliphist
    clipnotify
    dconf
    dconf-editor
    devcontainer
    discord
    dive # inspect docker images
    docker-compose
    drawio
    espeak # speach-module for speechd
    filezilla
    firefox
    foliate # awz3 viewer
    gimp
    google-chrome
    google-cloud-sdk-with-gke
    graphviz
    imagemagick
    imv # image viewer
    inkscape
    krita
    kubectl
    libnotify # provides notify-send
    libreoffice-fresh # ms office, but better
    meld # diff folders and files
    memtester # memory test
    mpv
    ngrok # route tcp from the public internet url to your host machine
    nix-index # for nix-locate
    obs-studio # record camera and desktop
    opera
    pandoc # convert/generate documents in different formats
    prismlauncher # minecraft launcher
    slack
    speechd # speech-dispatcher for foliate
    telegram-desktop
    texliveFull
    thunderbird
    unstable.neovim
    unstable.qbittorrent
    unstable.signal-desktop
    unstable.teams-for-linux
    unstable.yt-dlp
    vagrant
    viber
    vlc
    wireshark
    xcape
    xclip
    xorg.xev
    xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
    xorg.xmodmap
    yarn
    zk # zettelkasten cli
    zotero # citation tool
  ];

  home.file = { };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
