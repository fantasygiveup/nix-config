{ lib, config, pkgs, ... }:

let cfg = config.toolkit.extra;
in {
  options.toolkit.extra = {
    enable = lib.mkEnableOption "Enable optional tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ btop dos2unix rsync ];
  };
}
