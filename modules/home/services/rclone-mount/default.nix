{ config, lib, pkgs, ... }:
let
  cfg = config.services.rclone-mount;
  mntCfg = cfg.mount;
in {
  options.services.rclone-mount = {
    enable = lib.mkEnableOption
      "Remote vfs-mount systemd unit based on rclone and fuse";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.rclone;
      defaultText = lib.literalExpression "pkgs.unstable.rclone";
      description = ''
        The `rclone` derivation to use. Useful to override
        configuration options used for the package.
      '';
    };

    mount.remote = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Rclone remote identifier to mount.";
    };

    mount.local = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Path to client's directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package pkgs.fuse ];

    systemd.user.services.rclone-mount = {
      Unit = {
        Description = ''
          Rclone - syncs your files to any cloud storage.

          Autorization example for Google Drive:
          - $rclone config
          - n) New remote
          - name> gdrive
          - Storage> 20
          - client_id>
          - client_secret>
          - scope> 1
          - service_account_file>
          - y/n>
          - y/n>
          - y/n>
          - y/e/d>
          - e/n/d/r/c/s/q> q
        '';

        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mntCfg.local}";
        ExecStart = ''
          ${cfg.package}/bin/rclone mount ${mntCfg.remote}: ${mntCfg.local} \
          --vfs-cache-mode full \
          --vfs-cache-max-size 1G \
          --vfs-cache-max-age 1h \
          --vfs-read-chunk-size 128M \
          --vfs-read-chunk-size-limit 2G \
          --dir-cache-time 72h \
          --poll-interval 15s \
          --buffer-size 32M \
          --attr-timeout 1s \
          --vfs-fast-fingerprint \
          --drive-chunk-size 64M \
          --log-level INFO
        '';
        Restart = "always";
        TimeoutSec = 10;
        RestartSec = 10;
      };
    };
  };
}
