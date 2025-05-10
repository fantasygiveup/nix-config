{ lib, config, ... }:
let cfg = config.toolkit.gnupg;
in with lib; {
  options.toolkit.gnupg = {
    enable = mkEnableOption "Enable GNU Privacy Guard (gnupg) settings";
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
