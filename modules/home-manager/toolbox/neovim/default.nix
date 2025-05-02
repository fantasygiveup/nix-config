{ lib, config, pkgs, ... }:
let
  cfg = config.toolbox.neovim;
  color = config.color;
in with lib; {
  options.toolbox.neovim = {
    enable = mkEnableOption "Enable neovim settings";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ unstable.neovim ];

    xdg.configFile."nvim/lua/color.lua".text =
      # lua
      ''
        vim.o.background = "${color.variant}";
      '';
  };
}
