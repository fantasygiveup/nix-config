# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }:
let

  # Base patterns to exclude from the search. Can be used with "fd".
  ignore-search-patterns-base = [
    "vendor"
    "deps"
    "node_modules"
    "dist"
    "venv"
    "elm-stuff"
    ".clj-kondo"
    ".lsp"
    ".cpcache"
    ".ccls-cache"
    "_build"
    ".elixir_ls"
    ".cache"
  ];

  ignore-search-patterns-extra = ignore-search-patterns-base
    ++ [ "SCCS" "RCS" "CVS" "MCVS" ".git" ".svn" ".hg" ".bzr" ];

  ripgrep-ignore-filter =
    "--glob='!{${builtins.concatStringsSep "," ignore-search-patterns-extra}}'";

in rec {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # X11 clipboard history module.
    # TODO: disable in wayland.
    outputs.homeManagerModules.cliphist-clipboard-service
    outputs.homeManagerModules.gitconfig

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

  home = {
    username = "idanko";
    homeDirectory = "/home/idanko";
  };

  home.sessionVariables = {
    VISUAL = "${pkgs.neovim}/bin/nvim";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    MANPAGER = "${pkgs.neovim}/bin/nvim +Man!";
    MANWIDTH = "80";
    RIPGREP_IGNORE_SEARCH_FILTER = ripgrep-ignore-filter;

    # Used by the "fzf-project" utility and "neovim".
    FZF_PROJECT_ROOT_DIRECTORY = "$HOME";

    FZF_PROJECT_FD_IGNORE_FILTER =
      lib.concatMapStrings (str: " --exclude '${str}'")
      ignore-search-patterns-base;

    FZF_PROJECT_SEARCH_PATTERN = "'^.git$|^.hg$|^.bzr$|^.svn$'";
    CLIPBOARD_COPY_COMMAND = "${pkgs.xclip}/bin/xclip -in -selection c";

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
        "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";

      urlencode =
        "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

      lg = "${pkgs.lazygit}/bin/lazygit";
      e = "$EDITOR";
    };

    # TODO: find a better way to integrate with fzf-project.
    initExtra = ''
      . "${pkgs.fzf-project}/bin/fzf-project"
    '';
  };

  # Enable git.
  gitconfig.enable = true;

  # Enable the X11 clipboard history daemon.
  cliphist-clipboard-service.enable = true;

  programs.fzf = {
    enable = true;
    defaultCommand =
      "${pkgs.ripgrep}/bin/rg --files --hidden ${ripgrep-ignore-filter}";
    fileWidgetCommand = programs.fzf.defaultCommand;
    defaultOptions = [
      "--no-mouse"
      "--layout=reverse"
      "--height 40%"
      "--border"
      "--multi"
      "--exact"
      "--preview-window=hidden"
      "--bind='alt-w:execute-silent(echo -n {} | $CLIPBOARD_COPY_COMMAND)'"
      "--bind='ctrl-e:print-query'"
      "--bind='ctrl-b:half-page-up'"
      "--bind='ctrl-f:half-page-down'"
      "--bind='ctrl-u:preview-half-page-up'"
      "--bind='ctrl-d:preview-half-page-down'"
      "--bind='alt-p:toggle-preview'"
      "--bind='ctrl-a:toggle-all'"
      "--color=gutter:-1,fg:-1,fg+:-1,pointer:1,hl:2,hl+:2,bg+:8"
    ];
  };

  programs.eza = {
    enable = true;
    extraOptions = [ "--group-directories-first" "--header" ];
    icons = "auto";
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    config = {

      # Disable the timeout warning.
      warn_timeout = "0";
    };
  };

  # The modern shell prompt.
  # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;

  # TODO: check more about sd-switch.
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # NOTE: It is still necessary to set "programs.gnupg.agent = true" in the NixOS configuration for full integration.
  programs.gpg = { enable = true; };

  # TODO: split packages and configuration for xorg and wayland.

  home.packages = with pkgs; ([
    alacritty # terminal of choice
    anki
    ansible
    bemenu-commander
    bemenu
    bloomrpc
    ccls # Language Server Protocol based on Clang
    clang-tools
    cliphist
    clipnotify
    cmake
    dconf
    dconf-editor
    delve # golang debugger
    devcontainer
    discord
    dive # inspect docker images
    docker-compose
    drawio
    emmet-ls
    espeak # speach-module for speechd
    filezilla
    firefox
    foliate # awz3 viewer
    fzf-project
    gimp
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.unite # merge title with gnome top dock
    go
    golangci-lint # golang linter package
    golines # split long code lines in golang
    google-chrome
    google-cloud-sdk-with-gke
    gopls # golang language server protocol
    gotools # set of go language code tools
    graphviz
    imagemagick
    imv # image viewer
    inkscape
    krita
    kubectl
    lazygit # convenient git tui
    lf # terminal file manager
    libnotify # provides notify-send
    libreoffice-fresh # ms office, but better
    libxml2 # xmllint
    lua-language-server
    luajit # lua interpreter
    luarocks
    meld # diff folders and files
    memtester # memory test
    mpv
    ngrok # route tcp from the public internet url to your host machine
    nix-index # for nix-locate
    nixd
    nixfmt-classic
    nodePackages.eslint # javascript linter
    nodePackages.prettier # javascript formatter
    nodePackages.typescript-language-server # typescript language server protocol
    nodejs
    obs-studio # record camera and desktop
    opera
    pandoc # convert/generate documents in different formats
    papirus-icon-theme
    pgformatter
    pistol # file previewer written in go
    prismlauncher # minecraft launcher
    pyright # python code formatter
    ripgrep
    rlwrap # wrap a command to make stdin interactive
    sbcl
    shfmt # shell files formatter
    slack
    speechd # speech-dispatcher for foliate
    stylua
    tailwindcss-language-server
    telegram-desktop
    terraform
    terraform-ls
    texliveFull
    thunderbird
    tmux
    typescript
    unstable.neovim
    unstable.qbittorrent
    unstable.signal-desktop
    unstable.teams-for-linux
    unstable.wezterm
    unstable.yt-dlp
    vagrant
    viber
    vlc
    vscode-langservers-extracted # cssls
    wireshark
    xcape
    xclip
    xorg.xev
    xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
    xorg.xmodmap
    yapf
    yarn
    zk # zettelkasten cli
    zotero # citation tool
  ]);

  home.file = { };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
