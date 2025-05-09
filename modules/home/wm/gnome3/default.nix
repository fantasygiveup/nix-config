{ config, lib, pkgs, ... }:
let cfg = config.wm.gnome3;
in with lib; {
  options.wm.gnome3 = { enable = mkEnableOption "Enable Gnome3 settings"; };

  config = mkIf cfg.enable {
    xresources.properties = { "Xft.dpi" = 120; };

    # To see changes using GNOME Tweaks (or any other method), use the dconf watch / command.
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = { text-scaling-factor = 1.25; };
        "org/gnome/desktop/input-sources" = {
          sources = [
            (gvariant.mkTuple [ "xkb" "us" ])
            (gvariant.mkTuple [ "xkb" "ua" ])
          ];
          xkb-options = [
            "terminate:ctrl_alt_bksp"
            "caps:ctrl_modifier"
          ]; # use caps as ctrl
        };
        "org/gnome/shell/keybindings" = {
          toggle-message-tray = [ "<Shift><Alt>n" ];
          focus-active-notification = [ "<Alt>equal" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = [ "<Alt>1" ];
          switch-to-workspace-2 = [ "<Alt>2" ];
          switch-to-workspace-3 = [ "<Alt>3" ];
          switch-to-workspace-4 = [ "<Alt>4" ];
          move-to-workspace-1 = [ "<Shift><Alt>1" ];
          move-to-workspace-2 = [ "<Shift><Alt>2" ];
          move-to-workspace-3 = [ "<Shift><Alt>3" ];
          move-to-workspace-4 = [ "<Shift><Alt>4" ];
        };
        "org/gnome/desktop/wm/keybindings" = { show-desktop = [ "<Super>d" ]; };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<Alt><Shift>y";
            command = "rofi-commander cliphist";
            name = "Clipboard History";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
          {
            binding = "<Alt><Shift>u";
            command = "rofi-commander ref";
            name = "Ref";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
          {
            binding = "<Alt><Shift>i";
            command = "rofi-commander ref-data";
            name = "Ref-Data";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" =
          {
            binding = "<Alt>Return";
            command = "wezterm";
            name = "Wezterm";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" =
          {
            binding = "<Shift><Alt>Return";
            command = "google-chrome-stable";
            name = "Google Chrome";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" =
          {
            binding = "<Shift><Alt>m";
            command =
              # bash
              ''
                bash -c 'dconf write /org/gnome/desktop/notifications/show-banners $([ "$(dconf read /org/gnome/desktop/notifications/show-banners)" = true ] && echo false || echo true)'
              '';
            name = "Mute/unmute notifications";
          };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-temperature = gvariant.mkUint32 2800;
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = [ "<Alt>BackSpace" ];
          toggle-fullscreen = [ "<Shift><Alt>f" ];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          search = [ "<Shift><Alt>p" ];
        };
        "org/gnome/shell" = {
          enabled-extensions = [
            "dash-to-dock@micxgx.gmail.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
            "disable-workspace-animation@ethnarque"
            "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
          ];
          last-selected-power-profile = "performance";
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "thunderbird.desktop"
            "google-chrome.desktop"
            "org.wezfurlong.wezterm.desktop"
            "slack.desktop"
            "teams-for-linux.desktop"
            "com.github.johnfactotum.Foliate.desktop"
            "anki.desktop"
          ];
        };
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-timeout = 900; # 15min
          sleep-inactive-ac-type = "suspend";
        };
        "org/gnome/desktop/session" = {
          idle-delay = gvariant.mkUint32 300; # 5min
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          apply-custom-theme = false;
          dock-position = "BOTTOM";
          transparency-mode = "FIXED";
          background-opacity = 1.0;
          height-fraction = 1.0;
          dash-max-icon-size = 36;
          extend-height = true;
          show-apps-always-in-the-edge = false;
          dock-fixed = true;
          custom-theme-shrink = true;
          custom-background-color = true;
          isolate-workspaces = true;
          show-apps-at-top = true;
          background-color = "rgb(0,0,0)";
          running-indicator-style = "DOTS";
          always-center-icons = true;
        };
        "org/gnome/shell/extensions/workspace-indicator" = {
          embed-previews = true;
        };
        "org/gnome/shell/extensions/auto-move-windows" = {
          application-list = [
            "google-chrome.desktop:2"
            "org.wezfurlong.wezterm.desktop:1"
            "thunderbird.desktop:3"
            "teams-for-linux.desktop:3"
            "slack.desktop:3"
            "viber.desktop:3"
            "org.telegram.desktop.desktop:3"
            "discord.desktop:3"
            "org.inkscape.Inkscape.desktop:4"
            "gimp.desktop:4"
            "org.wireshark.Wireshark.desktop:4"
            "anki.desktop:4"
            "com.github.johnfactotum.Foliate.desktop:4"
            "firefox.desktop:2"
          ];
        };
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
        };
        "org/gnome/mutter" = { dynamic-workspaces = false; };
        "org/gnome/desktop/wm/preferences" = { num-workspaces = 4; };
      };
    };

    # Rofi.
    xdg.configFile."rofi/catppuccin-dark.rasi" = {
      source = ./rofi/catppuccin-dark.rasi;
    };
    xdg.configFile."rofi/catppuccin-default.rasi" = {
      source = ./rofi/catppuccin-default.rasi;
    };
    xdg.configFile."rofi/config.rasi" = { source = ./rofi/config.rasi; };

    home.packages = with pkgs; [
      dconf
      dconf-editor
      gnome-tweaks
      gnomeExtensions.dash-to-dock
      gnomeExtensions.disable-workspace-animation
      rofi
      rofi-commander
      xclip
      xorg.xev
      xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
      xorg.xmodmap
      bemenu-commander
    ];
  };
}
