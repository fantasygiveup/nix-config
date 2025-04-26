{ lib, config, pkgs, ... }:
let cfg = config.toolbox.lazygit;
in with lib; {
  options.toolbox.lazygit = { enable = mkEnableOption "Enable git tui"; };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme = true;
          activeBorderColor = [ "green" "bold" ];
          inactiveBorderColor = [ "black" ];
          selectedLineBgColor = [ "default" ];
        };
      };
    };

    programs.zsh.shellAliases = { gl = "${pkgs.lazygit}/bin/lazygit"; };
  };
}
