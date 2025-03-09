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
    # Configure your nixpkgs instance.
    config = { allowUnfree = true; };
  };

  home = {
    username = "idanko";
    homeDirectory = "/home/idanko";
  };

  # Shell prompt.
  # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;

  # TODO(idanko): check more about sd-switch.
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Allow unfree packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # required for viber
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # TODO(idanko): split packages and configuration for xorg and wayland.

  home.packages = with pkgs; ([
    # (pkgs.callPackage ../../modules/nixos/fdir.nix { })
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    alacritty # terminal of choice
    anki
    ansible
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
    fdir
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

  home.sessionVariables = {
    VISUAL = "${pkgs.neovim}/bin/nvim";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    MANPAGER = "${pkgs.neovim}/bin/nvim +Man!";
    MANWIDTH = "80";
    # TODO(idanko): revisit variables. Move common parts to a let expression.
    SEARCH_EXCLUDED_DIRS =
      "SCCS,RCS,CVS,MCVS,.git,.svn,.hg,.bzr,vendor,deps,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache,.ccls-cache,_build,.elixir_ls,.cache";
    RG_OPTS_FILTER =
      "--hidden --glob='!{SCCS,RCS,CVS,MCVS,.git,.svn,.hg,.bzr,vendor,deps,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache,.ccls-cache,_build,.elixir_ls,.cache}'";
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
    # TODO(idanko): find a better way to integrate with fzf-project.
    initExtra = ''
      . "${pkgs.fzf-project}/bin/fzf-project"
    '';
  };

  # Enable home-manager and git
  programs.git = { enable = true; };
  programs.fzf = {
    enable = true;
    fileWidgetCommand =
      "${pkgs.ripgrep}/bin/rg --files --hidden --glob='!{SCCS,RCS,CVS,MCVS,.git,.svn,.hg,.bzr,vendor,deps,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache,.ccls-cache,_build,.elixir_ls,.cache}'";
    defaultCommand =
      "${pkgs.ripgrep}/bin/rg --files --hidden --glob='!{SCCS,RCS,CVS,MCVS,.git,.svn,.hg,.bzr,vendor,deps,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache,.ccls-cache,_build,.elixir_ls,.cache}'";
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

  home.file = { };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
