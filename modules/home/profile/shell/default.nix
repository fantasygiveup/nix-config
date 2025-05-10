{ lib, config, pkgs, ... }:
let cfg = config.profile.shell;
in with lib; {
  options.profile.shell = { enable = mkEnableOption "Enable shell settings"; };

  config = mkIf cfg.enable {
    # The modern shell prompt.
    # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
    programs.starship = {
      enable = true;
      settings = {
        gcloud = {
          # The active gcloud account is always enabled, causing disturbances. Disable it.
          disabled = true;
        };
      };
    };

    home.sessionVariables = {
      VISUAL = "${pkgs.neovim}/bin/nvim";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      MANPAGER = "${pkgs.neovim}/bin/nvim +Man!";
      MANWIDTH = "80";

      # Fix the qlite.so not found issue for https://github.com/kkharji/sqlite.lua.
      LD_LIBRARY_PATH =
        "${pkgs.lib.makeLibraryPath (with pkgs; [ sqlite ])}:$LD_LIBRARY_PATH";
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      history.ignoreAllDups = true; # remove old duplicated entries
      syntaxHighlighting = { enable = true; };
      defaultKeymap = "emacs";
      shellAliases = {
        urldecode =
          "${pkgs.python3}/bin/python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";

        urlencode =
          "${pkgs.python3}/bin/python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

        e = "$EDITOR";
        bc =
          "${pkgs.bc}/bin/bc -l"; # the calculator with advanced capabilities.

        # Generate 32 bytes size password with /dev/urandom.
        genpass = ''
          LC_CTYPE=C LC_ALL=C </dev/urandom tr -dc 'A-Za-z-1-9-_!' | head "-c''${1:-32}"; echo'';

        # Enable the emacs-like navigation.
        sqlite3 = "${pkgs.rlwrap}/bin/rlwrap ${pkgs.sqlite}/bin/sqlite3";
        mime = "file --mime-type";
      };
      envExtra = ''
        zstyle ':completion:*' menu select                  # select menu enabled
        zstyle ':completion::complete:*' gain-privileges 1  # complete commands start with sudo
        zstyle ':completion:*' rehash true                  # automatically find executables.
        zstyle ':completion:*:*:make:*' tag-order 'targets' # makefiles completion

        setopt COMPLETE_ALIASES       # auto-complete aliases
        setopt interactivecomments    # enable hash comment command

        # Enable clipboard sharing between containers and the host.
        xhost + &>/dev/null || true
      '';
    };
  };
}
