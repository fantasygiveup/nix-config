{ lib, config, ... }:

let cfg = config.toolkit.de.gnome3;
in with lib; {
  options.toolkit.de.gnome3 = {
    enable = mkEnableOption "Enable gnome3 desktop environment";
  };

  config = mkIf cfg.enable {
    # Enable the GNOME Desktop Environment.
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}
