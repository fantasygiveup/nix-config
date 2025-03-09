{ lib, stdenv, pkgs }:
stdenv.mkDerivation {
  pname = "bemenu-commander";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    substituteAll "${./bemenu-commander.sh}" "$out/bin/bemenu-commander"
    chmod a+x "$out/bin"/*
    runHook postInstall
  '';

  meta = {
    description = "The utility wraps useful commands with bemenu.";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
