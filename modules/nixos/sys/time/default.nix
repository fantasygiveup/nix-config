{ lib, config, ... }:
let cfg = config.sys.time;
in with lib; {
  options.sys.time = { enable = mkEnableOption "Enable system time settings"; };

  config = mkIf cfg.enable { time.timeZone = "Europe/Warsaw"; };
}
