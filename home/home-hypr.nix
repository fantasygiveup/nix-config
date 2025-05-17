{ ... }: {
  imports = [ ./global.nix ];

  wm.hypr.enable = true;

  home.stateVersion = "24.11";
}
