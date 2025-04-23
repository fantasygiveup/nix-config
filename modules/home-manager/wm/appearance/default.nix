{ config, lib, pkgs, ... }:
let cfg = config.wm.appearance;
in with lib; {
  options.wm.appearance = {
    enable = mkEnableOption "Enable appearance settings";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Numix-Square";
        package = pkgs.numix-icon-theme-square;
      };
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
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

    # Process mime types. Each application should add itself to the `xdg.mimeApps.defaultApplications`.
    # Most of the *.desktop files are placed into ~/.nix-profile/share/applications.
    home.sessionVariables = { OPENER = "xdg-open"; };
    xdg.mimeApps = { enable = true; };
    home.packages = with pkgs; [ xdg-utils ];
  };
}
