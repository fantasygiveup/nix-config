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

      rootPath = ./.;
    in {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
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
        # Run 'make nixos st321+gnome3'.
        "st321+gnome3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users rootPath;
            hostname = "st321";
          };
          modules = [ ./nixos/hosts/st321/configuration-gnome3.nix ];
        };

        # Run 'make nixos st321+i3'.
        "st321+i3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users rootPath;
            hostname = "st321";
          };
          modules = [ ./nixos/hosts/st321/configuration-i3.nix ];
        };

        # Run 'make nixos st321+hypr'.
        "st321+hypr" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users rootPath;
            hostname = "st321";
          };
          modules = [ ./nixos/hosts/st321/configuration-hypr.nix ];
        };

        # Run 'make nixos st123+gnome3'.
        "st123+gnome3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users rootPath;
            hostname = "st123"; # Lenovo laptop.
          };
          modules = [ ./nixos/hosts/st123/configuration-gnome3.nix ];
        };

        # Run 'make nixos st123+i3'.
        "st123+i3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users;
            hostname = "st123";
          };
          modules = [
            ./nixos/hosts/st123/configuration-i3.nix
            ./modules/common/colors/catppuccin_latte.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager switch --flake .#your-username@your-hostname'
      homeConfigurations = {
        # Run 'make home idanko@st321+gnome3'.
        "idanko@st321+gnome3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [
            ./home-manager/home-gnome3.nix
            ./modules/common/colors/catppuccin_latte.nix
          ];
        };

        # Run 'make home idanko@st321+gnome3+dark'.
        "idanko@st321+gnome3+dark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [
            ./home-manager/home-gnome3.nix
            ./modules/common/colors/catppuccin_mocha.nix
          ];
        };

        # Run 'make home idanko@st321+i3'.
        "idanko@st321+i3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [
            ./home-manager/home-i3.nix
            ./modules/common/colors/catppuccin_latte.nix
          ];
        };

        # Run 'make home idanko@st321+hypr'.
        "idanko@st321+hypr" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [
            ./home-manager/home-hypr.nix
            ./modules/common/colors/catppuccin_latte.nix
          ];
        };

        # Run 'make home idanko@st321+hypr+dark'.
        "idanko@st321+hypr+dark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [
            ./home-manager/home-hypr.nix
            ./modules/common/colors/catppuccin_latte.nix
          ];
        };

        # Run 'make home idanko@st321+i3+dark'.
        "idanko@st321+i3+dark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [
            ./home-manager/home-i3.nix
            ./modules/common/colors/catppuccin_mocha.nix
          ];
        };

        # Run 'make home idanko@st123+gnome3'.
        "idanko@st123+gnome3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [ ./home-manager/home-gnome3.nix ];
        };

        # Run 'make home idanko@st123+i3'.
        "idanko@st123+i3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs users rootPath; };
          modules = [ ./home-manager/home-i3.nix ];
        };
      };
    };
}
