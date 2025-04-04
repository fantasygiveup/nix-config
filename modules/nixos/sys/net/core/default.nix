{ lib, config, hostname, users, ... }:

let cfg = config.sys.net.core;
in with lib; {
  options.sys.net.core = {
    enable = mkEnableOption "Enable system networking core settings";
  };

  config = mkIf cfg.enable {
    networking.hostName = hostname;
    networking.networkmanager.enable = true;
    users = {
      users = builtins.listToAttrs [{
        name = users.main.username;
        value = { extraGroups = [ "networkmanager" ]; };
      }];
    };
  };
}
