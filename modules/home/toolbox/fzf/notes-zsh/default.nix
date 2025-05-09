{ lib, config, pkgs, ... }:
let cfg = config.toolbox.fzf.notes-zsh;
in with lib; {
  options.toolbox.fzf.notes-zsh = {
    enable = mkEnableOption "Enable fzf-notes for zsh";
  };

  config = mkIf cfg.enable {
    home.file.".config/misc/fzf-notes.zsh".source = ./fzf-notes.zsh;
    home.file.".config/misc/fzf-notes-previewer".source = ./fzf-notes-previewer;

    programs.zsh = {
      initExtra = ''
        . ~/.config/misc/fzf-notes.zsh
        stty -ixon # unbind ctrl-s
        bindkey '^s' _fzf_notes
        export FZF_NOTES_PREVIEWER=~/.config/misc/fzf-notes-previewer
      '';
    };
    home.packages = [ pkgs.fzf pkgs.python3 pkgs.ripgrep pkgs.zsh ];
  };
}
