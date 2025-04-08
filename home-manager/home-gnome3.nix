{ ... }: {
  imports = [ ./default.nix ];

  de.gnome3.enable = true;

  home.stateVersion = "24.11";
}
