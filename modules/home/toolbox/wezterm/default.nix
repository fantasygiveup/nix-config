{ lib, config, pkgs, ... }:
let
  cfg = config.toolbox.wezterm;
  color = config.color;

in with lib; {
  options.toolbox.wezterm = {
    enable = mkEnableOption "Enable wezterm configuration";
  };

  config = mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source =
      pkgs.substituteAll (mergeAttrs { src = ./wezterm.lua; } color);

    programs.wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
      extraConfig = "";
    };
  };
}
