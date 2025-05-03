{
  "common" = import ../common;

  "services/cliphist-clipboard" = import ./services/cliphist-clipboard;
  "services/gpg" = import ./services/gpg;
  "services/sd-switch" = import ./services/sd-switch;

  "toolbox/core" = import ./toolbox/core;
  "toolbox/neovim" = import ./toolbox/neovim;
  "toolbox/wezterm-plus-tmux" = import ./toolbox/wezterm-plus-tmux;
  "toolbox/wezterm" = import ./toolbox/wezterm;
  "toolbox/lf" = import ./toolbox/lf;
  "toolbox/lazygit" = import ./toolbox/lazygit;
  "toolbox/zk" = import ./toolbox/zk;
  "toolbox/eza" = import ./toolbox/eza;
  "toolbox/fzf/notes-zsh" = import ./toolbox/fzf/notes-zsh;

  "wm/appearance" = import ./wm/appearance;
  "wm/gnome3" = import ./wm/gnome3;
  "wm/i3" = import ./wm/i3;

  "techops/dev" = import ./techops/dev;
  "techops/git" = import ./techops/git;
  "techops/grep" = import ./techops/grep;
  "techops/net" = import ./techops/net;
  "techops/os" = import ./techops/os;
  "techops/virt" = import ./techops/virt;

  "user/home/main" = import ./user/home/main;

  "shell/zsh" = import ./shell/zsh;
  "shell/env/vars" = import ./shell/env/vars;
  "shell/starship" = import ./shell/starship;

  # TODO: move the modules above to profiles.
  "profile/browsing" = import ./profile/browsing;
  "profile/mailing" = import ./profile/mailing;
  "profile/social" = import ./profile/social;
  "profile/media" = import ./profile/media;
  "profile/creative" = import ./profile/creative;

  "misc/minecraft" = import ./misc/minecraft;
}
