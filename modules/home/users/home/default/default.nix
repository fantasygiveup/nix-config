{ lib, config, user, ... }:
let cfg = config.users.home.default;
in with lib; {
  options.users.home.default = { enable = mkEnableOption "Enable main user"; };

  config = mkIf cfg.enable {
    home = {
      username = user.username;
      homeDirectory = user.homeDirectory;
    };
  };
}
