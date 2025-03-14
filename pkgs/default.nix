pkgs: rec {
  google-cloud-sdk-with-gke = (pkgs.google-cloud-sdk.withExtraComponents
    [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ]);
  fzf-project = pkgs.callPackage ./fzf-project { };
  fzf-notes = pkgs.callPackage ./fzf-notes { };
  bemenu-commander = pkgs.callPackage ./bemenu-commander { };
  erun = pkgs.callPackage ./erun { };
}
