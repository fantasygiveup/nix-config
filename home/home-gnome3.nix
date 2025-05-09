{ ... }: {
  imports = [ ./default.nix ];

  wm.gnome3.enable = true;

  home.stateVersion = "24.11";
}
