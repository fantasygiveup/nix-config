{ config, lib, pkgs, ... }:
let cfg = config.wm.look-and-feel;
in with lib; {
  options.wm.look-and-feel = {
    enable = mkEnableOption "Enable common Look And Feel settings";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Numix-Square";
        package = pkgs.numix-icon-theme-square;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    xresources.properties = {
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintslight";
      "Xft.hinting" = true;
      "Xft.antialias" = true;
      "Xft.rgba" = "rgb";
      "Xft.dpi" = 120;
    };
  };
}
