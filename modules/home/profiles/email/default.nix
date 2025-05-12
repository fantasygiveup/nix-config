{ lib, config, pkgs, ... }:
let cfg = config.profiles.email;
in with lib; {
  options.profiles.email = { enable = mkEnableOption "Enable email profile"; };

  config = mkIf cfg.enable { home.packages = with pkgs; [ thunderbird ]; };
}
