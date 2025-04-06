{ lib, config, pkgs, services, users, ... }:
let cfg = config.toolkit.postgres;
in with lib; {
  options.toolkit.postgres = {
    enable = mkEnableOption "Enable postgres service configuration";

    trust-localhost = mkOption {
      type = types.bool;
      default = false;
      description =
        "Whether to trust to localhost access. Userful for development";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.postgresql.enable = true;
      users = {
        users = builtins.listToAttrs [{
          name = users.main.username;
          value = { extraGroups = [ "postgres" ]; };
        }];
      };
    })

    (mkIf cfg.trust-localhost {
      services.postgresql.authentication = mkOverride 10 ''
        # default value of services.postgresql.authentication
        local all all              trust
        host  all all 127.0.0.1/32 trust
        host  all all ::1/128      trust
      '';
    })
  ];
}
