{
  "services/cliphist-clipboard" = import ./services/cliphist-clipboard;
  "services/gpg" = import ./services/gpg;
  "services/sd-switch" = import ./services/sd-switch;

  "toolbox/wezterm-plus-tmux" = import ./toolbox/wezterm-plus-tmux;
  "toolbox/lf" = import ./toolbox/lf;
  "toolbox/lazygit" = import ./toolbox/lazygit;
  "toolbox/zk" = import ./toolbox/zk;
  "toolbox/eza" = import ./toolbox/eza;
  "toolbox/fzf/notes-zsh" = import ./toolbox/fzf/notes-zsh;

  "environment/gnome3" = import ./environment/gnome3;

  "techops/dev" = import ./techops/dev;
  "techops/git" = import ./techops/git;
  "techops/grep" = import ./techops/grep;
  "techops/net" = import ./techops/net;
  "techops/os" = import ./techops/os;

  "user/home/main" = import ./user/home/main;

  "shell/zsh" = import ./shell/zsh;
  "shell/env/vars" = import ./shell/env/vars;
  "shell/starship" = import ./shell/starship;
}
