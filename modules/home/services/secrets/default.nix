{ lib, config, pkgs, ... }:
let cfg = config.services.secrets;
in with lib; {
  options.services.secrets = {
    enable = mkEnableOption "Enable secrets settings";
  };

  config = mkIf cfg.enable {
    # NOTE: It is still necessary to set "programs.gnupg.agent = true" in the NixOS configuration for full integration.
    programs.gpg = { enable = true; };

    home.sessionVariables = {
      "SSH_ASKPASS" =
        "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    };

    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      enableSshSupport = true;
    };

    home.packages = with pkgs; [ seahorse ];
  };
}
