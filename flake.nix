{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware.
    hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, hardware, ... }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      users.main = {
        username = "idanko";
        homeDirectory = "/home/idanko";
      };
    in {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild switch --flake .#your-hostname'
      nixosConfigurations = {
        # Run 'make nixos st321'.
        st321 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users;
            hostname = "st321";
          };
          modules = [ ./nixos/configuration.nix ];
        };

        # Run 'make nixos st123'.
        st123 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users;
            hostname = "st123";
          };
          modules = [ ./nixos/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager switch --flake .#your-username@your-hostname'
      homeConfigurations = {
        # Run 'make home idanko@st321'.
        "idanko@st321" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users; };
          modules = [ ./home-manager/home.nix ];
        };

        # Run 'make home idanko@st123'.
        "idanko@st123" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users; };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
