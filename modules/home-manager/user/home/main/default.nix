{ lib, config, users, ... }:
let cfg = config.user.home.main;
in with lib; {
  options.user.home.main = { enable = mkEnableOption "Enable home main user"; };

  config = mkIf cfg.enable {
    home = {
      username = users.main.username;
      homeDirectory = users.main.homeDirectory;
    };
  };
}
