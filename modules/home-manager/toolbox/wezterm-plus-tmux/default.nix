{ lib, config, pkgs, ... }:
let
  cfg = config.toolbox.wezterm-plus-tmux;
  color = config.color;

in with lib; {
  options.toolbox.wezterm-plus-tmux = {
    enable = mkEnableOption "Enable wezterm plus tmux configuration";
  };

  config = mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source =
      pkgs.substituteAll (mergeAttrs { src = ./wezterm/wezterm.lua; } color);

    programs.wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
      extraConfig = "";
    };

    # TODO: revisit the plugin manager.
    xdg.configFile."tmux/tmux.conf".source = ./tmux/tmux.conf;
    xdg.configFile."tmux/status-line.tmux".executable = true;
    xdg.configFile."tmux/status-line.tmux".source =
      pkgs.substituteAll (mergeAttrs { src = ./tmux/status-line.tmux; } color);
    programs.tmux.enable = true;
  };
}
