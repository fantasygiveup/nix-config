{ ... }: {
  imports = [ ./default.nix ];

  wm.hypr.enable = true;

  home.stateVersion = "24.11";
}
