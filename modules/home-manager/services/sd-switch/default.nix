{ lib, config, ... }:
let cfg = config.services.sd-switch;
in with lib; {
  options.services.sd-switch = {
    enable = mkEnableOption "Enable sd-switch for home manager";
  };

  config = mkIf cfg.enable {
    # Nicely reload system units when changing configs.
    systemd.user.startServices = "sd-switch";
  };
}
