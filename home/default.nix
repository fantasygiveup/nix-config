{ inputs, outputs, lib, config, pkgs, ... }:

with lib; {
  imports = outputs.homeManagerModules;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  services.cliphist-clipboard.enable = true;
  services.secrets.enable = true;
  # Nicely reload system units when changing configs.
  systemd.user.startServices = "sd-switch";

  toolbox.core.enable = true;
  toolbox.neovim.enable = true;
  toolbox.wezterm.enable = true;
  toolbox.lf.enable = true;
  toolbox.lazygit.enable = true;
  toolbox.zk.enable = true;
  toolbox.fzf.project-zsh.enable = true;
  toolbox.fzf.notes-zsh.enable = true;
  toolbox.eza.enable = true;

  techops.dev.enable = true;
  techops.git.enable = true;
  techops.grep.enable = true;
  techops.net.enable = true;
  techops.os.enable = true;
  techops.virt.enable = true;

  users.home.default.enable = true;

  profiles.global.enable = true;
  profiles.shell.enable = true;
  profiles.browsing.enable = true;
  profiles.email.enable = true;
  profiles.social.enable = true;
  profiles.media.enable = true;
  profiles.creative.enable = true;

  misc.minecraft.enable = true;

  home.stateVersion = "24.11";
}
