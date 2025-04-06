{ lib, config, pkgs, ... }:
let cfg = config.profile.mailing;
in with lib; {
  options.profile.mailing = {
    enable = mkEnableOption "Enable mailing profile";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ thunderbird ]; };
}
