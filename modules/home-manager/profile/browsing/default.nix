{ lib, config, pkgs, ... }:
let cfg = config.profile.browsing;
in with lib; {
  options.profile.browsing = {
    enable = mkEnableOption "Enable the Internet browsing profile";
  };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "google-chrome" "opera" ];

    home.packages = with pkgs; [ google-chrome firefox opera lynx ];

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      "x-scheme-handler/about" = [ "google-chrome.desktop" ];
      "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
    };
  };
}
