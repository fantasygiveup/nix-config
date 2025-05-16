{ lib, config, pkgs, ... }:
let cfg = config.services.yarr;
in with lib; {
  options.services.yarr = {
    enable = mkEnableOption "Enable yarr rss/atom reader";
  };

  config = mkIf cfg.enable {
    systemd.user.services.yarr = {
      Unit = {
        Description = "Yarr - rss / atom self-hosted reader.";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.yarr}/bin/yarr
        '';
        Restart = "always";
        TimeoutSec = 3;
        RestartSec = 3;
      };
    };

    home.packages = with pkgs; [ yarr ];
  };
}
