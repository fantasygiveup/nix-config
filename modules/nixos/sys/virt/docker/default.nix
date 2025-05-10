{ lib, config, users, ... }:
let cfg = config.sys.virt.docker;
in with lib; {
  options.sys.virt.docker = {
    enable = mkEnableOption "Enable docker settings";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    users = {
      users = builtins.listToAttrs [{
        name = users.default.username;
        value = { extraGroups = [ "docker" ]; };
      }];
    };
  };
}
