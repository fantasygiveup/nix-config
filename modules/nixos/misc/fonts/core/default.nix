{ lib, config, pkgs, ... }:

let cfg = config.misc.fonts.core;
in {
  options.misc.fonts.core = {
    enable = lib.mkEnableOption "Enable core fonts settings";
  };

  config = lib.mkIf cfg.enable {
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
      fontconfig = {
        localConf = ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
          <fontconfig>
              <match target="font">
                  <edit name="antialias" mode="assign">
                      <!-- false,true -->
                      <bool>true</bool>
                  </edit>
                  <edit name="hinting" mode="assign">
                      <!-- false,true -->
                      <bool>true</bool>
                  </edit>
                  <edit name="autohint" mode="assign">
                      <!-- false,true -->
                      <bool>true</bool>
                  </edit>
                  <edit mode="assign" name="hintstyle">
                      <!-- hintnone,hintslight,hintmedium,hintfull -->
                      <const>hintslight</const>
                  </edit>
                  <edit name="rgba" mode="assign">
                      <!-- rgb,bgr,v-rgb,v-bgr -->
                      <const>rgb</const>
                  </edit>
                  <edit mode="assign" name="lcdfilter">
                      <!-- lcddefault,lcdlight,lcdlegacy,lcdnone -->
                      <const>lcddefault</const>
                  </edit>
                  <!-- https://wiki.archlinux.org/title/Microsoft_fonts !-->
                  <edit name="embeddedbitmap" mode="assign">
                      <bool>false</bool>
                  </edit>
              </match>
              <!-- Fallback fonts preference order -->
              <alias>
                  <family>sans-serif</family>
                  <prefer>
                      <family>Ubuntu</family>
                      <family>Noto Color Emoji</family>
                  </prefer>
              </alias>
              <alias>
                  <family>serif</family>
                  <prefer>
                      <family>Ubuntu</family>
                      <family>Noto Color Emoji</family>
                  </prefer>
              </alias>
              <alias>
                  <family>monospace</family>
                  <prefer>
                      <family>Ubuntu Mono</family>
                      <family>Noto Color Emoji</family>
                  </prefer>
              </alias>
              <!-- https://wiki.archlinux.org/title/Microsoft_fonts !-->
              <alias binding="same">
                  <family>Helvetica</family>
                  <accept>
                      <family>Arial</family>
                  </accept>
              </alias>
              <alias binding="same">
                  <family>Times</family>
                  <accept>
                      <family>Times New Roman</family>
                  </accept>
              </alias>
              <alias binding="same">
                  <family>Courier</family>
                  <accept>
                      <family>Courier New</family>
                  </accept>
              </alias>
          </fontconfig>
        '';
      };
    };
  };
}
