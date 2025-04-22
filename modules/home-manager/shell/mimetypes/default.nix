{ lib, config, ... }:

let cfg = config.shell.mimetypes;
in with lib; {
  options.shell.mimetypes = {
    enable = mkEnableOption "Associate files with applications";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = { OPENER = "xdg-open"; };

    # Most of the *.desktop files are placed into ~/.nix-profile/share/applications.
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "video/webm" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
      };
    };
  };
}
