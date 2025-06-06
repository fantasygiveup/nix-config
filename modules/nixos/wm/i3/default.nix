{ lib, config, pkgs, users, flakePath, ... }:
let cfg = config.wm.i3;
in with lib; {
  options.wm.i3 = { enable = mkEnableOption "Enable i3 windows manager"; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      dpi = 120;

      desktopManager = { xterm.enable = false; };
      windowManager.i3 = { enable = true; };
    };

    services.displayManager = {
      defaultSession = "none+i3";
      sddm = {
        enable = true;
        theme = "Elegant";
        settings = {
          Theme = {
            CursorTheme = "Bibata-Modern-Ice";
            CursorSize = 24;
            Font = "Ubuntu 11";
          };
        };
      };
    };

    # Set user's sddm avatar.
    system.activationScripts.setAccountsServiceUserIcon.text = ''
      mkdir -p /var/lib/AccountsService/icons

      cp -rf ${
        ./face.icon
      } /var/lib/AccountsService/icons/${users.default.username}
    '';

    environment.systemPackages = with pkgs; [
      bibata-cursors
      ubuntu_font_family

      (pkgs.elegant-sddm.override {
        themeConfig.General = {
          background = (toString (flakePath + /wallpapers/0042.jpg));
        };
      })
    ];

    # Do not ask ssh,gpg passwords all the time.
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;

    # Pam must be configured to perform authentication.
    security = { polkit.enable = true; };

    # Fix of:
    #  - "GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit dconf.service not found."
    #  - "error: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name ca.desrt.dconf was not provided by any .service files"
    # issues.
    programs.dconf.enable = true;

    # Advised by home services.gpg-agent.
    services.dbus.packages = [ pkgs.gcr ];

    services.accounts-daemon.enable = true;
  };
}
