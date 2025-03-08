mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
	sudo /run/current-system/bin/switch-to-configuration boot

update:
	nix flake update

os:
	@if [ -z "$(filter $@,$(MAKECMDGOALS))" ]; then \
		echo "Please provide an argument: make $@ <argument>"; \
		exit 1; \
	fi
	@$(MAKE) --no-print-directory os-arg BASE=$@ ARG=$(word 2,$(MAKECMDGOALS))

os-arg:
	@sudo cp -r "$(project_dir)"/* /etc/nixos
	@sudo nixos-rebuild switch --show-trace --upgrade --flake "/etc/nixos#$(ARG)"

home:
	@if [ -z "$(filter $@,$(MAKECMDGOALS))" ]; then \
		echo "Please provide an argument: make $@ <argument>"; \
		exit 1; \
	fi
	@$(MAKE) --no-print-directory home-arg BASE=$@ ARG=$(word 2,$(MAKECMDGOALS))

home-arg:
	@home-manager switch --flake ".#$(ARG)"

# Prevent Make from treating `<argument>` as an unknown target
%:
	@true

.PHONY:  clean update os os-arg home home-arg
