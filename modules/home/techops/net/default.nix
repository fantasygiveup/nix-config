{ lib, config, pkgs, ... }:
let cfg = config.techops.net;
in with lib; {
  options.techops.net = {
    enable = mkEnableOption "Enable network configuration tools";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "ngrok" ];

    home.packages = with pkgs; [
      filezilla
      iperf
      ngrok # route tcp from the public internet url to your host machine
      wireshark
    ];
  };
}
