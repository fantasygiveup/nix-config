{ lib, config, pkgs, ... }:

let cfg = config.toolkit.extra;
in with lib; {
  options.toolkit.extra = { enable = mkEnableOption "Enable extra tools"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ btop dos2unix rsync ];
  };
}
