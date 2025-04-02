{ lib, config, pkgs, ... }:

let cfg = config.toolkit.net;
in with lib; {
  options.toolkit.net = { enable = mkEnableOption "Enable networking tools"; };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ethtool ]; };
}
