{ lib, config, pkgs, ... }:

let cfg = config.techops.net;
in with lib; {
  options.techops.net = {
    enable = mkEnableOption "Enable network configuration tools";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ iperf ]; };
}
