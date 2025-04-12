{ lib, config, pkgs, ... }:
let cfg = config.wm.i3;
in with lib; {
  options.wm.i3 = { enable = mkEnableOption "Enable i3 windows manager"; };

  config = mkIf cfg.enable {
    environment.pathsToLink = [
      "/libexec"
    ]; # links /libexec from derivations to /run/current-system/sw
    services.xserver = {
      enable = true;

      desktopManager = { xterm.enable = false; };

      displayManager = {
        defaultSession = "none+i3";
        lightdm.greeters.gtk.cursorTheme = {
          name = "Bibata-Original-Amber";
          package = pkgs.bibata-cursors;
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };

    # Do not ask ssh,gpg passwords all the time.
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;
  };
}
