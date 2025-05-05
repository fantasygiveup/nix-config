{ config, lib, pkgs, ... }:
let cfg = config.profile.appearance;
in with lib; {
  options.profile.appearance = {
    enable = mkEnableOption "Enable appearance settings";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          font-name = "Ubuntu Medium 14";
          document-font-name = "Ubuntu Regular 14";
          monospace-font-name = "JetBrainsMono Nerd Font Mono 14";
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
        size = 14;
      };
      cursorTheme = {
        name = "Bibata-Original-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      theme = {
        name = "Adwaita";
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
      # TODO(idanko): try 128 for st123 machine
      "Xft.dpi" = 120;
    };

    # Process mime types. Each application should add itself to the `xdg.mimeApps.defaultApplications`.
    # Most of the *.desktop files are placed into ~/.nix-profile/share/applications.
    home.sessionVariables = { OPENER = "xdg-open"; };
    xdg.mimeApps = { enable = true; };
    home.packages = with pkgs; [ xdg-utils ];
  };
}
