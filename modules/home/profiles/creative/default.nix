{ lib, config, pkgs, ... }:
let cfg = config.profiles.creative;
in with lib; {
  options.profiles.creative = {
    enable = mkEnableOption "Enable creative profile";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
      graphviz
      imagemagick
      inkscape
      krita
      obs-studio # record camera and desktop
    ];
  };
}
