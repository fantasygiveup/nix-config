# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other NixOS modules here
  imports = (builtins.attrValues outputs.nixosModules) ++ [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.gigabyte-b650

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = { allowUnfree = true; };
  };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  user.main.enable = true;
  misc.fonts.core.enable = true;
  toolkit.core.enable = true;
  toolkit.de.gnome3.enable = true;
  toolkit.extra.enable = true;
  toolkit.postgres = {
    enable = true;
    trust-localhost = true;
  };
  toolkit.wireshark.enable = true;
  toolkit.mullvad-vpn.enable = true;
  toolkit.net.enable = true;
  toolkit.gnupg.enable = true;
  sys.time.enable = true;
  sys.net.core.enable = true;
  sys.i18n.enable = true;
  sys.media.sound.enable = true;
  sys.media.bluetooth.enable = true;
  sys.media.printing.enable = true;
  sys.virt.docker.enable = true;

  # To make the linker (ldd) works with the not nix native binaries.
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
