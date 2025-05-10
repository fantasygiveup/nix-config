{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = outputs.nixosModules;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = { };
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

  programs.zsh.enable = true;

  users.default.enable = true;
  misc.fonts.core.enable = true;
  toolkit.core.enable = true;
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
}
