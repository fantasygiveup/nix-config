{ lib, config, pkgs, ... }:

let cfg = config.techops.net;
in {
  options.techops.net = {
    enable = lib.mkEnableOption "Enable network configuration tools";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ iperf ]; };
}
