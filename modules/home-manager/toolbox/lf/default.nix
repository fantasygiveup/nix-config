{ lib, config, pkgs, ... }:
let cfg = config.toolbox.lf;
in with lib; {
  options.toolbox.lf = {
    enable = mkEnableOption "Enable lf terminal file manager";
  };

  # Used for "fzf-project" integration. See the "commands" attribute.
  imports = [ ../fzf/project-zsh ];

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
      settings = {
        shell = "sh";
        shellopts = "-eu";
        ifs = "\\n";
        scrolloff = 10;
        icons = true;
        previewer = "${pkgs.pistol}/bin/pistol";
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

        open = ''
          ''${{
                case $(file --mime-type -Lb $f) in
                    text/*) lf -remote "send $id \$$EDITOR \$fx";;
                    application/*) lf -remote "send $id \$$EDITOR \$fx";;
                    inode/*) lf -remote "send $id \$$EDITOR \$fx";;
                    *) for f in $fx; do xdg-open $f > /dev/null 2> /dev/null & done;;
                esac
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
        "gl" = "\$${pkgs.lazygit}/bin/lazygit";
        "gd" = "cd ~/Documents";
        "gw" = "cd ~/Downloads";
        "gv" = "cd ~/Videos";
        "gm" = "cd ~/Music";
        "gp" = "cd ~/Pictures";
        "gc" = "cd ~/.config";
      };
    };

    xdg.configFile."lf/icons".source = ./icons;
  };
}
