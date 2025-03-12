{ lib, config, pkgs, ... }:

let cfg = config.misc.wezterm-plus-tmux;
in {
  options.misc.wezterm-plus-tmux = {
    enable = lib.mkEnableOption "Enable wezterm plus tmux configuration";
  };

  # TODO: integrate with dark theme.
  config = lib.mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;

    programs.wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
      extraConfig = "";
    };

    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
    programs.tmux.enable = true;
  };
}
