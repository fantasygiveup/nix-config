{ lib, config, pkgs, ... }:
let cfg = config.services.cliphist-clipboard;
in with lib; {
  options.services.cliphist-clipboard = {
    enable = mkEnableOption
      "X11 clipboard history service based on cliphist, xclip and clipnotify";
  };

  config = mkIf cfg.enable {
    systemd.user.services.cliphist-clipboard = {
      Unit = { Description = "X11 based clipboard events listener"; };
      Service = {
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c 'while ${pkgs.clipnotify}/bin/clipnotify; do ${pkgs.xclip}/bin/xclip -o -selection c | ${pkgs.cliphist}/bin/cliphist store; done'
        '';
        Restart = "always";
        TimeoutSec = 3;
        RestartSec = 3;
      };
      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
