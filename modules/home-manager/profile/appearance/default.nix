{ config, lib, pkgs, ... }:
let
  cfg = config.profile.appearance;
  color = config.color;
in with lib; {
  options.profile.appearance = {
    enable = mkEnableOption "Enable appearance settings";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          font-name = "Ubuntu Medium 11";
          document-font-name = "Ubuntu Medium 11";
          monospace-font-name = "JetBrainsMono Nerd Font Mono Bold 11";
          font-antialiasing = "rgba";
          font-hinting = "slight";
        };
      };
    };

    fonts = {
      fontconfig = {
        enable = true;

        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [ "JetBrainsMono Nerd Font Mono" ];
          sansSerif = [ "Ubuntu" ];
          serif = [ "Ubuntu" ];
        };
      };
    };

    gtk = {
      enable = true;
      font = {
        name = "Ubuntu Medium";
        package = pkgs.ubuntu_font_family;
        size = 11;
      };
      cursorTheme = {
        name = "Bibata-Original-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      theme = {
        name = mkMerge [
          (mkIf (color.variant == "light") "Adwaita")
          (mkIf (color.variant == "dark") "Adwaita-dark")
        ];
        package = pkgs.gnome-themes-extra;
      };
    };

    home.pointerCursor = {
      x11.enable = true;
      name = "Bibata-Original-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
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
      # TODO: try 128 for st123 machine
      "Xft.dpi" = 120;
    };

    # Process mime types. Each application should add itself to the `xdg.mimeApps.defaultApplications`.
    # Most of the *.desktop files are placed into ~/.nix-profile/share/applications.
    home.sessionVariables = { OPENER = "xdg-open"; };
    xdg.mimeApps = { enable = true; };
    home.packages = with pkgs; [ xdg-utils ];
  };
}
