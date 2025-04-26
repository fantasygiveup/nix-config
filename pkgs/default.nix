pkgs: rec {
  google-cloud-sdk-with-gke = pkgs.google-cloud-sdk.withExtraComponents
    [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ];
  bemenu-commander = pkgs.callPackage ./bemenu-commander { };
  rofi-commander = pkgs.callPackage ./rofi-commander { };
  erun = pkgs.callPackage ./erun { };
  x11-title = pkgs.callPackage ./x11-title { };
  i3-notification-status = pkgs.callPackage ./i3-notification-status { };
}
