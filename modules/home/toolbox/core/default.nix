{ lib, config, pkgs, ... }:
let cfg = config.toolbox.core;
in with lib; {
  options.toolbox.core = {
    enable = mkEnableOption "Enable common toolbox settings";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libnotify # provides notify-send
      libreoffice-fresh # ms office, but better
      memtester # memory test
      neofetch
      nix-index # for nix-locate
    ];

    programs.home-manager.enable = true;
  };
}
