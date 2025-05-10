{ lib, config, pkgs, users, ... }:
let cfg = config.users.default;
in with lib; {
  options.users.default = { enable = mkEnableOption "Enable main user"; };

  config = mkIf cfg.enable {
    users = {
      defaultUserShell = pkgs.zsh;
      users = builtins.listToAttrs [{
        name = users.default.username;
        value = {
          # NOTE: You can set an initial password for your user.
          # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
          # Be sure to change it (using passwd) after rebooting!
          # initialPassword = "yourpassword";
          isNormalUser = true;

          openssh.authorizedKeys.keys = [ ];

          extraGroups = [ "wheel" "power" "video" "input" ];
        };
      }];
    };
  };
}
