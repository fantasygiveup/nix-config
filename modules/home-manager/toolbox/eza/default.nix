{ lib, config, ... }:
let cfg = config.toolbox.eza;
in with lib; {
  options.toolbox.eza = {
    enable = mkEnableOption "Enable eza 'ls' alternative";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      extraOptions = [ "--group-directories-first" "--header" ];
      icons = "auto";
    };
  };
}
