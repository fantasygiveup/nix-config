{ lib, config, pkgs, ... }:
let cfg = config.techops.grep;
in with lib; {
  options.techops.grep = { enable = mkEnableOption "Enable text search"; };

  config = mkIf cfg.enable (let
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

    ripgrep-ignore-filter = "--glob='!{${
        builtins.concatStringsSep "," ignore-search-patterns-extra
      }}'";
  in rec {
    home.sessionVariables = {
      RIPGREP_IGNORE_SEARCH_FILTER = ripgrep-ignore-filter;

      # Used by the "fzf-project" utility and "neovim".
      FZF_PROJECT_ROOT_DIRECTORY = "$HOME";

      FZF_PROJECT_FD_IGNORE_FILTER =
        concatMapStrings (str: " --exclude '${str}'")
        ignore-search-patterns-base;

      FZF_PROJECT_SEARCH_PATTERN = "'^.git$|^.hg$|^.bzr$|^.svn$'";
      CLIPBOARD_COPY_COMMAND = "${pkgs.xsel}/bin/xsel --clipboard";
    };

    programs.fzf = {
      enable = true;
      defaultCommand =
        "${pkgs.ripgrep}/bin/rg --files --hidden ${ripgrep-ignore-filter}";
      fileWidgetCommand = programs.fzf.defaultCommand;

      # FZF_DEFAULT_OPTS environment variable.
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
        "--pointer='>'"
        "--marker='>'"
        "--marker-multi-line='>>>'"
      ];
    };

    home.packages = [ pkgs.ripgrep pkgs.fd pkgs.fzf ];
  });
}
