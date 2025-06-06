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
      pinentry.package = pkgs.pinentry-gnome3;
      enableSshSupport = true;
    };

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks."*" = { identityFile = "~/.ssh/id_rsa"; };
      matchBlocks."bitbucket.dentsplysirona.com" =
        lib.hm.dag.entryBefore [ "*" ] {
          identityFile = "~/.ssh/id_rsa_third";
        };
    };

    home.packages = with pkgs; [ seahorse ];
  };
}
