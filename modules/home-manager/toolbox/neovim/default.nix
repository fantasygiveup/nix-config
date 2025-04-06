{ lib, config, pkgs, ... }:
let cfg = config.toolbox.neovim;
in with lib; {
  options.toolbox.neovim = {
    enable = mkEnableOption "Enable neovim settings";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ unstable.neovim ]; };
}
