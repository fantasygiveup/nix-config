{ lib, config, ... }:

let cfg = config.toolbox.zk;
in with lib; {
  options.toolbox.zk = { enable = mkEnableOption "Enable zettelkasten cli"; };

  config = mkIf cfg.enable {
    programs.zk = { enable = true; };

    xdg.configFile."zk/config.toml".source = ./config.toml;

    home.sessionVariables = {
      ZK_NOTEBOOK_DIR = "$HOME/github.com/fantasygiveup/zettelkasten";
    };
  };
}
