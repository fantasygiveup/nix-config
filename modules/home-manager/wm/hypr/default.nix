{ config, lib, pkgs, ... }:
let
  cfg = config.wm.hypr;
  color = config.color;

in with lib; {
  options.wm.hypr = {
    enable = mkEnableOption "Enable Hyprland Window Manager Settings";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = "";
    };
    xdg.configFile."hypr/hyprland.conf".source =
      pkgs.substituteAll (mergeAttrs { src = ./hypr/hyprland.conf; } color);
  };
}
