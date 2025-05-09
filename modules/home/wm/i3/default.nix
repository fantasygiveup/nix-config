{ config, lib, pkgs, ... }:
let
  cfg = config.wm.i3;
  color = config.color;

in with lib; {
  options.wm.i3 = {
    enable = mkEnableOption "Enable i3 Window Manager Settings";
  };

  config = mkIf cfg.enable {
    xdg.configFile."i3/config".source =
      pkgs.substituteAll (mergeAttrs { src = ./i3/config; } color);

    xresources.properties = { "Xft.dpi" = 120; };

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

    # Rofi.
    # TODO: consider to move this module part to a standalone package with overrides.
    xdg.configFile."rofi/catppuccin-scheme.rasi" = {
      source = mkMerge [
        (mkIf (color.variant == "light") (pkgs.substituteAll
          (mergeAttrs { src = ./rofi/catppuccin-system-grey.rasi; } color)))
        (mkIf (color.variant == "dark") (pkgs.substituteAll
          (mergeAttrs { src = ./rofi/catppuccin-system-grey.rasi; } color)))
      ];
    };
    xdg.configFile."rofi/catppuccin-default.rasi" = {
      source = ./rofi/catppuccin-default.rasi;
    };
    xdg.configFile."rofi/config.rasi" = { source = ./rofi/config.rasi; };

    services.picom.enable = true;
    xdg.configFile."picom/picom.conf".source = ./picom/picom.conf;
    xdg.configFile."i3blocks/config".source =
      pkgs.substituteAll (mergeAttrs { src = ./i3blocks/config; } color);

    services.dunst = {
      enable = true;
      settings = {
        global = {
          alignment = "center";
          width = 512;
          height = 128;
          origin = "bottom-right";
          offset = "6x36";
          transparency = 5;
          frame_color = "#${color.bg1}";
          font = "JetBrainsMono Nerd Font Mono 11";
          corner_radius = 8;
          frame_width = 1;
        };

        urgency_normal = {
          background = "#${color.bg2}";
          foreground = "#${color.fg1}";
          timeout = 7;
        };
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/gnome-screenshot" = {
          "last-save-directory" = "file:///home/idanko/Pictures/Screenshots";
        };
      };
    };

    # Logo.
    home.file.".face.icon".source = ./face.icon;

    # React to i3 events.
    systemd.user.services.i3-hooks = {
      Unit = { Description = "Listen and react to i3 events"; };
      Service = {
        ExecStart = ''
          ${(pkgs.python3.withPackages (ppkgs: [ ppkgs.i3ipc ]))}/bin/python3 ${
            ./i3-hooks.py
          }
        '';
        Restart = "always";
        TimeoutSec = 3;
        RestartSec = 3;
      };
      Install = { WantedBy = [ "default.target" ]; };
    };

    home.packages = with pkgs; [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "Ubuntu" ]; })
      autotiling
      bemenu
      cliphist
      dconf-editor
      gnome-screenshot-wrapper
      gnome-tweaks
      i3-current-window-title
      i3-notification-status
      i3blocks
      i3blocks-xkb-layout-widget
      i3lock
      lxappearance
      nitrogen
      rofi
      rofi-commander
      sysstat
      xdotool # is used in conjunction with maim
      xfce.thunar
      xorg.xev # x11 input analyzer
      xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
      xorg.xmodmap
      xsel
      xss-lock
    ];
  };
}
