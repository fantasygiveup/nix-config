{ ... }: {
  imports = [ ./global.nix ];

  wm.hypr.enable = true;

  home.stateVersion = "25.05";
}
