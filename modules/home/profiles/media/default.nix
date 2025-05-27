{ lib, config, pkgs, user, ... }:
let cfg = config.profiles.media;
in with lib; {
  options.profiles.media = { enable = mkEnableOption "Enable media profile"; };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "drawio" ];

    home.packages = with pkgs; [
      anki
      drawio
      espeak # speach-module for speechd
      evince
      foliate # awz3 viewer
      hunspell # required used by libreoffice
      hunspellDicts.uk_UA # hunspell dictionary
      imv # image viewer
      libreoffice-fresh
      mpv
      mupdf # simple pdf viewer
      shotcut # video editor
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

    services.rclone-mount = {
      enable = true;
      mount = {
        remote = "gdrive";
        local = "${user.sharedDirectory}/gdrive";
      };
      package = pkgs.unstable.rclone;
    };
  };
}
