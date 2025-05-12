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

      users.default = rec {
        username = "idanko";
        homeDirectory = "/home/${username}";
        sharedDirectory = "/home/${username}/Shared";
      };

      flakePath = ./.;

      sharedModules =
        [ ./modules/allowed-unfree.nix ./modules/colors/catppuccin_latte.nix ];

      sharedModulesDarkTheme =
        [ ./modules/allowed-unfree.nix ./modules/colors/catppuccin_mocha.nix ];
    in {
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosModules =
        import ./modules/nixos/modules.nix { inherit (nixpkgs) lib; };

      homeManagerModules =
        import ./modules/home/modules.nix { inherit (nixpkgs) lib; };

      nixosConfigurations = {
        "st321+gnome3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users flakePath;
            hostname = "st321";
          };
          modules = [ ./nixos/hosts/st321/configuration-gnome3.nix ]
            ++ sharedModules;
        };

        # Run 'make nixos st321+i3'.
        "st321+i3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users flakePath;
            hostname = "st321";
          };
          modules = [ ./nixos/hosts/st321/configuration-i3.nix ]
            ++ sharedModules;
        };

        # Run 'make nixos st321+hypr'.
        "st321+hypr" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users flakePath;
            hostname = "st321";
          };
          modules = [ ./nixos/hosts/st321/configuration-hypr.nix ]
            ++ sharedModules;
        };

        # Run 'make nixos st123+gnome3'.
        "st123+gnome3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users flakePath;
            hostname = "st123"; # Lenovo laptop.
          };
          modules = [ ./nixos/hosts/st123/configuration-gnome3.nix ]
            ++ sharedModules;
        };

        # Run 'make nixos st123+i3'.
        "st123+i3" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs users flakePath;
            hostname = "st123";
          };
          modules = [ ./nixos/hosts/st123/configuration-i3.nix ]
            ++ sharedModules;
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager switch --flake .#your-username@your-hostname'
      homeConfigurations = {
        # Run 'make home idanko@st321+gnome3'.
        "idanko@st321+gnome3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-gnome3.nix ] ++ sharedModules;
        };

        # Run 'make home idanko@st321+gnome3+dark'.
        "idanko@st321+gnome3+dark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            inherit (users) default;
          };
          modules = [ ./home/home-gnome3.nix ] ++ sharedModulesDarkTheme;
        };

        # Run 'make home idanko@st321+i3'.
        "idanko@st321+i3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-i3.nix ] ++ sharedModules;
        };

        # Run 'make home idanko@st321+hypr'.
        "idanko@st321+hypr" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-hypr.nix ] ++ sharedModules;
        };

        # Run 'make home idanko@st321+hypr+dark'.
        "idanko@st321+hypr+dark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-hypr.nix ] ++ sharedModulesDarkTheme;
        };

        # Run 'make home idanko@st321+i3+dark'.
        "idanko@st321+i3+dark" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-i3.nix ] ++ sharedModulesDarkTheme;
        };

        # Run 'make home idanko@st123+gnome3'.
        "idanko@st123+gnome3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-gnome3.nix ] ++ sharedModules;
        };

        # Run 'make home idanko@st123+i3'.
        "idanko@st123+i3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs flakePath;
            user = users.default;
          };
          modules = [ ./home/home-i3.nix ] ++ sharedModules;
        };
      };
    };
}
