{ lib, config, hostname, ... }:

let cfg = config.net.core;
in {
  options.net.core = {
    enable = lib.mkEnableOption "Enable system networking core settings";
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = hostname;
    networking.networkmanager.enable = true;
  };
}
