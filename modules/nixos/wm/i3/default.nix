{ lib, config, pkgs, ... }:
let cfg = config.wm.i3;
in with lib; {
  options.wm.i3 = { enable = mkEnableOption "Enable i3 windows manager"; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      dpi = 120;

      desktopManager = { xterm.enable = false; };

      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          greeters.gtk = {
            iconTheme = {
              name = "Numix-Square";
              package = pkgs.numix-icon-theme-square;
            };
            cursorTheme = {
              name = "Bibata-Original-Ice";
              package = pkgs.bibata-cursors;
              size = 24;
            };
            theme = {
              name = "Adwaita-dark";
              package = pkgs.gnome-themes-extra;
            };
            extraConfig = ''
              font-name = Ubuntu 10
            '';
            indicators =
              [ "~host" "~spacer" "~clock" "~spacer" "~session" "~power" ];
          };
          background = ./wallpapers/light/0080.jpg;
        };
      };

      windowManager.i3 = { enable = true; };
    };

    # Do not ask ssh,gpg passwords all the time.
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;
  };
}
