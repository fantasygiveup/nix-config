{ lib, config, pkgs, ... }:
let cfg = config.profiles.browsing;
in with lib; {
  options.profiles.browsing = {
    enable = mkEnableOption "Enable the Internet browsing profile";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "google-chrome" "opera" ];
    programs.firefox = {
      enable = true;
      policies = { DefaultDownloadDirectory = "\${home}/Downloads"; };
      profiles = {
        main = {
          id = 0;
          name = "main";
        };
        sirona = {
          id = 1;
          name = "sirona";
        };
        strong = {
          id = 2;
          name = "strong";
        };
        lux = {
          id = 3;
          name = "lux";
        };
      };
    };

    home.packages = with pkgs; [ google-chrome opera lynx ];

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };
}
