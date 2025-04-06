{ lib, config, pkgs, ... }:

let cfg = config.profile.browsing;
in with lib; {
  options.profile.browsing = {
    enable = mkEnableOption "Enable the Internet browsing profile";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "google-chrome" "opera" ];

    home.packages = with pkgs; [ google-chrome firefox opera lynx ];
  };
}
