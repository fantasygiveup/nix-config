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

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/msteams" = [ "teams-for-linux.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/viber" = [ "viber.desktop" ];
    };
  };
}
