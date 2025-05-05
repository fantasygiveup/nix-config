{ config, lib, pkgs, rootPath, ... }:
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
      systemd.enable = true;
      settings = { "$mainmod" = "ALT"; };
      xwayland.enable = true;
    };

    xdg.configFile."hypr/hyprland.conf".source =
      pkgs.substituteAll (mergeAttrs { src = ./hypr/hyprland.conf; } color);

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [{
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }];

        input-field = [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''
            \'<span foreground="##cad3f5">Password...</span>\'
          '';
          shadow_passes = 2;
        }];
      };
    };

    # services.hyprpolkitagent.enable = true;
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [ (toString (rootPath + /wallpapers/light/0080.jpg)) ];

        wallpaper = [ (toString (rootPath + /wallpapers/light/0080.jpg)) ];
      };
    };

    # Screen temperature.
    services.wlsunset = {
      enable = true;
      latitude = 52.2297;
      longitude = 21.0122;
      temperature = {
        day = 6500;
        night = 2800;
      };
    };

    services.mako = { enable = true; };

    home.packages = with pkgs; [ wl-clipboard unstable.ags ];
  };
}
