# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: rec {
  fdir = pkgs.callPackage ./fdir { };
  fzf-project = pkgs.callPackage ./fzf-project { };
}
