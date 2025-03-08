mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
	sudo /run/current-system/bin/switch-to-configuration boot

upgrade:
	nix flake update

# Note: to make it work for both the home-manager flake and the nixosConfigurations flake I use the
# same attribute name.
%:
	sudo cp -R "$(project_dir)"/home-manager "$(project_dir)"/modules "$(project_dir)"/nixos "$(project_dir)"/overlays "$(project_dir)"/pkgs "$(project_dir)"/flake.nix "$(project_dir)"/flake.lock /etc/nixos
	sudo nixos-rebuild switch --show-trace --upgrade --flake /etc/nixos#$(@:%=%)
	home-manager switch --flake .#$(@:%=%)

.PHONY: purge upgrade
