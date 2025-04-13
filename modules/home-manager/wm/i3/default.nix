{ config, lib, pkgs, ... }:
let cfg = config.wm.i3;
in with lib; {
  options.wm.i3 = {
    enable = mkEnableOption "Enable i3 Window Manager Settings";
  };

  config = mkIf cfg.enable {
    xdg.configFile."i3/config" = {
      source = ./i3/config;
      onChange = ''
        ${pkgs.i3}/bin/i3-msg reload restart;
      '';
    };

    # wm.gnome3.enable = true;

    # Styling
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
        name = "Bibata-Original-Amber";
        package = pkgs.bibata-cursors;
      };
    };

    home.pointerCursor = {
      x11.enable = true;
      name = "Bibata-Original-Amber";
      package = pkgs.bibata-cursors;
      size = 32;
      gtk.enable = true;
    };

    # Adjust screen temperature according geospacial data.
    services.gammastep = {
      enable = true;

      # Localtion: Warsaw, Poland.
      latitude = 52.2297;
      longitude = 21.0122;

      temperature = {
        day = 6500;
        night = 2800;
      };
    };

    home.packages = with pkgs; [
      dconf
      dconf-editor
      gnome-tweaks
      xclip
      xorg.xev
      xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
      xorg.xmodmap
      rofi
      bemenu
      lxappearance
      cliphist
      xkb-switch-i3
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "Ubuntu" ]; })
    ];

    # Rofi.
    xdg.configFile."rofi/config.rasi" = { source = ./rofi/config.rasi; };
    xdg.configFile."rofi/catppuccin-default.rasi" = {
      source = ./rofi/catppuccin-default.rasi;
    };
    xdg.configFile."rofi/catppuccin-mocha.rasi" = {
      source = ./rofi/catppuccin-mocha.rasi;
    };
    xdg.configFile."rofi/catppuccin-latte.rasi" = {
      source = ./rofi/catppuccin-latte.rasi;
    };

    services.picom.enable = true;
    xdg.configFile."picom/picom.conf" = { source = ./picom/picom.conf; };
    xdg.configFile."i3blocks/config" = { source = ./i3blocks/config; };

    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 512;
          height = 128;
          offset = 28;
          origin = "top-center";
          transparency = 10;
          frame_color = "#7287fd";
          font = "JetBrainsMono Nerd Font Mono 10";
        };

        urgency_normal = {
          background = "#ccd0da";
          foreground = "#4c4f69";
          timeout = 10;
        };
      };
    };
  };
}
