{ lib, config, pkgs, ... }:
let cfg = config.toolbox.fzf.project-zsh;
in {
  options.toolbox.fzf.project-zsh = {
    enable = lib.mkEnableOption "Enable fzf-project for zsh";
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/misc/fzf-project.zsh".source = ./fzf-project.zsh;
    programs.zsh = {
      initExtra = ''
        . ~/.config/misc/fzf-project.zsh
        bindkey '^g' _fzf_project
      '';
    };
    home.packages =
      [ pkgs.fd pkgs.fzf pkgs.perl pkgs.ripgrep pkgs.tree pkgs.zsh ];
  };
}
