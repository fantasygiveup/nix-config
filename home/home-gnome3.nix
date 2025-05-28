{ ... }: {
  imports = [ ./global.nix ];

  wm.gnome3.enable = true;

  home.stateVersion = "25.05";
}
