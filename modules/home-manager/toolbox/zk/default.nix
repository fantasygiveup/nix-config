{ lib, config, ... }:

let cfg = config.toolbox.zk;
in {
  options.toolbox.zk = {
    enable = lib.mkEnableOption "Enable zettelkasten cli";
  };

  config = lib.mkIf cfg.enable {
    programs.zk = { enable = true; };

    xdg.configFile."zk/config.toml".source = ./config.toml;

    home.sessionVariables = {
      ZK_NOTEBOOK_DIR = "$HOME/github.com/fantasygiveup/zettelkasten";
    };
  };
}
