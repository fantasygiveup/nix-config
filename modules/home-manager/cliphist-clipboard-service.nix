{ lib, config, pkgs, ... }:

let cfg = config.cliphist-clipboard-service;
in {
  options.cliphist-clipboard-service = {
    enable = lib.mkEnableOption "Enable 'cliphist-clipboard-service' module";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.cliphist-clipboard-service = {
      Unit = {
        Description =
          "X11 service: listens for clipboard events and pipes them to 'cliphist'.";
      };
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
