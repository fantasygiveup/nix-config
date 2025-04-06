{ lib, config, users, ... }:
let cfg = config.toolkit.wireshark;
in with lib; {
  options.toolkit.wireshark = {
    enable = mkEnableOption "Enable wireshark setting";
  };

  config = mkIf cfg.enable {
    programs.wireshark.enable = true;
    users = {
      users = builtins.listToAttrs [{
        name = users.main.username;
        value = { extraGroups = [ "wireshark" ]; };
      }];
    };
  };
}
