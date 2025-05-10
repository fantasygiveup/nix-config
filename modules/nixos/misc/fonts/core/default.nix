{ lib, config, pkgs, ... }:
let cfg = config.misc.fonts.core;
in with lib; {
  options.misc.fonts.core = {
    enable = mkEnableOption "Enable core fonts coniguration";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "corefonts" ];

    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "IosevkaTerm" ]; })
        pkgs.corefonts # microsoft free fonts
        pkgs.fira-code # monospace font with programming ligatures
        pkgs.fira-mono # mozilla's typeface for firefox os
        pkgs.font-awesome
        pkgs.google-fonts
        pkgs.liberation_ttf
        pkgs.noto-fonts
        pkgs.noto-fonts-color-emoji
        pkgs.roboto # android font
        pkgs.ubuntu_font_family
      ];
    };
  };
}
