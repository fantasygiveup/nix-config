{ lib, stdenv, pkgs }:
stdenv.mkDerivation rec {
  pname = "fzf-project";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    substituteAll "${./fzf-project.zsh}" "$out/bin/fzf-project"
    chmod a+x "$out/bin"/*
    runHook postInstall
  '';

  meta = {
    description = "Fuzzy finder project directories";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
