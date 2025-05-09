{ lib, config, pkgs, ... }:
let cfg = config.profile.media;
in with lib; {
  options.profile.media = { enable = mkEnableOption "Enable media profile"; };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "drawio" ];

    home.packages = with pkgs; [
      anki
      drawio
      espeak # speach-module for speechd
      evince
      foliate # awz3 viewer
      imv # image viewer
      mpv
      speechd # speech-dispatcher for foliate
      unstable.qbittorrent
      unstable.yt-dlp
      vlc
      zk # zettelkasten cli
      zotero # citation tool
    ];

    xdg.mimeApps.defaultApplications = {
      "video/webm" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
}
