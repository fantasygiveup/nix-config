{ config, lib, pkgs, users, ... }:
let
  cfg = config.profiles.peripherals;
  color = config.color;
in with lib; {
  options.profiles.peripherals = {
    enable = mkEnableOption "Enable peripherals settings";
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

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true; # used by pulseaudio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    users = {
      users = builtins.listToAttrs [{
        name = users.default.username;
        value = { extraGroups = [ "audio" ]; };
      }];
    };
  };
}
