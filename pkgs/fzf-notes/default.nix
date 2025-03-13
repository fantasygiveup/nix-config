{ lib, stdenv, pkgs }:
stdenv.mkDerivation {
  pname = "fzf-notes";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    substituteAll "${./fzf-notes.zsh}" "$out/bin/fzf-notes"
    # TODO: the binary is an overhead for this simple use case. Try to a simple derivation instead.
    substituteAll "${./fzf-notes-previewer}" "$out/bin/fzf-notes-previewer"
    chmod a+x "$out/bin"/*
    runHook postInstall
  '';

  meta = {
    description = "Fuzzy search notes";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
