{ lib, config, pkgs, ... }:
let cfg = config.shell.zsh;
in with lib; {
  options.shell.zsh = {
    enable = mkEnableOption "Enable zsh shell with configuration";
  };

  config = mkIf cfg.enable {
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

        e = "$EDITOR";
        bc =
          "${pkgs.bc}/bin/bc -l"; # the calculator with advanced capabilities.

        # Generate 32 bytes size password with /dev/urandom.
        genpass = ''
          LC_CTYPE=C LC_ALL=C </dev/urandom tr -dc 'A-Za-z-1-9-_!' | head "-c''${1:-32}"; echo'';

        # Enable the emacs-like navigation.
        sqlite3 = "${pkgs.rlwrap}/bin/rlwrap ${pkgs.sqlite}/bin/sqlite3";
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
