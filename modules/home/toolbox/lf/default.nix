{ lib, config, pkgs, user, ... }:
let
  cfg = config.toolbox.lf;
  color = config.color;
  wallpapers = "${user.homeDirectory}/github.com/fantasygiveup/wallpapers";

in with lib; {
  options.toolbox.lf = {
    enable = mkEnableOption "Enable lf terminal file manager";
  };

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
      settings = {
        shell = "sh";
        shellopts = "-eu";
        ifs = "\\n";
        scrolloff = 10;
        icons = true;
        previewer = "~/.config/lf/image-preview";
        sixel = true;
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

        open = ''
          ''${{
                  case $(file --mime-type -Lb $f) in
                      text/*) lf -remote "send $id \$$EDITOR \$fx";;
                      application/pdf) mupdf $f;;
                      application/javascript) lf -remote "send $id \$$EDITOR \$fx";;
                      application/x-ndjson) lf -remote "send $id \$$EDITOR \$fx";;
                      inode/x-empty) lf -remote "send $id \$$EDITOR \$fx";;
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
        "gd" = "cd ~/Documents";
        "gl" = "cd ~/Downloads";
        "gv" = "cd ~/Videos";
        "gm" = "cd ~/Music";
        "gi" = "cd ~/Pictures";
        "gc" = "cd ~/.config";
        "gs" = "cd ~/Shared";
        "gw" = "cd ${wallpapers}";
        "<c-b>" = "half-up";
        "<c-f>" = "half-down";
        "<c-u>" = null;
        "<c-d>" = null;
        "R" = "reload"; # to avoid issues on the mounted VSF.
      };
    };

    xdg.configFile."lf/image-preview" = {
      executable = true;
      text =
        # bash
        ''
          #!/usr/bin/env bash
          case "$(file -Lb --mime-type -- "$1")" in
            image/*)
              "${pkgs.chafa}"/bin/chafa -f sixel -s "$2x$3" --animate off --polite on -t 1 "$1"
              ;;
            *)
              "${pkgs.pistol}"/bin/pistol "$1"
              ;;
          esac
        '';
    };

    xdg.configFile."lf/icons".source = ./icons;
  };
}
