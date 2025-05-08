{ lib, stdenv, pkgs, }:
stdenv.mkDerivation {
  pname = "rofi-commander";
  version = "1.0.0";
  # Avoid the "> variable $src or $srcs should point to the source" error.
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    substituteAll "${./rofi-commander.sh}" "$out/bin/rofi-commander"
    chmod a+x "$out/bin"/*
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --prefix PATH : "${
          lib.makeBinPath [
            pkgs.cliphist
            pkgs.dunst
            pkgs.gnupg
            pkgs.jq
            pkgs.libnotify
            pkgs.rofi
            pkgs.xsel
          ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "The utility wraps useful commands with rofi.";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/fantasygiveup/nix-config";
  };
}
