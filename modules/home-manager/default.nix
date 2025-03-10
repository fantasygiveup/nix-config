# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;

  cliphist-clipboard-service = import ./cliphist-clipboard-service.nix;
  gitconfig = import ./gitconfig.nix;
  dconfiguration = import ./dconfiguration.nix;
}
