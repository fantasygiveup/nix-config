{ lib, config, pkgs, ... }:

let cfg = config.profile.media;
in with lib; {
  options.profile.media = { enable = mkEnableOption "Enable media profile"; };

  config = mkIf cfg.enable {
    nixpkgs.allowedUnfree = [ "drawio" ];

    home.packages = with pkgs; [
      unstable.qbittorrent
      unstable.yt-dlp
      vlc
      drawio
      espeak # speach-module for speechd
      foliate # awz3 viewer
      imv # image viewer
      anki
      speechd # speech-dispatcher for foliate
      zk # zettelkasten cli
      mpv
      zotero # citation tool
    ];
  };
}
