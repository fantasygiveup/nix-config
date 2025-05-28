{ inputs, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.gigabyte-b650

    ../default.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland";
  };

  programs.hyprland.enable = true;

  # Pam must be configured to perform authentication.
  security = {
    pam.services.hyprlock = { };
    polkit.enable = true;
  };
  # programs.hyprland.package =
  #   inputs.hyprland.packages."${pkgs.system}".hyprland;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
