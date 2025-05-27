{ lib, config, pkgs, ... }:
let cfg = config.profiles.social;
in with lib; {
  options.profiles.social = {
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
      zapzap
    ];

    # Zoom in Teams.
    xdg.configFile."teams-for-linux/settings.json".source =
      ./teams-for-linux/settings.json;

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/msteams" = [ "teams-for-linux.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/viber" = [ "viber.desktop" ];
    };

    accounts.email.accounts = {
      main = { primary = true; };
      gmail = { };
      sirona = { };
      sirona2 = { };
      strong = { };
    };

    programs.thunderbird = {
      enable = true;
      profiles = { default = { isDefault = true; }; };
    };
  };
}
