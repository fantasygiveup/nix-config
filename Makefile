mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
	sudo /run/current-system/bin/switch-to-configuration boot

update:
	nix flake update

nixos:
	@if [ -z "$(filter $@,$(MAKECMDGOALS))" ]; then \
		echo "Please provide an argument: make $@ <argument>"; \
		exit 1; \
	fi
	@$(MAKE) --no-print-directory nixos-arg BASE=$@ ARG=$(word 2,$(MAKECMDGOALS))

nixos-arg:
	@sudo rm -rf /tmp/nixos.bak
	@sudo mv /etc/nixos /tmp/nixos.bak
	@sudo mkdir -p /etc/nixos
	@sudo cp -r "$(project_dir)"/* /etc/nixos
	@sudo nixos-rebuild switch --show-trace --upgrade --flake "/etc/nixos#$(ARG)"

home:
	@if [ -z "$(filter $@,$(MAKECMDGOALS))" ]; then \
		echo "Please provide an argument: make $@ <argument>"; \
		exit 1; \
	fi
	@$(MAKE) --no-print-directory homemanager-arg BASE=$@ ARG=$(word 2,$(MAKECMDGOALS))

homemanager-arg:
	@home-manager switch -b backup --show-trace --flake ".#$(ARG)"

# Prevent Make from treating `<argument>` as an unknown target
%:
	@true

.PHONY:  clean update nixos nixos-arg home homemanager-arg
