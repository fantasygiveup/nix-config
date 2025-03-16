{ lib, config, pkgs, ... }:

let cfg = config.misc.fonts.standard;
in {
  options.misc.fonts.standard = {
    enable = lib.mkEnableOption "Enable standard fonts collection";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Ubuntu" "Noto Color Emoji" ];
        sansSerif = [ "Ubuntu" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      pkgs.ubuntu_font_family
      pkgs.corefonts # microsoft free fonts
      pkgs.font-awesome
      pkgs.noto-fonts-color-emoji
    ];
  };
}
