{ lib, config, pkgs, ... }:
let cfg = config.toolbox.lf;
in {
  options.toolbox.lf = {
    enable = lib.mkEnableOption "Enable lf terminal file manager";
  };

  # Used for "fzf-project" integration. See the "commands" attribute.
  imports = [ ../fzf/project-zsh ];

  config = lib.mkIf cfg.enable {
    programs.lf = {
      enable = true;
      settings = {
        shell = "sh";
        shellopts = "-eu";
        ifs = "\\n";
        scrolloff = 10;
        icons = true;
        previewer = "pistol";
        info = "size:time";
        hidden = true;
        ratios = [ 1 1 ];
      };

      commands = {
        copy-clipboard = ''
          ''${{
                set -f
                target=$(basename "''${fx}")
                if [ "$#" -eq 1 ]; then
                    target="''${fx}"
                fi
                printf '%s' "''${target}" | eval "$CLIPBOARD_COPY_COMMAND"
            }}
        '';
        fzf-project = ''
          ''${{
                set -f
                FZF_DEFAULT_OPTS="''${FZF_DEFAULT_OPTS} --height 100% --reverse"
                res="$(zsh -c '. ~/.config/misc/fzf-project.zsh && _fzf_project --print || echo -n')"
                [ -n $res ] && lf -remote "send $id cd \"$HOME/$res\""
            }}
        '';
      };

      keybindings = {
        "<a-w>" = "copy-clipboard";
        "<c-w>" = "copy-clipboard --all";
        "." = "set hidden!";
        "<enter>" = "shell";
        "x" = "$$f"; # execute
        "X" = "!$f"; # execute
        "+" = "push %mkdir<space>-p<space>";
        "=" = "push %touch<space>";
        "D" = "delete";
        "<c-c>" = "reload";
        "<c-g>" = "fzf-project";
        "," = null;
        ",gg" = "$lazygit";
      };
    };

    xdg.configFile."lf/icons".source = ./icons;

    # Pistol - file previewer.
    # Lazygit - tui git.
    home.packages = [ pkgs.pistol pkgs.lazygit ];
  };
}
