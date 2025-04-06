{ lib, config, ... }:
let cfg = config.services.gpg;
in with lib; {
  options.services.gpg = { enable = mkEnableOption "Enable gnupg settings"; };

  config = mkIf cfg.enable {
    # NOTE: It is still necessary to set "programs.gnupg.agent = true" in the NixOS configuration for full integration.
    programs.gpg = { enable = true; };
  };
}
