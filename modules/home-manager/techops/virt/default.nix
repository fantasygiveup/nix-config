{ lib, config, pkgs, ... }:

let cfg = config.techops.virt;
in with lib; {
  options.techops.virt = {
    enable = mkEnableOption "Enable virtualization toolkit";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "vagrant" ];

    home.packages = with pkgs; [
      devcontainer
      dive # inspect docker images
      docker-compose
      vagrant
    ];
  };
}
