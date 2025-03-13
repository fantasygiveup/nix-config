{ lib, config, pkgs, ... }:
let cfg = config.toolbox.lazygit;
in {
  options.toolbox.lazygit = { enable = lib.mkEnableOption "Enable git tui"; };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme = true;
          activeBorderColor = [ "blue" "bold" ];
          inactiveBorderColor = [ "black" ];
          selectedLineBgColor = [ "default" ];
        };

      };
    };
    # xdg.configFile."lazygit/config.yml".source = ./config.yml;
  };
}
