{ lib, config, pkgs, ... }:

let cfg = config.development.git;
in {
  options.development.git = {
    enable = lib.mkEnableOption "Enable git configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      aliases = {
        s = "status";
        a = "add";
        c = "commit";
        g = "pull";
        p = "push";

        # Open lazygit.
        lz = "!${pkgs.lazygit}/bin/lazygit";

        # Open the lazygit log.
        lZ = "!${pkgs.lazygit}/bin/lazygit log";

        # Full reset.
        ra = "!git clean --force -d -x && git reset --hard";

        # Find a pattern in all logs.
        ss = "!git log -p --all -S";

        # Find in deleted files by a pattern.
        sd = "log --diff-filter=D --summary --oneline -S";

        # Pretty print logs: single line format.
        lp = "log --pretty=format:%H%x09%an%x09%ad%x09%s";

        # Pretty print logs: single line format short.
        ll = "log --pretty=format:%h%x09%an%x09%ad%x09%s";
      };
      diff-highlight.enable = true;
      userName = "fantasygiveup";
      userEmail = "illia@danko.me";

      extraConfig = {
        core = {
          editor = "nvim";
          whitespace = "trailing-space,space-before-tab";
        };
        init = { defaultBranch = "main"; };
        pull = { rebase = false; };
        diff = { tool = "nvim"; };
        "difftool \"nvim\"" = { cmd = "nvim -d $LOCAL $REMOTE"; };
        merge = { tool = "nvim"; };
        "mergetool \"nvim\"" = {
          cmd =
            "nvim -d $LOCAL $BASE $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        };
        advice = { skippedCherryPicks = false; };
      };
      includes = [
        {
          contents = {
            user = {
              email = "illia.danko@dentsplysirona.com";
              name = "Illia Danko";
            };
            "credential \"bitbucket.dentsplysirona.com\"" = { gpgSign = true; };
            "url \"ssh://git@bitbucket.dentsplysirona.com\"" = {
              insteadOf = "https://bitbucket.dentsplysirona.com";
            };

          };
          condition = "gitdir:~/bitbucket.dentsplysirona.com";
        }
        {
          contents = {
            user = {
              email = "idanko@strongsd.com";
              name = "Illia Danko";
            };
          };
          condition = "gitdir:~/github.com/strongsdcom";
        }
      ];
    };

    home.packages = [ pkgs.lazygit ];
  };
}
