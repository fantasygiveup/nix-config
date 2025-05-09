{ lib, config, pkgs, ... }:
let cfg = config.misc.minecraft;
in with lib; {
  options.misc.minecraft = {
    enable = mkEnableOption "Enable minecraft settings";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        prismlauncher # minecraft launcher
      ];
  };
}
