{ lib, config, pkgs, ... }:
let cfg = config.toolbox.wezterm-plus-tmux;
in with lib; {
  options.toolbox.wezterm-plus-tmux = {
    enable = mkEnableOption "Enable wezterm plus tmux configuration";
  };

  # TODO: integrate with dark theme.
  config = mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;

    programs.wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
      extraConfig = "";
    };

    # TODO: revisit plugins.
    xdg.configFile."tmux/tmux.conf".source = ./tmux/tmux.conf;
    xdg.configFile."tmux/status-line.tmux".source = ./tmux/status-line.tmux;
    programs.tmux.enable = true;

    home.packages = with pkgs; [ dunstctl-count-history ];
  };
}
