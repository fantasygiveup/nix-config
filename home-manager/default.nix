{ inputs, outputs, lib, config, pkgs, users, ... }:

with lib; {
  imports = builtins.attrValues outputs.homeManagerModules ++ [ ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  services.cliphist-clipboard.enable = true;
  services.gpg.enable = true;
  services.sd-switch.enable = true;

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

  user.home.main.enable = true;

  shell.env.vars.enable = true;
  shell.zsh.enable = true;
  shell.starship.enable = true;

  profile.appearance.enable = true;
  profile.browsing.enable = true;
  profile.mailing.enable = true;
  profile.social.enable = true;
  profile.media.enable = true;
  profile.creative.enable = true;

  misc.minecraft.enable = true;

  home.stateVersion = "24.11";
}
