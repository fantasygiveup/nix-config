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

  "wm/gnome3" = import ./wm/gnome3;
  "wm/i3" = import ./wm/i3;
  "wm/hypr" = import ./wm/hypr;

  "techops/dev" = import ./techops/dev;
  "techops/git" = import ./techops/git;
  "techops/grep" = import ./techops/grep;
  "techops/net" = import ./techops/net;
  "techops/os" = import ./techops/os;
  "techops/virt" = import ./techops/virt;

  "user/home/main" = import ./user/home/main;

  # TODO: move the modules above to profiles.
  "profile/shell" = import ./profile/shell;
  "profile/browsing" = import ./profile/browsing;
  "profile/mailing" = import ./profile/mailing;
  "profile/social" = import ./profile/social;
  "profile/media" = import ./profile/media;
  "profile/creative" = import ./profile/creative;
  "profile/appearance" = import ./profile/appearance;

  "misc/minecraft" = import ./misc/minecraft;
}
