{ lib, config, pkgs, ... }:

let cfg = config.toolkit.net;
in {
  options.toolkit.net = {
    enable = lib.mkEnableOption "Enable networking tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ethtool ];
  };
}
