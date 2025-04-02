{ lib, config, pkgs, users, ... }:

let cfg = config.user.main;
in with lib; {
  options.user.main = { enable = mkEnableOption "Enable main user"; };

  config = mkIf cfg.enable {
    users = {
      defaultUserShell = pkgs.zsh;
      users = builtins.listToAttrs [{
        name = users.main.username;
        value = {
          # NOTE: You can set an initial password for your user.
          # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
          # Be sure to change it (using passwd) after rebooting!
          # initialPassword = "yourpassword";
          isNormalUser = true;

          openssh.authorizedKeys.keys = [ ];

          # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
          extraGroups = [
            "networkmanager"
            "wheel"
            "docker"
            "wireshark"
            "power"
            "postgres"
            "audio"
            "video"
            "input"
          ];
        };
      }];
    };
  };
}
