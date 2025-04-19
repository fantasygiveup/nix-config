pkgs: rec {
  google-cloud-sdk-with-gke = pkgs.google-cloud-sdk.withExtraComponents
    [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ];
  bemenu-commander = pkgs.callPackage ./bemenu-commander { };
  rofi-commander = pkgs.callPackage ./rofi-commander { };
  erun = pkgs.callPackage ./erun { };
  cpu-usage = pkgs.callPackage ./cpu-usage { };
  mem-usage = pkgs.callPackage ./mem-usage { };
  dunstctl-count-history = pkgs.callPackage ./dunstctl-count-history { };
}
