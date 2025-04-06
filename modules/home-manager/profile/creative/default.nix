{ lib, config, pkgs, ... }:

let cfg = config.profile.creative;
in with lib; {
  options.profile.creative = {
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
