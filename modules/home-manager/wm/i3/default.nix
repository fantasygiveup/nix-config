{ config, lib, pkgs, ... }:
let cfg = config.wm.i3;
in with lib; {
  options.wm.i3 = {
    enable = mkEnableOption "Enable i3 Window Manager Settings";
  };

  config = mkIf cfg.enable {
    xdg.configFile."i3/config" = {
      source = ./i3/config;
      # onChange = "i3-msg reload";
    };

    home.packages = with pkgs; [
      dconf
      dconf-editor
      gnome-tweaks
      xclip
      xorg.xev
      xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
      xorg.xmodmap
    ];
  };
}
