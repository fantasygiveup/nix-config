# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, users, ... }:

{
  # You can import other home-manager modules here
  imports = builtins.attrValues outputs.homeManagerModules ++ [
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

    # Configure your nixpkgs instance.
    config = {
      allowUnfree = true;

      # Required by Viber.
      permittedInsecurePackages = [ "openssl-1.1.1w" ];
    };
  };

  services.cliphist-clipboard.enable = true;
  services.gpg.enable = true;
  services.sd-switch.enable = true;

  toolbox.wezterm-plus-tmux.enable = true;
  toolbox.lf.enable = true;
  toolbox.lazygit.enable = true;
  toolbox.zk.enable = true;
  toolbox.fzf.project-zsh.enable = true;
  toolbox.fzf.notes-zsh.enable = true;
  toolbox.eza.enable = true;

  environment.gnome3.enable = true;

  techops.dev.enable = true;
  techops.git.enable = true;
  techops.grep.enable = true;
  techops.net.enable = true;
  techops.os.enable = true;

  user.home.main.enable = true;

  shell.env.vars.enable = true;
  shell.zsh.enable = true;
  shell.starship.enable = true;

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
    bc
    bemenu-commander
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
    neofetch
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
