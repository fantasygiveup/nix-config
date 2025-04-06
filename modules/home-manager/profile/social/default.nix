{ lib, config, pkgs, ... }:
let cfg = config.profile.social;
in with lib; {
  options.profile.social = {
    enable = mkEnableOption "Enable social media profile";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "discord" "slack" "viber" ];

    home.packages = with pkgs; [
      discord
      slack
      telegram-desktop
      unstable.signal-desktop
      unstable.teams-for-linux
      viber
    ];
  };
}
