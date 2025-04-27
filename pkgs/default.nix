pkgs: rec {
  google-cloud-sdk-with-gke = pkgs.google-cloud-sdk.withExtraComponents
    [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ];
  bemenu-commander = pkgs.callPackage ./bemenu-commander { };
  rofi-commander = pkgs.callPackage ./rofi-commander { };
  erun = pkgs.callPackage ./erun { };
  i3-current-window-title = pkgs.callPackage ./i3-current-window-title { };
  i3-notification-status = pkgs.callPackage ./i3-notification-status { };
}
