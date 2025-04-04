{ lib, config, pkgs, ... }:

let cfg = config.toolkit.net;
in with lib; {
  options.toolkit.net = { enable = mkEnableOption "Enable networking utils"; };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ethtool ]; };
}
