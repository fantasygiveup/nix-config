{ lib, config, users, pkgs, ... }:
let cfg = config.toolkit.mullvad-vpn;
in with lib; {
  options.toolkit.mullvad-vpn = {
    enable = mkEnableOption "Enable mullvad vpn setting";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
