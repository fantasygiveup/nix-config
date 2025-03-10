{ config, pkgs, lib, ... }:

let cfg = config.environments.gnome3;
in {
  options.environments.gnome3 = {
    enable = lib.mkEnableOption "Enable Gnome3 configuration";
  };

  config = lib.mkIf cfg.enable {

    # To see changes using GNOME Tweaks (or any other method), use the dconf watch / command.
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          text-scaling-factor = 1.25;
          font-name = "Ubuntu Medium 11";
          document-font-name = "Ubuntu Regular 11";
          monospace-font-name = "JetBrainsMono Nerd Font Mono 11";
          font-antialiasing = "rgba";
          font-hinting = "slight";
          clock-show-weekday = true;
          enable-hot-corners = false; # disable the top-left hot corner.
        };
        "org/gnome/desktop/input-sources" = {
          sources = [
            (lib.gvariant.mkTuple [ "xkb" "us" ])
            (lib.gvariant.mkTuple [ "xkb" "ua" ])
          ];
          xkb-options = [
            "terminate:ctrl_alt_bksp"
            "caps:ctrl_modifier"
          ]; # use caps as ctrl
        };
        "org/gnome/desktop/wm/keybindings" = { show-desktop = [ "<Super>d" ]; };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<Control><Alt>h";
            command = "bemenu-commander cliphist";
            name = "Clipboard History";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
          {
            binding = "<Control><Alt>u";
            command = "bemenu-commander ref";
            name = "Ref";
          };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
          {
            binding = "<Control><Alt>i";
            command = "bemenu-commander ref-data";
            name = "Ref-Data";
          };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-temperature = (lib.gvariant.mkUint32 2800);
        };

        "org/gnome/shell" = {
          enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" ];
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
          idle-delay = (lib.gvariant.mkUint32 300); # 5min
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
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
        };
      };
    };
  };
}
