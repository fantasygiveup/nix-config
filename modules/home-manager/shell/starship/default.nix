{ lib, config, ... }:

let cfg = config.shell.starship;
in with lib; {
  options.shell.starship = {
    enable = mkEnableOption "Enable starship shell prompt";
  };

  config = mkIf cfg.enable {
    # The modern shell prompt.
    # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
    programs.starship = {
      enable = true;
      settings = {
        gcloud = {
          # The active gcloud account is always enabled, causing disturbances. Disable it.
          disabled = true;
        };
      };
    };
  };
}
