{ lib, config, pkgs, ... }:
let cfg = config.shell.env.vars;
in with lib; {
  options.shell.env.vars = {
    enable = mkEnableOption "Enable session shell environment variables";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      VISUAL = "${pkgs.neovim}/bin/nvim";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      MANPAGER = "${pkgs.neovim}/bin/nvim +Man!";
      MANWIDTH = "80";

      # Fix the qlite.so not found issue for https://github.com/kkharji/sqlite.lua.
      LD_LIBRARY_PATH =
        "${pkgs.lib.makeLibraryPath (with pkgs; [ sqlite ])}:$LD_LIBRARY_PATH";
    };
  };
}
