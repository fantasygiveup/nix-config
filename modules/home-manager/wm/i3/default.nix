{ config, lib, pkgs, ... }:
let cfg = config.wm.i3;
in with lib; {
  options.wm.i3 = {
    enable = mkEnableOption "Enable i3 Window Manager Settings";
  };

  config = mkIf cfg.enable {
    xdg.configFile."i3/config" = {
      source = ./i3/config;
      # onChange = ''
      #   ${pkgs.i3}/bin/i3-msg reload restart;
      # '';
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
        name = "Bibata-Original-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };

    home.pointerCursor = {
      x11.enable = true;
      name = "Bibata-Original-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
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
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "Ubuntu" ]; })
      autotiling
      bemenu
      cliphist
      cpu-usage
      dconf
      dconf-editor
      dunstctl-count-history
      gnome-tweaks
      lxappearance
      mem-usage
      nitrogen
      rofi
      rofi-commander
      sysstat
      x11-title
      xclip
      xfce.thunar
      xorg.xev
      xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
      xorg.xmodmap
      xss-lock
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
          origin = "bottom-right";
          offset = "15x25";
          transparency = 5;
          frame_color = "#f0d2a7";
          font = "JetBrainsMono Nerd Font Mono 11";
          corner_radius = 10;
        };

        urgency_normal = {
          background = "#f0d2a7";
          foreground = "#9f6414";
          timeout = 10;
        };
      };
    };

    # Logo.
    home.file.".face".source = ./icons/kitty;

    # React to i3 events.
    systemd.user.services.i3-goodies = {
      Unit = { Description = "Listen and react to i3 events"; };
      Service = {
        ExecStart = ''
          ${(pkgs.python3.withPackages (ppkgs: [ ppkgs.i3ipc ]))}/bin/python3 ${
            ./i3-goodies.py
          }
        '';
        Restart = "always";
        TimeoutSec = 3;
        RestartSec = 3;
      };
      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
