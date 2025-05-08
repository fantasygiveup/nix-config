{ lib, config, pkgs, hostname, ... }:
let cfg = config.sys.media.bluetooth;
in with lib; {
  options.sys.media.bluetooth = {
    enable = mkEnableOption "Enable bluetooth settings";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    # Using Bluetooth headset buttons to control media player.
    systemd.user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };
  };
}
